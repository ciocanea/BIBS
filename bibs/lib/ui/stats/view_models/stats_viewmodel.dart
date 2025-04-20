import 'package:flutter/material.dart';

import '../../../data/models/user_profile_model.dart';
import '../../../data/repositories/user/user_repository.dart';
import '../../../utils/result.dart';

class StatsViewModel extends ChangeNotifier{
  StatsViewModel({
    required UserRepository userRepository,
  }) : _userRepository = userRepository;

  final UserRepository _userRepository;

  UserProfile? _userProfile;
  UserProfile? get userProfile => _userProfile;

  int? _userTime;
  int? get userTime => _userTime;

  Future<Result<void>> load() async {
    try {
      final userProfileResult = await _userRepository.getUserProfile();
      switch (userProfileResult) {
        case Ok<UserProfile>():
          _userProfile = userProfileResult.value;
        case Error<UserProfile>():
          return Result.error(userProfileResult.error);
      }

      final userTimeResult = await _userRepository.getUserTime();
      switch (userTimeResult) {
        case Ok<int>():
          _userTime = userTimeResult.value;
          return Result.ok(null);
        case Error<int>():
          return Result.error(userTimeResult.error);
      }
    } 
    finally {
      notifyListeners();
    }
  }

  String get formattedUserTime {
    if (_userTime == null) return '';

    final duration = Duration(milliseconds: _userTime!);

    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    return '$days days\n$hours hours\n$minutes minutes\n$seconds seconds';
  }

}