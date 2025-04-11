import 'dart:async';

import 'package:flutter/material.dart';

import '../../../data/models/user_profile_model.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/user/user_repository.dart';
import '../../../utils/result.dart';

class SessionViewModel extends ChangeNotifier{
  final Stopwatch _stopwatch = Stopwatch();
  late final Timer _timer;

  SessionViewModel({
    required AuthRepository authRepository,
    required UserRepository userRepository,
  }) : _authRepository = authRepository,
       _userRepository = userRepository {
    _timer = Timer.periodic(
      const Duration(milliseconds: 30),
      (_) { notifyListeners(); }
    );
  }

  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  UserProfile? _userProfile;
  UserProfile? get userProfile => _userProfile;

  Future<Result<void>> load() async {
    try {
      final result = await _userRepository.getUserProfile();
      switch (result) {
        case Ok<UserProfile>():
          _userProfile = result.value;
          return Result.ok(null);
        case Error<UserProfile>():
          return Result.error(result.error);
      }
    } finally {
      notifyListeners();
    }
  }

  String get formattedTime {
    final milli = _stopwatch.elapsed.inMilliseconds;
    final milliseconds = (milli % 1000).toString().padLeft(3, '0');
    final seconds = ((milli ~/ 1000) % 60).toString().padLeft(2, '0');
    final minutes = ((milli ~/ 1000) ~/ 60).toString().padLeft(2, '0');
    return '$minutes:$seconds:$milliseconds';
  }

  bool get isRunning => _stopwatch.isRunning;

  void startStop() {
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
    }
    else {
      _stopwatch.start();
    }

    notifyListeners();
  }

  void reset() {
    _stopwatch.reset();
    
    notifyListeners();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<Result<void>> signOut () async {
    final result = await _authRepository.signOut();

    if(result is Error<void>) {
      print(result.error);
    }

    return result;
  }
}