import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../utils/result.dart';
import '../responses.dart/profile_response.dart';
import '../responses.dart/time_response.dart';

class UserClient {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  Future<Result<UserProfileResponse>> getUserProfile (String id) async {
    try {
      final response = await _supabaseClient.from('profiles').select().eq('id', id).single();

      return Result.ok(UserProfileResponse(profile: response));
    }
    on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<UserProfileResponse>> setUserCampus (String id, String newCampus) async {
    try {
      final response = await _supabaseClient.from('profiles').update({'campus': newCampus}).eq('id', id).select().single();

      return Result.ok(UserProfileResponse(profile: response));
    }
    on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<UserTimeResponse>> getUserTime (String id, String campus) async {
    try {
      final response = await _supabaseClient.from('times').select().eq('id', id, ).eq('campus', campus).single();

      return Result.ok(UserTimeResponse(time: response));
    }
    on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<UserTimeResponse>> setUserTime (String id, String campus, int newTime) async {
    try {
      final response = await _supabaseClient.from('times').update({'time': newTime}).eq('id', id, ).eq('campus', campus).select().single();

      return Result.ok(UserTimeResponse(time: response));
    }
    on Exception catch (error) {
      return Result.error(error);
    }
  }
}