import 'package:supabase_flutter/supabase_flutter.dart';

import 'auth_repository.dart';
import '../../utils/result.dart';
import '../services/api/auth_api.dart';

class AuthRepositoryRemote extends AuthRepository {
  AuthRepositoryRemote({
    required AuthClient authClient
  }) : _authClient = authClient;

  final AuthClient _authClient;

  @override
  Future<Result<void>> signUpWithEmailPassword ({required String email, required String password}) async {
    try {
      final result = await _authClient.signUp(email, password);

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

  // @override
  // Future<AuthResponse> signInWithEmailPassword ({required String email, required String password}) async {
  //   return await _supabaseClient.auth.signInWithPassword(
  //     email: email,
  //     password: password
  //   );
  // }
  
  // @override
  // Future<void> signOut () async{
  //   await _supabaseClient.auth.signOut();
  // }
}