import 'dart:async';

import 'package:flutter/material.dart';

import '../../../data/models/user_profile/user_profile_model.dart';
import '../../../data/repositories/session/study_session_repository.dart';
import '../../../data/repositories/user/user_repository.dart';
import '../../../utils/result.dart';

class SessionViewModel extends ChangeNotifier{
  final Stopwatch _stopwatch = Stopwatch();
  late final Timer _timer;

  SessionViewModel({
    required UserRepository userRepository,
    required StudySessionRepository studySessionRepository
  }) : _userRepository = userRepository,
       _studySessionRepository = studySessionRepository {
    _timer = Timer.periodic(
      const Duration(milliseconds: 30),
      (_) { notifyListeners(); }
    );
  }

  final UserRepository _userRepository;
  final StudySessionRepository _studySessionRepository;

  UserProfile? _userProfile;
  UserProfile? get userProfile => _userProfile;

  bool get isRunning => _stopwatch.isRunning;

  bool _isPaused = false;
  bool get isPaused => _isPaused;

  String get formattedTime {
    final milli = _stopwatch.elapsed.inMilliseconds;
    final milliseconds = (milli % 1000).toString().padLeft(3, '0');
    final seconds = ((milli ~/ 1000) % 60).toString().padLeft(2, '0');
    final minutes = ((milli ~/ 1000 ~/ 60) % 60).toString().padLeft(2, '0');
    final hours = ((milli ~/ 1000 ~/ 60) ~/ 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds:$milliseconds';
  }


  Future<Result<void>> load() async {
    try {
      final result = await _userRepository.getProfile();
      switch (result) {
        case Ok<UserProfile>():
          _userProfile = result.value;
          return Result.ok(null);
        case Error<UserProfile>():
          return Result.error(result.error);
      }
    } 
    finally {
      notifyListeners();
    }
  }

  Future<Result<void>> setUserCampus(String newCampus) async {
    try {
      final result = await _userRepository.setCampus(newCampus: newCampus);
      switch (result) {
        case Ok<UserProfile>():
          _userProfile = result.value;
          return Result.ok(null);
        case Error<UserProfile>():
          return Result.error(result.error);
      }
    }
    finally {
      notifyListeners();
    }
  }


  void start() async {
    _stopwatch.start();
    notifyListeners();
  }
  
  void pauseUnpause() async {
    try {
      if (_stopwatch.isRunning) {
        _stopwatch.stop();
        _isPaused = true;
      }
      else {
        _stopwatch.start();
        _isPaused = false;
      }
    }
    finally {
      notifyListeners();
    }
  }

  Future<Result<void>> updateTotalTime() async {
    try {
      _stopwatch.stop();
      int sessionDuration = _stopwatch.elapsedMilliseconds;
      _stopwatch.reset();
      _isPaused = false;
    
      final timeResult = await _userRepository.updateTotalTime(duration: sessionDuration);
      
      if (timeResult is Error) {
        return timeResult;
      }

      final sessionResult = await _studySessionRepository.createStudySession(
        userId: _userProfile!.userId,
        campus: _userProfile!.campus!,
        duration: sessionDuration
      );

      return sessionResult;
    }
    finally {
      notifyListeners();
    }    
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}