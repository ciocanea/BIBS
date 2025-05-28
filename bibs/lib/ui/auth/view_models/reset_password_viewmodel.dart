import 'package:flutter/material.dart';

import '../../../data/repositories/auth/auth_repository.dart';
import '../../../utils/result.dart';


class ResetPasswordViewModel extends ChangeNotifier {
  
  ResetPasswordViewModel ({
    required AuthRepository authRepository
  }) : _authRepository = authRepository;

  final AuthRepository _authRepository;

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter some text';
    }

    final password = value;

    final lengthCheck = password.length >= 8;
    // final upperCheck = RegExp(r'[A-Z]').hasMatch(password);
    // final numberCheck = RegExp(r'[0-9]').hasMatch(password);
    // final specialCheck = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);
    final spaceCheck = !password.contains(' ');

    if (!lengthCheck) return 'Password must be at least 8 characters long.';
    // if (!upperCheck) return 'Password must contain at least one uppercase letter.';
    // if (!numberCheck) return 'Password must contain at least one number.';
    // if (!specialCheck) return 'Password must contain at least one special character.';
    if (!spaceCheck) return 'Password must not contain any spaces.';

    return null;
  }

  Future<Result<void>> sendPasswordReset (String email) async {
    final result = await _authRepository.sendPasswordReset(email: email);

    return result;
  }

  Future<Result<void>> changePassword (String newPassword) async {
    final result = await _authRepository.setPassword(newPassword: newPassword);

    return result;
  }
}