import 'package:flutter/material.dart';

import '../../../data/models/user_profile/user_profile_model.dart';
import '../../../data/models/user_time/user_time_model.dart';
import '../../../data/repositories/leaderboard/leaderboard_repository.dart';
import '../../../data/repositories/user/user_repository.dart';
import '../../../utils/result.dart';

class StatsViewModel extends ChangeNotifier{

  StatsViewModel({
    required UserRepository userRepository,
    required LeaderboardRepository leaderboardRepository,
  }) : _userRepository = userRepository,
       _leaderboardRepository = leaderboardRepository;

  final UserRepository _userRepository;
  final LeaderboardRepository _leaderboardRepository;

  UserProfile? _userProfile;
  UserProfile? get userProfile => _userProfile;

  int? _userTotalTime;
  int? get userTotalTime => _userTotalTime;

  List<UserTime>? _leaderboard;
  List<UserTime>? get leaderboard => _leaderboard;

  Future<Result<void>> load() async {
    try {
      final userProfileResult = await _userRepository.getProfile();
      switch (userProfileResult) {
        case Ok<UserProfile>():
          _userProfile = userProfileResult.value;
        case Error<UserProfile>():
          return Result.error(userProfileResult.error);
      }

      final userTimeResult = await _userRepository.getTotalTime();
      switch (userTimeResult) {
        case Ok<int>():
          _userTotalTime = userTimeResult.value;
        case Error<int>():
          return Result.error(userTimeResult.error);
      }

      final leaderboardResult = await _leaderboardRepository.getLeaderboardEntries(campus: _userProfile!.campus ?? '');
      switch (leaderboardResult) {
        case Ok<List<UserTime>>():
          _leaderboard = leaderboardResult.value;
          return Result.ok(null);
        case Error<List<UserTime>>():
          return Result.error(leaderboardResult.error);
      }
    } 
    finally {
      notifyListeners();
    }
  }

  String get formattedUserTime {
    if (_userTotalTime == null) return '';

    final duration = Duration(milliseconds: _userTotalTime!);

    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    return '$days DAYS\n$hours HOURS\n$minutes MINUTES\n$seconds SECONDS';
  }

}