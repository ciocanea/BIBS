import 'package:flutter/material.dart';

import '../../../utils/result.dart';

abstract class AuthRepository extends ChangeNotifier{

  bool get resetTrigger;

  Future<bool> get isAuthenticated;

  Future<Result<void>> signUpWithEmailPassword ({required String email, required String password});

  Future<Result<void>> signInWithEmailPassword ({required String email, required String password});

  Future<Result<void>> signOut ();

  Future<Result<void>> deteleUser ({required String userId});

  Future<Result<void>> setPassword ({required String newPassword});

  Future<Result<void>> sendPasswordReset ({required String email});

}