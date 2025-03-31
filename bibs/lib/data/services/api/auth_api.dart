import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../utils/result.dart';

class AuthClient {
  final SupabaseClient _supabaseClient = Supabase.instance.client;
  
  Future<Result<AuthResponse>> signUp (String email, String password) async {
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
}