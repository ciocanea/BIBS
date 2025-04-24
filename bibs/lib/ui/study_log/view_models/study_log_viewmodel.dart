import 'package:bibs/data/services/responses.dart/time_response.dart';
import 'package:flutter/material.dart';

import '../../../data/models/study_session/study_session_model.dart';
import '../../../data/models/user_profile/user_profile_model.dart';
import '../../../data/repositories/session/study_session_repository.dart';
import '../../../data/repositories/user/user_repository.dart';
import '../../../utils/result.dart';

class StudyLogViewModel extends ChangeNotifier{
  StudyLogViewModel({
    required UserRepository userRepository,
    required StudySessionRepository studySessionRepository,
  }) : _userRepository = userRepository,
       _studySessionRepository = studySessionRepository;

  final UserRepository _userRepository;
  final StudySessionRepository _studySessionRepository;

  UserProfile? _userProfile;
  UserProfile? get userProfile => _userProfile;

  List<StudySession>? _studySessions;
  List<StudySession>? get studySessions => _studySessions;

  Future<Result<void>> load() async {
    try {
      final userProfileResult = await _userRepository.getUserProfile();
      switch (userProfileResult) {
        case Ok<UserProfile>():
          _userProfile = userProfileResult.value;
        case Error<UserProfile>():
          return Result.error(userProfileResult.error);
      }

      final studySessionResult = await _studySessionRepository.getStudySession(userId: _userProfile!.id, campus: _userProfile!.campus!);
      switch (studySessionResult) {
        case Ok<List<StudySession>>():
          _studySessions = studySessionResult.value;
          return Result.ok(null);
        case Error<List<StudySession>>():
          return Result.error(studySessionResult.error);
      }
    }
    finally {
      notifyListeners();
    }
  }

  Future<Result<void>> deleteStudySession (StudySession studySession) async {
    try {
      final userTimeResult = await _userRepository.setUserTime(time: (-1) * studySession.time);
      
      if (userTimeResult is Error) {
        return userTimeResult;
      }

      final studySessionResult = await _studySessionRepository.deleteStudySession(studySessionId: studySession.id);

      if (studySessionResult is Error) {
        return studySessionResult;
      }

      _studySessions!.remove(studySession);

      return studySessionResult;
    }
    finally {
      notifyListeners();
    }
  }
}