import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

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

  bool get isRunning => _stopwatch.elapsedMicroseconds != 0;

  bool _isPaused = true;
  bool get isPaused => _isPaused;

  bool _showPausedDialogOnResume = false;
  bool get showPausedDialogOnResume => _showPausedDialogOnResume;
  set showPausedDialogOnResume(bool value) => _showPausedDialogOnResume = value;

  bool _isPausedDialogOpen = false;
  bool get isPausedDialogOpen => _isPausedDialogOpen;
  set isPausedDialogOpen(bool value) => _isPausedDialogOpen = value;


  String get formattedTime {
    final milli = _stopwatch.elapsed.inMilliseconds;
    final seconds = ((milli ~/ 1000) % 60).toString().padLeft(2, '0');
    final minutes = ((milli ~/ 1000 ~/ 60) % 60).toString().padLeft(2, '0');
    final hours = ((milli ~/ 1000 ~/ 60) ~/ 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
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
      //REMOVE THIS WHEN ADDING NEW CAMPUS
      setUserCampus("TU-Delft");

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
    await WakelockPlus.enable();
    _stopwatch.start();
    _isPaused = false;
    notifyListeners();
  }
  
  void pauseUnpause() async {
    try {
      if (_isPaused) {
        await WakelockPlus.enable();

        _stopwatch.start();
      }
      else {
        await WakelockPlus.disable();

        _stopwatch.stop();
      }

      _isPaused = !_isPaused;
    }
    finally {
      notifyListeners();
    }
  }

  Future<void> pauseOnAppInactive() async {
    _stopwatch.stop();
    _isPaused = true;
    _showPausedDialogOnResume = true;
    notifyListeners();
  }

  Future<Result<void>> updateTotalTime() async {
    try {
      await WakelockPlus.disable();
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