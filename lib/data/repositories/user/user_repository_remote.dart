import 'dart:io';

import 'package:logging/logging.dart';

import '../../../utils/result.dart';
import '../../models/user_profile/user_profile_model.dart';
import '../../services/api/user_api.dart';
import '../../services/local/shared_prefrences_service.dart';
import '../../services/responses.dart/profile_response.dart';
import '../../services/responses.dart/time_response.dart';
import 'user_repository.dart';

class UserRepositoryRemote extends UserRepository {

  UserRepositoryRemote ({
    required UserClient userClient,
    required SharedPreferencesService sharedPreferencesService,
  }) : _userClient = userClient,
       _sharedPreferencesService = sharedPreferencesService;

  final UserClient _userClient;
  final SharedPreferencesService _sharedPreferencesService;

  final _log = Logger('UserRepositoryRemote');

  UserProfile? _userProfile;



  Future<Result<UserProfile>> _fetchUser () async {
    final sharedPreferencesResult = await _sharedPreferencesService.fetchUserId();
    switch (sharedPreferencesResult) {
      case Ok<String?>():
        String? userId = sharedPreferencesResult.value;
        
        if(userId == null) {
          _log.severe('User id is null.');
          return Result.error(Exception('User id is null.'));
        }

        final getProfileResult = await _userClient.getProfile(userId);
        switch (getProfileResult) {
          case Ok<UserProfileResponse>():
            final userProfile = UserProfile.fromJson(getProfileResult.value.profile);
            _userProfile = userProfile;

            _log.info('User profile fetched and cached successfully.');
            return Result.ok(userProfile);
          case Error<UserProfileResponse>():
            _log.severe('Failed to fetch user profile: ${getProfileResult.error}');
            return Result.error(getProfileResult.error);
        }
      case Error<String?>():
        _log.severe('Failed to fetch user ID: ${sharedPreferencesResult.error}');
        return Result.error(sharedPreferencesResult.error);
    }
  }

  @override
  void clear() {
    _userProfile = null;
    _log.info('Cleared cached user profile from memory.');
  }
  
  @override
  Future<Result<UserProfile>> getProfile () async {
    if(_userProfile != null) {
      _log.info('User profile already loaded in memory. Returning cached profile.');
      return Future.value(Result.ok(_userProfile!));
    }

    return _fetchUser();
  }

  @override
  Future<Result<UserProfile>> setUsername ({required String newUsername}) async {
    String? userId;
    if(_userProfile != null) {
      userId = _userProfile!.userId;
    }
    else {
      final fetchUserResult = await _fetchUser();
      switch (fetchUserResult) {
        case Ok<UserProfile>():
          userId = fetchUserResult.value.userId;
        case Error<UserProfile>():
          return Result.error(fetchUserResult.error);
      }
    }

    final setUsernameResult = await _userClient.setUsername(userId, newUsername);
    switch (setUsernameResult) {
      case Ok<UserProfileResponse>():
        final userProfile = UserProfile.fromJson(setUsernameResult.value.profile);
        _userProfile = userProfile;

        _log.info('Username updated successfully.');
        return Result.ok(userProfile);
      case Error<UserProfileResponse>():
        _log.severe('Failed to update username: ${setUsernameResult.error}.');
        return Result.error(setUsernameResult.error);
    }
  }

  @override
  Future<Result<UserProfile>> setCampus ({required String newCampus}) async {
    String? userId;
    if(_userProfile != null) {
      userId = _userProfile!.userId;
    }
    else {
      final fetchUserResult = await _fetchUser();
      switch (fetchUserResult) {
        case Ok<UserProfile>():
          userId = fetchUserResult.value.userId;
        case Error<UserProfile>():
          return Result.error(fetchUserResult.error);
      }
    }

    final setCampusResult = await _userClient.setCampus(userId, newCampus);
    _log.info("Setting campus for user $userId");
    switch (setCampusResult) {
      case Ok<UserProfileResponse>():
        final userProfile = UserProfile.fromJson(setCampusResult.value.profile);
        _userProfile = userProfile;

        _log.info('Campus updated successfully.');
        return Result.ok(userProfile);
      case Error<UserProfileResponse>():
        _log.severe('Failed to update campus: ${setCampusResult.error}.');
        return Result.error(setCampusResult.error);
    }
  }

