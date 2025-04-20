
import '../../models/user_profile_model.dart';
import '../../../utils/result.dart';

abstract class UserRepository {

  Future<Result<UserProfile>> getUserProfile ();

  Future<Result<UserProfile>> setUserCampus ({required String newCampus});

  Future<Result<int>> getUserTime ();

  Future<Result<void>> setUserTime ({required int time});
}