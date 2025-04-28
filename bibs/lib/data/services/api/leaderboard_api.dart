import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../utils/result.dart';
import '../responses.dart/time_response.dart';

class LeaderboardClient {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  Future<Result<List<UserTimeResponse>>> getLeaderboardEntries (String campus) async {
    try {
      final response = await _supabaseClient
      .from('times')
      .select()
      .eq('campus', campus)
      .order('total_time', ascending: false);

      return Result.ok(response.map((userTime) => UserTimeResponse(time: userTime)).toList());
    }
    on Exception catch (error) {
      return Result.error(error);
    }
  }
}