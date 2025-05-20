import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../data/repositories/auth/auth_repository.dart';
import '../ui/auth/view_models/forgot_password_viewmodel.dart';
import '../ui/auth/view_models/reset_password_viewmodel.dart';
import '../ui/auth/view_models/sign_in_viewmodel.dart';
import '../ui/auth/view_models/sign_up_viewmodel.dart';
import '../ui/auth/widgets/forgot_password_screen.dart';
import '../ui/auth/widgets/reset_password_screen.dart';
import '../ui/auth/widgets/sign_in_screen.dart';
import '../ui/auth/widgets/sign_up_screen.dart';
import '../ui/navigation/navigation_bar.dart';
import '../ui/profile/view_models/profile_viewmodel.dart';
import '../ui/profile/widgets/profile_screen.dart';
import '../ui/session/widgets/session_screen.dart';
import '../ui/stats/view_models/stats_viewmodel.dart';
import '../ui/stats/widgets/stats_screen.dart';
import '../ui/study_log/view_models/study_log_viewmodel.dart';
import '../ui/study_log/widgets/study_log_screen.dart';
import 'routes.dart';

GoRouter router () => GoRouter(
  initialLocation: Routes.session,
  debugLogDiagnostics: true,
  redirect: _redirect,
  routes: [
    ShellRoute(
      builder: (context, state, child) {

        return MyNavigationBar(
          child: child,
          currentLocation: state.uri.toString(),
        );
      },
      routes: [
        GoRoute(
          path: Routes.session,
          builder: (context, state) {
            return SessionScreen(
              // viewModel: SessionViewModel(
              //   authRepository: context.read(),
              //   userRepository: context.read(),
              //   studySessionRepository: context.read(),
              // )
            );
          },
        ),
        GoRoute(
          path: Routes.studyLog,
          builder: (context, state) {
            return StudyLogScreen(
              viewModel: StudyLogViewModel(
                userRepository: context.read(),
                studySessionRepository: context.read(),
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
                leaderboardRepository: context.read()
              )
            );
          },
        ),
        GoRoute(
          path: Routes.profile,
          builder: (context, state) {
            return ProfileScreen(
              viewModel: ProfileViewmodel(
                authRepository: context.read(),
                userRepository: context.read(),
              )
            );
          },
        ),

      ]
    ),
    GoRoute(
      path: Routes.profile,
      builder:(context, state) {
        return ProfileScreen(
          viewModel: ProfileViewmodel(
            authRepository: context.read(),
            userRepository: context.read()
          ),
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
    ),
    GoRoute(
      path: Routes.signIn,
      builder: (context, state) {
        return SignInScreen(
          viewModel: SignInViewModel(authRepository: context.read())
        );
      },
    ),
    GoRoute(
      path: Routes.forgotPassword,
      builder: (context, state) {
        return ForgotPasswordScreen(
          viewModel: ForgotPasswordViewModel(authRepository: context.read())
        );
      },
    ),
    GoRoute(
      path: Routes.resetPassword,
      builder: (context, state) {
        return ResetPasswordScreen(
          viewModel: ResetPasswordViewModel(authRepository: context.read())
        );
      },
    )
  ],
);

Future<String?> _redirect(BuildContext context, GoRouterState state) async {
  final loggedIn = await context.read<AuthRepository>().isAuthenticated;

  final goingToSignIn = state.matchedLocation == Routes.signIn;
  final goingToSignUp = state.matchedLocation == Routes.signUp;
  final goingToForgotPassword = state.matchedLocation == Routes.forgotPassword;
  final goingToResetPassword = state.matchedLocation == Routes.resetPassword;

  final isAuthPage = goingToSignIn || goingToSignUp || goingToForgotPassword || goingToResetPassword;

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