
import '../../models/user_profile_model.dart';
import '../../../utils/result.dart';

abstract class UserRepository {

  Future<Result<UserProfile>> getUserProfile ();
}