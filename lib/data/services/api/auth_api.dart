import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../utils/result.dart';

class AuthClient {
  final SupabaseClient _supabaseClient = Supabase.instance.client;
  
  Future<Result<AuthResponse>> signUpWithEmailPassword (String email, String password) async {
    try {
      final response = await _supabaseClient.auth.signUp(
        email: email,
        password: password
      );

      return Result.ok(response);
    } 
    on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<AuthResponse>> signInWithEmailPassword (String email, String password) async {
    try {
      final response = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password
      );

      return Result.ok(response);
    }
    on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<void>> signOut () async {
    try {
      final response = await _supabaseClient.auth.signOut();

      return Result.ok(response);
    }
    on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<void>> deleteUser () async {
    try {
      final res = await Supabase.instance.client.functions.invoke(
        'delete-user',
      );

      if (res.status == 200) {
        return Result.ok(null);
      } else {
        final error = res.data;
        return Result.error(Exception('Failed to delete: $error'));
      }
    } 
    on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<Session?>> currentSession () async {
    try {
      final response = _supabaseClient.auth.currentSession;

      return Result.ok(response);
    }
    on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<AuthResponse>> refreshSession () async {
    try {
      final response = await _supabaseClient.auth.refreshSession();

      return Result.ok(response);
    }
    on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<void>> setPassword (String newPassword) async {
    try {
      await _supabaseClient.auth.updateUser(
        UserAttributes(
          password: newPassword
        )
      );

      return Result.ok(null);
    }
    on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<void>> sendPasswordReset(String email) async {
    try {
      await _supabaseClient.auth.resetPasswordForEmail(
        email,
        redirectTo: 'io.supabase.flutterquickstart://reset_password_callback'
      );

      return Result.ok(null);
    }
    on Exception catch (error) {
      return Result.error(error);
    }
  }
}