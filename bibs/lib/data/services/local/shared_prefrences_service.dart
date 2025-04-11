import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/result.dart';

class SharedPreferencesService {
  static const _tokenKey = 'token';
  static const _userIdKey = 'userId';

  Future<Result<String?>> fetchToken() async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      return Result.ok(sharedPreferences.getString(_tokenKey));
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<void>> saveToken(String? token) async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      if (token == null) {
        await sharedPreferences.remove(_tokenKey);
      } else {
        await sharedPreferences.setString(_tokenKey, token);
      }
      return const Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<String?>> fetchUserId() async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      return Result.ok(sharedPreferences.getString(_userIdKey));
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<void>> saveUserId(String? userId) async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      if (userId == null) {
        await sharedPreferences.remove(_userIdKey);
      } else {
        await sharedPreferences.setString(_userIdKey, userId);
      }
      return const Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}