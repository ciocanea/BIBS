import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../data/repositories/auth_repository.dart';
import '../data/repositories/auth_repository_remote.dart';
import '../data/services/api/auth_api.dart';
import '../data/services/local/shared_prefrences_service.dart';

List<SingleChildWidget> get providers {
  return [
    Provider(create: (context) => AuthClient()),
    Provider(create: (context) => SharedPreferencesService()),
    ChangeNotifierProvider(
      create: (context) => 
        AuthRepositoryRemote(
          authClient: context.read(), 
          sharedPreferencesService: context.read()
        ) as AuthRepository
    ),
  ];
}