  @override
  Future<Result<UserProfile>> uploadImage ({required File imageFile}) async{
    String? userId;
    if(_userProfile != null) {
      userId = _userProfile!.userId;
    }
    else {
      final fetchResult = await _fetchUser();
      switch (fetchResult) {
        case Ok<UserProfile>():
          userId = fetchResult.value.userId;
        case Error<UserProfile>():
          return Result.error(fetchResult.error);
      }
    }

    final imagePath = '/$userId/profile';

    final uploadImageResult = await _userClient.uploadImage(imageFile, imagePath);

    switch (uploadImageResult) {
      case Ok<String>():
        _log.info('Image uploaded succesfully.');
      case Error<String>():
        _log.severe('Failed to upload image: ${uploadImageResult.error}');
        return Result.error(uploadImageResult.error);
    }

    final getPubliUrlResult = await _userClient.getPublicUrl(imagePath);
    switch (getPubliUrlResult) {
      case Ok<String>():
        _log.info('Public image URL retreived succesfully.');
      case Error<String>():
        _log.severe('Failed to get image URL: ${getPubliUrlResult.error}');
        return Result.error(getPubliUrlResult.error);
    }

    final publicUrl = Uri.parse(getPubliUrlResult.value).replace(queryParameters: {'t': DateTime.now().millisecondsSinceEpoch.toString()}).toString();

    final setImagePathResult = await _userClient.setImagePath(userId, publicUrl);

    switch (setImagePathResult) {
      case Ok<UserProfileResponse>():
        final userProfile = UserProfile.fromJson(setImagePathResult.value.profile);
        _userProfile = userProfile;

        _log.info('User image path changed succesfully.');
        return Result.ok(userProfile);
      case Error<UserProfileResponse>():
        _log.severe('Failed to update image path: ${setImagePathResult.error}');
        return Result.error(setImagePathResult.error);
    }
  }

  @override
  Future<Result<int>> getTotalTime () async {
    String? userId;
    String? campus;
    if(_userProfile != null) {
      userId = _userProfile!.userId;
      campus = _userProfile!.campus;
    }
    else {
      final fetchResult = await _fetchUser();
      switch (fetchResult) {
        case Ok<UserProfile>():
          userId = fetchResult.value.userId;
          campus = fetchResult.value.campus;
        case Error<UserProfile>():
          return Result.error(fetchResult.error);
      }
    }

    if(campus == null) {
      return Result.error(Exception('Failed to get total time: User has not selected a campus.'));
    }

    final getTotalTimeResult = await _userClient.getTotalTime(userId, campus);
    switch (getTotalTimeResult) {
      case Ok<UserTimeResponse>():
        _log.info('Total time retreived successfully.');

        return Result.ok(getTotalTimeResult.value.time['total_time']);
      case Error<UserTimeResponse>():
        _log.severe('Failed to get total time: ${getTotalTimeResult.error}.');
        return Result.error(getTotalTimeResult.error);
    }
  }

  @override
  Future<Result<void>> updateTotalTime ({required int duration}) async {
    String? userId;
    String? campus;
    if(_userProfile != null) {
      userId = _userProfile!.userId;
      campus = _userProfile!.campus;
    }
    else {
      final fetchResult = await _fetchUser();
      switch (fetchResult) {
        case Ok<UserProfile>():
          userId = fetchResult.value.userId;
          campus = fetchResult.value.campus;
        case Error<UserProfile>():
          return Result.error(fetchResult.error);
      }
    }

    if(campus == null) {
      return Result.error(Exception('Failed to get total time: User has not selected a campus.'));
    }

    final getTotalTimeResult = await _userClient.getTotalTime(userId, campus);
    switch (getTotalTimeResult) {
      case Ok<UserTimeResponse>():
        int newTotalTime = getTotalTimeResult.value.time['total_time'] + duration;

        final setTotalTimeResult = await _userClient.setTotalTime(userId, campus, newTotalTime);
        switch (setTotalTimeResult) {
          case Ok<UserTimeResponse>():
            _log.info('Total time updated successfully.');
            return Result.ok(null);
          case Error<UserTimeResponse>():
            _log.severe('Failed to update total time: ${setTotalTimeResult.error}.');
            return Result.error(setTotalTimeResult.error);
        }
      case Error<UserTimeResponse>():
        _log.severe('Failed to get total time: ${getTotalTimeResult.error}.');
        return Result.error(getTotalTimeResult.error);
    }
  }
}