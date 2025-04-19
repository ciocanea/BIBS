import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:logging/logging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/local/shared_prefrences_service.dart';
import 'auth_repository.dart';
import '../../utils/result.dart';
import '../services/api/auth_api.dart';

class AuthRepositoryRemote extends AuthRepository {
  AuthRepositoryRemote({
    required AuthClient authClient,
    required SharedPreferencesService sharedPreferencesService,
  }) : _authClient = authClient,
       _sharedPreferencesService = sharedPreferencesService;

  final AuthClient _authClient;
  final SharedPreferencesService _sharedPreferencesService;

  final _log = Logger('AuthRepositoryRemote');

  String? _authToken;
  bool? _isAuthenticated;
  
  @override
  bool get resetTrigger => _isAuthenticated ?? false;

  Future<void> _fetch () async {
    final sharedPreferencesResult = await _sharedPreferencesService.fetchToken();
    switch (sharedPreferencesResult) {
      case Ok<String?>():
        _authToken = sharedPreferencesResult.value;
      case Error<String?>():
        final authResult = await _authClient.currentSession();
        switch (authResult) {
          case Ok<Session?>():
            _authToken = authResult.value?.accessToken;
          case Error<Session?>():
            _log.warning('Failed to fetch access token from current session.');
        }
    }
  }

  Future<bool> _refreshSession () async {
    final refreshResult = await _authClient.refreshSession();
    switch (refreshResult) {
      case Ok<AuthResponse>():
        final session = refreshResult.value.session;
        if (session == null) {
          return false;
        }

        _authToken = session.accessToken;
        await _sharedPreferencesService.saveToken(_authToken!);
        return true;
      case Error<AuthResponse>():
        _authToken = null;
        await _sharedPreferencesService.saveToken(null);
        _log.warning('Failed to refresh session: ${refreshResult.error}');
        return false;
    }
  }


  @override
  Future<bool> get isAuthenticated async {
    if(_authToken == null) {
      await _fetch();
    }

    if (_authToken == null) {
      _isAuthenticated = false;
      return false;
    }

    if(JwtDecoder.isExpired(_authToken!)) {
      _isAuthenticated = await _refreshSession();
      return _isAuthenticated!;
    }

    _isAuthenticated = true;
    return true;
  }

  @override
  Future<Result<void>> signUpWithEmailPassword ({required String email, required String password}) async {
    try {
      final result = await _authClient.signUpWithEmailPassword(email, password);

      switch (result) {
        case Ok<AuthResponse>():
          final session = result.value.session; 
          final user = result.value.user;

          if(session == null) {
            _log.warning('Sign up failed: Session is null.');
            return Result.error(Exception('Session is null.'));
          }

          if(user == null) {
            _log.warning('Sign up failed: User is null.');
            return Result.error(Exception('User is null.'));
          }

          _authToken = session.accessToken;
          _isAuthenticated = true;

          await _sharedPreferencesService.saveUserId(user.id);
          await _sharedPreferencesService.saveToken(session.accessToken);

          _log.info('Sign up successful. Token and user ID saved.');
          return Result.ok(null);
        case Error<AuthResponse>():
          _log.severe('Sign up failed: ${result.error}');
          return Result.error(result.error);
      }
    }
    finally {
      notifyListeners();
    }
  }

  @override
  Future<Result<void>> signInWithEmailPassword ({required String email, required String password}) async {
    try {
      final result = await _authClient.signInWithEmailPassword(email, password);

      switch (result) {
        case Ok<AuthResponse>():
          final session = result.value.session; 
          final user = result.value.user;

          if(session == null) {
            _log.warning('Sign in failed: Session is null.');
            return Result.error(Exception('Session is null.'));
          }

          if(user == null) {
            _log.warning('Sign in failed: User is null.');
            return Result.error(Exception('User is null.'));
          }

          _authToken = session.accessToken;
          _isAuthenticated = true;

          await _sharedPreferencesService.saveUserId(user.id);
          await _sharedPreferencesService.saveToken(session.accessToken);

          _log.info('Sign in successful. Token and user ID saved.');
          return Result.ok(null);
        case Error<AuthResponse>():
          _log.severe('Sign in failed: ${result.error}');
          return Result.error(result.error);
      }
    }
    finally {
      notifyListeners();
    }
  }
  
  @override
  Future<Result<void>> signOut () async {
    try {
      final result = await _authClient.signOut();

      switch (result) {
        case Ok<void>():
          _authToken = null;
          _isAuthenticated = false;

          await _sharedPreferencesService.saveToken(null);
          await _sharedPreferencesService.saveUserId(null);

          _log.info('Sign out successful. Token and user ID cleared.');
          return Result.ok(null);
        case Error<void>():
          _log.severe('Sign out failed: ${result.error}');
          return Result.error(result.error);
      }
    }
    finally {
      notifyListeners();
    }
  }
}