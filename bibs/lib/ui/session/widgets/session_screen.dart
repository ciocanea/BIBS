import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../routing/routes.dart';
import '../../../utils/result.dart';
import '../view_models/session_viewmodel.dart';

class SessionScreen extends StatefulWidget {
  const SessionScreen ({super.key, required this.viewModel});

  final SessionViewModel viewModel;

  @override
  State<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {

  @override
  void initState() {
    super.initState();
    widget.viewModel.load().then((result) {
      if (result is Error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load profile: ${result.error}'))
        );
      }
    });
    widget.viewModel.setUserCampus('TU-Delft');
  }

  @override
  void dispose() {
    widget.viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Session'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            tooltip: 'Sign Out',
            onPressed: () async {
              final result = await widget.viewModel.signOut();

              if(result is Error<void>) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${result.error}')
                  )
                );
                return;
              }

              context.go(Routes.signIn);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ListenableBuilder(
            listenable: widget.viewModel,
            builder:(context, _) {
              final userProfile = widget.viewModel.userProfile;

              if(userProfile == null) {
                return const CircularProgressIndicator();
              }

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(userProfile.id),
                  Text(userProfile.username),
                  Text(userProfile.campus ?? 'null'),
                  CupertinoButton(
                    onPressed: widget.viewModel.startStop,
                    child: Text(widget.viewModel.formattedTime),
                  ),
                  CupertinoButton(
                    onPressed: widget.viewModel.reset,
                    child: Text('Reset'),
                  )
                ],
              );
            }
          ),
        ),
      ),
    );
  }
}

