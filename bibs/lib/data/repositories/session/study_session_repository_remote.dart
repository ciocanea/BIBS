import 'package:bibs/data/models/study_session/study_session_model.dart';
import 'package:logging/logging.dart';

import '../../../utils/result.dart';
import '../../services/api/study_session_api.dart';
import '../../services/responses.dart/study_session_response.dart';
import 'study_session_repository.dart';

class StudySessionRepositoryRemote extends StudySessionRepository {

  StudySessionRepositoryRemote ({
    required StudySessionClient studySessionClient,
  }) : _studySessionClient = studySessionClient;

  final StudySessionClient _studySessionClient;

  final _log = Logger('StudySessionRepositoryRemote');

  @override
  Future<Result<void>> createStudySession ({required String userId, required String campus, required int duration}) async {
    final startedAt = DateTime.now().subtract(Duration(milliseconds: duration));

    final result = await _studySessionClient.createStudySession(userId, campus, duration, startedAt);

    switch (result) {
      case Ok<StudySessionResponse>():
        _log.info('Study session created succesfully.');
        return Result.ok(null);
      case Error<StudySessionResponse>():
        _log.severe('Failed to create study session: ${result.error}.');
        return Result.error(result.error);
    }
  }

  @override
  Future<Result<List<StudySession>>> getStudySessions ({required String userId, required String campus}) async {
    final result = await _studySessionClient.getStudySession(userId, campus);

    switch (result) {
      case Ok<List<StudySessionResponse>>():
        _log.info('Study sessions retreived successfully for campus $campus.');

        return Result.ok(result.value.map((studySession) => StudySession.fromJson(studySession.session)).toList());
      case Error<List<StudySessionResponse>>():
        _log.severe('Failed to get study sessions: ${result.error}.');
        return Result.error(result.error);
    }
  }
  
  @override
  Future<Result<void>> deleteStudySession ({required String studySessionId}) async {
    final result = await _studySessionClient.deleteStudySession(studySessionId);

    switch (result) {
      case Ok<void>():
        _log.info('Study session deleted successfuly.');

        return result;
      case Error<void>():
        _log.severe('Failed to delete study session: ${result.error}.');

        return result;
    }
  }
}