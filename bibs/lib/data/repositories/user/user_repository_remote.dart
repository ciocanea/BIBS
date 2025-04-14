
import 'package:logging/logging.dart';

import '../../../utils/result.dart';
import '../../models/user_profile_model.dart';
import '../../services/api/user_api.dart';
import '../../services/local/shared_prefrences_service.dart';
import '../../services/responses.dart/profile_response.dart';
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

  @override
  Future<Result<UserProfile>> getUserProfile () async {
    if(_userProfile != null) {
      _log.info('User profile already loaded in memory. Returning cached profile.');
      return Future.value(Result.ok(_userProfile!));
    }

    final sharedPrefResult = await _sharedPreferencesService.fetchUserId();
    String? id;

    switch (sharedPrefResult) {
      case Ok<String?>():
        id = sharedPrefResult.value;
      case Error<String?>():
        _log.severe('Failed to fetch user ID: ${sharedPrefResult.error}');
        return Result.error(sharedPrefResult.error);
    }

    if(id == null) {
      Result.error(Exception('User id is null'));
    }

    final userResult = await _userClient.getUserProfile(id!);
    switch (userResult) {
      case Ok<ProfileResponse>():
        final userProfile = UserProfile.fromJson(userResult.value.profile);
        _userProfile = userProfile;

        _log.info('User profile successfully fetched and cached.');
        return Result.ok(userProfile);
      case Error<ProfileResponse>():
        _log.severe('Failed to fetch user profile: ${userResult.error}');
        return Result.error(userResult.error);
    }
  }
}