import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../data/repositories/auth_repository.dart';
import '../ui/auth/view_models/sign_in_viewmodel.dart';
import '../ui/auth/view_models/sign_up_viewmodel.dart';
import '../ui/auth/widgets/sign_in_screen.dart';
import '../ui/auth/widgets/sign_up_screen.dart';
import '../ui/navigation/navigation_bar.dart';
import '../ui/session/widgets/session_screen.dart';
import '../ui/session/view_models/session_viewmodel.dart';
import '../ui/stats/view_models/stats_viewmodel.dart';
import '../ui/stats/widgets/stats_screen.dart';
import 'routes.dart';

GoRouter router () => GoRouter(
  initialLocation: Routes.session,
  debugLogDiagnostics: true,
  redirect: _redirect,
  routes: [
    ShellRoute(
      builder: (context, state, child) => MyNavigationBar(
        child: child,
        currentLocation: state.uri.toString()
        ),
      routes: [
        GoRoute(
          path: Routes.session,
          builder: (context, state) {
            return SessionScreen(
              viewModel: SessionViewModel(
                authRepository: context.read(),
                userRepository: context.read(),
              )
            );
          },
        ),
        GoRoute(
          path: Routes.stats,
          builder: (context, state) {
            return StatsScreen(
              viewModel: StatsViewModel(
                userRepository: context.read(),
              )
            );
          },
        ),

      ]
    ),
    GoRoute(
      path: Routes.signUp,
      builder: (context, state) {
        return SignUpScreen(
          viewModel: SignUpViewModel(authRepository: context.read())
        );
      },
    ),
    GoRoute(
      path: Routes.signIn,
      builder: (context, state) {
        return SignInScreen(
          viewModel: SignInViewModel(authRepository: context.read())
        );
      },
    )
  ]
);

Future<String?> _redirect(BuildContext context, GoRouterState state) async {
  final loggedIn = await context.read<AuthRepository>().isAuthenticated;

  final goingToSignIn = state.matchedLocation == Routes.signIn;
  final goingToSignUp = state.matchedLocation == Routes.signUp;

  final isAuthPage = goingToSignIn || goingToSignUp;

  if (!loggedIn && !isAuthPage) {
    // User is not logged in and trying to go somewhere else
    return Routes.signIn;
  }

  if (loggedIn && goingToSignIn) {
    // Already logged in and trying to go to login → redirect to session
    return Routes.session;
  }

  // All good, no redirect needed
  return null;
}