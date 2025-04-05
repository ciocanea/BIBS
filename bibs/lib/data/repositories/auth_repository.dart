import 'package:flutter/material.dart';

import '../../utils/result.dart';

abstract class AuthRepository extends ChangeNotifier{

  Future<bool> get isAuthenticated;

  Future<Result<void>> signUpWithEmailPassword ({required String email, required String password});

  Future<Result<void>> signInWithEmailPassword ({required String email, required String password});

  Future<Result<void>> signOut ();
}