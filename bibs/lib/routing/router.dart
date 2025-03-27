import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:bibs/routing/routes.dart';

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
    )
  ]
);

Future<String?> _redirect(BuildContext context, GoRouterState state) async {
  return Routes.session;
}