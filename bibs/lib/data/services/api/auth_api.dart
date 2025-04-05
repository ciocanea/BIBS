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

  Future<Result<Session?>> currentSession () async {
    try {
      final response = await _supabaseClient.auth.currentSession;

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
}