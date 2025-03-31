import 'package:flutter/material.dart';

import '../../../data/repositories/auth_repository.dart';
import '../../../utils/result.dart';


class SignUpViewModel extends ChangeNotifier {
  SignUpViewModel ({required AuthRepository authRepository})
  : _authRepository = authRepository;

  final AuthRepository _authRepository;

  Future<Result<void>> signUp (String email, String password) async {
    final result = await _authRepository.signUpWithEmailPassword(
      email: email,
      password: password,
    );

    if(result is Error<void>) {
      print(result.error);
    }

    return result;
  }
}