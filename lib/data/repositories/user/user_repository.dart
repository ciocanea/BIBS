import 'dart:io';

import '../../models/user_profile/user_profile_model.dart';
import '../../../utils/result.dart';

abstract class UserRepository {

  void clear();
  
  Future<Result<UserProfile>> getProfile ();

  Future<Result<UserProfile>> setUsername ({required String newUsername});
  
  Future<Result<UserProfile>> setCampus ({required String newCampus});

  Future<Result<UserProfile>> uploadImage ({required File imageFile});

  Future<Result<int>> getTotalTime ();

  Future<Result<void>> updateTotalTime ({required int duration});

}