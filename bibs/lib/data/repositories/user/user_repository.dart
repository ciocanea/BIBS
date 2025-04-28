import 'dart:io';

import '../../models/user_profile/user_profile_model.dart';
import '../../../utils/result.dart';

abstract class UserRepository {

  Future<Result<UserProfile>> getUserProfile ();

  Future<Result<UserProfile>> setUsername ({required String newUsername});
  
  Future<Result<UserProfile>> setUserCampus ({required String newCampus});

  Future<Result<UserProfile>> uploadImage ({required File imageFile});

  Future<Result<int>> getUserTime ();

  Future<Result<void>> setUserTime ({required int time});
}