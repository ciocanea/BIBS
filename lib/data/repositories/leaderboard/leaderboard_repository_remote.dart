
import 'package:logging/logging.dart';

import '../../../utils/result.dart';
import '../../models/user_time/user_time_model.dart';
import '../../services/api/leaderboard_api.dart';
import '../../services/responses.dart/time_response.dart';
import 'leaderboard_repository.dart';

class LeaderboardRepositoryRemote extends LeaderboardRepository {
  
  LeaderboardRepositoryRemote ({
    required LeaderboardClient leaderboardClient,
  }) : _leaderboardClient = leaderboardClient;

  final LeaderboardClient _leaderboardClient;

  final _log = Logger('LeaderboardRepositoryRemote');

  @override
  Future<Result<List<UserTime>>> getLeaderboardEntries ({required String campus}) async {
    final getLeaderboardEntriesResult = await _leaderboardClient.getLeaderboardEntries(campus);

    switch (getLeaderboardEntriesResult) {
      case Ok<List<UserTimeResponse>>():
        _log.info('Leaderboard entries retreived succesfully for campus $campus.');

        return Result.ok(getLeaderboardEntriesResult.value.map((userTime) => UserTime.fromJson(userTime.time)).toList());
      case Error<List<UserTimeResponse>>():
        _log.severe('Failed to get leaderboard entries: ${getLeaderboardEntriesResult.error}.');
        return Result.error(getLeaderboardEntriesResult.error);
    }
  }
}