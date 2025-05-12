import 'package:flutter/material.dart';

import '../../../data/repositories/auth/auth_repository.dart';
import '../../../utils/result.dart';


class ResetPasswordViewModel extends ChangeNotifier {
  
  ResetPasswordViewModel ({
    required AuthRepository authRepository
  }) : _authRepository = authRepository;

  final AuthRepository _authRepository;

  Future<Result<void>> sendPasswordReset (String email) async {
    final result = await _authRepository.sendPasswordReset(email: email);

    return result;
  }

  Future<Result<void>> changePassword (String newPassword) async {
    final result = await _authRepository.setPassword(newPassword: newPassword);

    return result;
  }
}