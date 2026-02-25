import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../routing/routes.dart';
import '../session/view_models/session_viewmodel.dart';

class MyNavigationBar extends StatelessWidget {

  const MyNavigationBar({
    super.key,
    required this.child,
    required this.currentLocation,
  });

  final Widget child;
  final String currentLocation;

  static final tabs = [
    Routes.session,
    Routes.studyLog,
    Routes.stats,
    Routes.profile
  ];

  @override
  Widget build(BuildContext context) {
    final index = tabs.indexWhere((path) => currentLocation.startsWith(path));
    final currentIndex = index < 0 ? 0 : index;

    final titles = ['Session', 'Study Log', 'Stats', 'Account'];
    final title = titles[currentIndex];

    return Scaffold(
      appBar: AppBar(
        leading: Image.asset(
          'assets/images/bibs_logo_no_bg.png',
          height: 25,
        ),
        title: Text(title),
      ),
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (idx) {
          final sessionViewModel = context.read<SessionViewModel>();

          if (sessionViewModel.isRunning && idx != 0) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('End your session before switching tabs.')),
            );
            return;
          }

          context.go(tabs[idx]);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.timer), label: 'Session'),
          BottomNavigationBarItem(icon: Icon(Icons.paste), label: 'Study Log'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Stats'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
      ),
    );
  }
}
