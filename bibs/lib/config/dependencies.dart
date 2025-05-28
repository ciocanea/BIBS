import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../data/repositories/auth/auth_repository.dart';
import '../data/repositories/auth/auth_repository_remote.dart';
import '../data/repositories/leaderboard/leaderboard_repository.dart';
import '../data/repositories/leaderboard/leaderboard_repository_remote.dart';
import '../data/repositories/session/study_session_repository.dart';
import '../data/repositories/session/study_session_repository_remote.dart';
import '../data/repositories/user/user_repository.dart';
import '../data/repositories/user/user_repository_remote.dart';
import '../data/services/api/auth_api.dart';
import '../data/services/api/leaderboard_api.dart';
import '../data/services/api/study_session_api.dart';
import '../data/services/api/user_api.dart';
import '../data/services/local/shared_prefrences_service.dart';
import '../ui/session/view_models/session_viewmodel.dart';

List<SingleChildWidget> get providers {
  return [
    Provider(create: (context) => AuthClient()),
    Provider(create: (context) => UserClient()),
    Provider(create: (context) => LeaderboardClient()),
    Provider(create: (context) => StudySessionClient()),
    Provider(create: (context) => SharedPreferencesService()),
    ChangeNotifierProvider(
      create: (context) => 
        AuthRepositoryRemote(
          authClient: context.read(), 
          sharedPreferencesService: context.read()
        ) as AuthRepository
    ),
    ProxyProvider<AuthRepository, UserRepository>(
      update: (context, authRepo, previousRepo) {
        final userRepository = previousRepo ?? UserRepositoryRemote(
          userClient: context.read(),
          sharedPreferencesService: context.read(),
        );

        if (!authRepo.resetTrigger) {
          userRepository.clear(); // Invalidate cache if the user signed out
        }

        return userRepository;
      },
    ),
    Provider(
      create: (context) => 
        LeaderboardRepositoryRemote(
          leaderboardClient: context.read(),
        ) as LeaderboardRepository
    ),
    Provider(
      create: (context) => 
        StudySessionRepositoryRemote(
          studySessionClient: context.read(),
        ) as StudySessionRepository
    ),
    ChangeNotifierProvider(
      create: (context) => SessionViewModel(
        userRepository: context.read(),
        studySessionRepository: context.read(),
      ),
    ),

  ];
}