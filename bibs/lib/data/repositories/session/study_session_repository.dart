import '../../../utils/result.dart';
import '../../models/study_session/study_session_model.dart';

abstract class StudySessionRepository {
  Future<Result<void>> createStudySession ({required String userId, required String campus, required int time});

  Future<Result<List<StudySession>>> getStudySession ({required String userId, required String campus});

  Future<Result<void>> deleteStudySession ({required String studySessionId});
}