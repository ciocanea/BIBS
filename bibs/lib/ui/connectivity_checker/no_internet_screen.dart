import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../routing/routes.dart';
import '../../../data/repositories/auth/auth_repository.dart';
import '../../../ui/connectivity_checker/connectivity_checker.dart';
class NoConnectionScreen extends StatelessWidget {
  const NoConnectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off, size: 64),
            const SizedBox(height: 16),
            const Text(
              'No internet connection',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final isOnline = await hasInternetAccess();

                if (!isOnline) return;

                final isAuthenticated =
                    await context.read<AuthRepository>().isAuthenticated;

                if (isAuthenticated) {
                  context.go(Routes.session);
                } else {
                  context.go(Routes.signIn);
                }
              },
              child: const Text('Retry'),
            )
          ],
        ),
      ),
    );
  }
}
