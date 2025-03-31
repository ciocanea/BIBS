import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../data/repositories/auth_repository.dart';
import '../data/repositories/auth_repository_remote.dart';
import '../data/services/api/auth_api.dart';

List<SingleChildWidget> get providers {
  return [
    Provider(create: (context) => AuthClient()),
    ChangeNotifierProvider(create: (context) => AuthRepositoryRemote(authClient: context.read()) as AuthRepository),
  ];
}