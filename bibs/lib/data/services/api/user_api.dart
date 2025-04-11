import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../utils/result.dart';
import '../responses.dart/profile_response.dart';

class UserClient {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  Future<Result<ProfileResponse>> getUserProfile (String id) async {
    try {
      final response = await _supabaseClient.from('profiles').select().eq('id', id).single();

      return Result.ok(ProfileResponse(profile: response));
    }
    on Exception catch (error) {
      return Result.error(error);
    }
  }
}