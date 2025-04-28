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

  Future<Result<UserProfile>> _fetchUser() async {
    final sharedPrefResult = await _sharedPreferencesService.fetchUserId();
    switch (sharedPrefResult) {
      case Ok<String?>():
        String? id = sharedPrefResult.value;
        
        if(id == null) {
          _log.severe('User id is null.');
          return Result.error(Exception('User id is null.'));
        }

        final userResult = await _userClient.getUserProfile(id);
        switch (userResult) {
          case Ok<UserProfileResponse>():
            final userProfile = UserProfile.fromJson(userResult.value.profile);
            _userProfile = userProfile;
            _log.info('User profile successfully fetched and cached.');
            return Result.ok(userProfile);
          case Error<UserProfileResponse>():
            _log.severe('Failed to fetch user profile: ${userResult.error}');
            return Result.error(userResult.error);
        }
      case Error<String?>():
        _log.severe('Failed to fetch user ID: ${sharedPrefResult.error}');
        return Result.error(sharedPrefResult.error);
    }
  }

  @override
  Future<Result<UserProfile>> getUserProfile () async {
    if(_userProfile != null) {
      _log.info('User profile already loaded in memory. Returning cached profile.');
      return Future.value(Result.ok(_userProfile!));
    }

    return _fetchUser();
  }

  @override
  Future<Result<UserProfile>> setUsername ({required String newUsername}) async {
    String? id;
    if(_userProfile != null) {
      id = _userProfile!.id;
    }
    else {
      final fetchResult = await _fetchUser();
      switch (fetchResult) {
        case Ok<UserProfile>():
          id = fetchResult.value.id;
        case Error<UserProfile>():
          return Result.error(fetchResult.error);
      }
    }

    final userResult = await _userClient.setUsername(id, newUsername);
    switch (userResult) {
      case Ok<UserProfileResponse>():
        final userProfile = UserProfile.fromJson(userResult.value.profile);
        _userProfile = userProfile;

        _log.info('Username successfully updated.');
        return Result.ok(userProfile);
      case Error<UserProfileResponse>():
        _log.severe('Failed to update username: ${userResult.error}.');
        return Result.error(userResult.error);
    }
  }

  @override
  Future<Result<UserProfile>> setUserCampus ({required String newCampus}) async {
    String? id;
    if(_userProfile != null) {
      id = _userProfile!.id;
    }
    else {
      final fetchResult = await _fetchUser();
      switch (fetchResult) {
        case Ok<UserProfile>():
          id = fetchResult.value.id;
        case Error<UserProfile>():
          return Result.error(fetchResult.error);
      }
    }

    final userResult = await _userClient.setUserCampus(id, newCampus);
    switch (userResult) {
      case Ok<UserProfileResponse>():
        final userProfile = UserProfile.fromJson(userResult.value.profile);
        _userProfile = userProfile;

        _log.info('User campus successfully updated.');
        return Result.ok(userProfile);
      case Error<UserProfileResponse>():
        _log.severe('Failed to update user campus: ${userResult.error}.');
        return Result.error(userResult.error);
    }
  }

  @override
  Future<Result<UserProfile>> uploadImage ({required File imageFile}) async{
    String? id;
    if(_userProfile != null) {
      id = _userProfile!.id;
    }
    else {
      final fetchResult = await _fetchUser();
      switch (fetchResult) {
        case Ok<UserProfile>():
          id = fetchResult.value.id;
        case Error<UserProfile>():
          return Result.error(fetchResult.error);
      }
    }

    final imagePath = '/$id/profile';

    final uploadImageResult = await _userClient.uploadImage(imageFile, imagePath);

    switch (uploadImageResult) {
      case Ok<String>():
        _log.info('Image succesfully uploaded.');
      case Error<String>():
        _log.severe('Failed to upload image: ${uploadImageResult.error}');
        return Result.error(uploadImageResult.error);
    }

    final getPubliUrlResult = await _userClient.getPublicUrl(imagePath);
    switch (getPubliUrlResult) {
      case Ok<String>():
        _log.info('Public image URL succesfully retreived.');
      case Error<String>():
        return Result.error(getPubliUrlResult.error);
    }

    final publicUrl = Uri.parse(getPubliUrlResult.value).replace(queryParameters: {'t': DateTime.now().millisecondsSinceEpoch.toString()}).toString();

    final setImagePathResult = await _userClient.setUserImagePath(id, publicUrl);

    switch (setImagePathResult) {
      case Ok<UserProfileResponse>():
        final userProfile = UserProfile.fromJson(setImagePathResult.value.profile);
        _userProfile = userProfile;

        _log.info('User image path succesfully changed.');
        return Result.ok(userProfile);
      case Error<UserProfileResponse>():
        _log.severe('Failed to change user image path: ${setImagePathResult.error}');
        return Result.error(setImagePathResult.error);
    }
  }

  @override
  Future<Result<int>> getUserTime () async {
    String? id;
    String? campus;
    if(_userProfile != null) {
      id = _userProfile!.id;
      campus = _userProfile!.campus;
    }
    else {
      final fetchResult = await _fetchUser();
      switch (fetchResult) {
        case Ok<UserProfile>():
          id = fetchResult.value.id;
          campus = fetchResult.value.campus;
        case Error<UserProfile>():
          return Result.error(fetchResult.error);
      }
    }

    if(campus == null) {
      return Result.error(Exception('User has no campus selected.'));
    }

    final getTimeResult = await _userClient.getUserTime(id, campus);
    switch (getTimeResult) {
      case Ok<UserTimeResponse>():
        return Result.ok(getTimeResult.value.time['time']);
      case Error<UserTimeResponse>():
        _log.severe('Failed to get user time: ${getTimeResult.error}.');
        return Result.error(getTimeResult.error);
    }
  }

  @override
  Future<Result<void>> setUserTime ({required int time}) async {
    String? id;
    String? campus;
    if(_userProfile != null) {
      id = _userProfile!.id;
      campus = _userProfile!.campus;
    }
    else {
      final fetchResult = await _fetchUser();
      switch (fetchResult) {
        case Ok<UserProfile>():
          id = fetchResult.value.id;
          campus = fetchResult.value.campus;
        case Error<UserProfile>():
          return Result.error(fetchResult.error);
      }
    }

    if(campus == null) {
      return Result.error(Exception('User has no campus selected.'));
    }

    final getTimeResult = await _userClient.getUserTime(id, campus);
    switch (getTimeResult) {
      case Ok<UserTimeResponse>():
        int newTime = getTimeResult.value.time['time'] + time;

        final setTimeResult = await _userClient.setUserTime(id, campus, newTime);
        switch (setTimeResult) {
          case Ok<UserTimeResponse>():
            _log.info('User time successfully updated.');
            return Result.ok(null);
          case Error<UserTimeResponse>():
            _log.severe('Failed to update user time: ${setTimeResult.error}.');
            return Result.error(setTimeResult.error);
        }
      case Error<UserTimeResponse>():
        _log.severe('Failed to get user time: ${getTimeResult.error}.');
        return Result.error(getTimeResult.error);
    }
  }
}