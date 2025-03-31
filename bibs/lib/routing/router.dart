import 'package:bibs/ui/auth/view_models/sign_up_viewmodel.dart';
import 'package:bibs/ui/auth/widgets/sign_up_screen.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:bibs/routing/routes.dart';
import 'package:provider/provider.dart';

import '../ui/session/widgets/session_screen.dart';
import '../ui/session/view_models/session_viewmodel.dart';

GoRouter router () => GoRouter(
  initialLocation: Routes.session,
  debugLogDiagnostics: true,
  redirect: _redirect,
  routes: [
    GoRoute(
      path: Routes.session,
      builder: (context, state) {
        return SessionScreen(
          viewModel: SessionViewModel()
        );
      },
    ),
    GoRoute(
      path: Routes.signUp,
      builder: (context, state) {
        return SignUpScreen(
          viewModel: SignUpViewModel(authRepository: context.read())
        );
      },
    )
  ]
);

Future<String?> _redirect(BuildContext context, GoRouterState state) async {
  return Routes.signUp;
}