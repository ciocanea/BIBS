import 'package:flutter/material.dart';

import '../../../data/repositories/auth_repository.dart';
import '../../../utils/result.dart';


class SignInViewModel extends ChangeNotifier {
  SignInViewModel ({
    required AuthRepository authRepository
  }) : _authRepository = authRepository;

  final AuthRepository _authRepository;

  Future<Result<void>> signInWithEmailPassword (String email, String password) async {
    final result = await _authRepository.signInWithEmailPassword(
      email: email,
      password: password,
    );

    if(result is Error<void>) {
      print(result.error);
    }

    return result;
  }
}