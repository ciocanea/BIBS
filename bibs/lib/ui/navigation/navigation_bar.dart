import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../routing/routes.dart';

class MyNavigationBar extends StatelessWidget {

  const MyNavigationBar({
    super.key,
    required this.child,
    required this.currentLocation
  });

  final Widget child;
  final String currentLocation;

  static final tabs = [
    Routes.session,
    Routes.studyLog,
    Routes.stats,
  ];

  @override
  Widget build(BuildContext context) {
    final index = tabs.indexWhere((path) => currentLocation.startsWith(path));
    final currentIndex = index < 0 ? 0 : index;

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (idx) => context.go(tabs[idx]),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.timer), label: 'Session'),
          BottomNavigationBarItem(icon: Icon(Icons.paste), label: 'Study Log'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Stats'),
        ],
      ),
    );
  }
}
