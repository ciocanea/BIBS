import '../../../utils/result.dart';
import '../../models/user_time/user_time_model.dart';

abstract class LeaderboardRepository{

  Future<Result<List<UserTime>>> getLeaderboard({required String campus});
}