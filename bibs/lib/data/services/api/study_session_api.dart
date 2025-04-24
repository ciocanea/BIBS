import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../utils/result.dart';
import '../responses.dart/study_session_response.dart';


class StudySessionClient {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  Future<Result<StudySessionResponse>> createStudySession (String userId, String campus, int time, DateTime startedAt) async {
    try {
      final response = await _supabaseClient.from('sessions').insert({'user_id': userId, 'campus': campus, 'time': time, 'started_at': startedAt.toIso8601String()}).select().single();

      return Result.ok(StudySessionResponse(session: response));
    }
    on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<List<StudySessionResponse>>> getStudySession (String userId, String campus) async {
    try {
      final response = await _supabaseClient.from('sessions').select().eq('user_id', userId).eq('campus', campus).order('started_at', ascending: false);

      return Result.ok(response.map((studySession) => StudySessionResponse(session: studySession)).toList());
    }
    on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<void>> deleteStudySession (String studySessionId) async {
    try {
      await _supabaseClient.from('sessions').delete().eq('id', studySessionId);

      return Result.ok(null);
    }
    on Exception catch (error) {
      return Result.error(error);
    }
  }
}