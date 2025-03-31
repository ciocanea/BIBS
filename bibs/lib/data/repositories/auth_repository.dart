import 'package:flutter/material.dart';

import '../../utils/result.dart';

abstract class AuthRepository extends ChangeNotifier{
  Future<Result<void>> signUpWithEmailPassword ({required String email, required String password});

  // Future<AuthResponse> signInWithEmailPassword ({required String email, required String password});

  // Future<void> signOut ();
}