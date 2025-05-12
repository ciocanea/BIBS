import 'package:flutter/material.dart';

import '../../../data/repositories/auth/auth_repository.dart';
import '../../../utils/result.dart';


class ForgotPasswordViewModel extends ChangeNotifier {
  
  ForgotPasswordViewModel ({
    required AuthRepository authRepository
  }) : _authRepository = authRepository;

  final AuthRepository _authRepository;

  Future<Result<void>> sendPasswordReset (String email) async {
    final result = await _authRepository.sendPasswordReset(email: email);

    return result;
  }
}