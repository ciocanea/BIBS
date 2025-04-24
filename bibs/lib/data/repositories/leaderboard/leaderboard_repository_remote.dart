
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
  Future<Result<List<UserTime>>> getLeaderboard ({required String campus}) async {
    final result = await _leaderboardClient.getLeaderboardEntries(campus);

    switch (result) {
      case Ok<List<UserTimeResponse>>():
        _log.info('User Times successfully retreived for campus $campus.');

        return Result.ok(result.value.map((userTime) => UserTime.fromJson(userTime.time)).toList());
      case Error<List<UserTimeResponse>>():
        _log.severe('Failed to get user time: ${result.error}.');
        return Result.error(result.error);
    }
  }
}