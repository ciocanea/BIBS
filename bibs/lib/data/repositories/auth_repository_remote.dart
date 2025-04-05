import 'package:jwt_decoder/jwt_decoder.dart';
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

  String? _authToken;
  bool? _isAuthenticated;

  Future<void> _fetch() async {
    final sharedPreferencesResult = await _sharedPreferencesService.fetchToken();
    switch (sharedPreferencesResult) {
      case Ok<String?>():
        _authToken = sharedPreferencesResult.value;
      case Error<String?>():
        final result = await _authClient.currentSession();
        switch (result) {
          case Ok<Session?>():
            _authToken = result.value?.accessToken;
          case Error<Session?>():
            print('Failed to fetch access token.');
        }
    }
  }

  Future<bool> _refreshSession() async {
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
          return Result.ok(null);
        case Error<AuthResponse>():
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
          if(session == null) {
            return Result.error(Exception('Session is null.'));
          }
          
          _authToken = session.accessToken;
          _isAuthenticated = true;

          return await _sharedPreferencesService.saveToken(session.accessToken);
        case Error<AuthResponse>():
          return Result.error(result.error);
      }
    }
    finally {
      notifyListeners();
    }
  }
  
  @override
  Future<Result<void>> signOut () async{
    final result = await _authClient.signOut();

    switch (result) {
      case Ok<void>():
        _authToken = null;
        _isAuthenticated = false;

        return await _sharedPreferencesService.saveToken(null);
      case Error<void>():
        return Result.error(result.error);
    }
  }
}