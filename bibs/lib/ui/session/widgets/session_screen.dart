import 'package:bibs/core/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/themes/dimentions.dart';
import '../../../utils/result.dart';
import '../view_models/session_viewmodel.dart';

class SessionScreen extends StatefulWidget {
  const SessionScreen ({super.key});

  // final SessionViewModel viewModel;

  @override
  State<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> with WidgetsBindingObserver  {
  late final SessionViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _viewModel = context.read<SessionViewModel>();
    

    _viewModel.load().then((result) {
      if (result is Error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load page. Please check your internet connection and try again.'))
        );
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden ||
        state == AppLifecycleState.inactive) {
      _viewModel.pauseOnAppInactive();
      return;
    }

    if (state == AppLifecycleState.resumed &&
        _viewModel.showPausedDialogOnResume &&
        !_viewModel.isPausedDialogOpen &&
        mounted) {
      _viewModel.showPausedDialogOnResume = false;
      _viewModel.isPausedDialogOpen = true;

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted) {
          _viewModel.isPausedDialogOpen = false;
          return;
        }

        await showDialog<void>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('OOPS! Your session is paused.'),
            content: const Text(
              'Looks like your session was paused because you exited the app or your phone was closed. Keep your focus, you got this!',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Ok'),
              ),
            ],
          ),
        );

        _viewModel.isPausedDialogOpen = false;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ListenableBuilder(
            listenable: _viewModel,
            builder:(context, _) {
              final userProfile = _viewModel.userProfile;

              if(userProfile == null) {
                return const CircularProgressIndicator();
              }

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Material(
                    shape: const CircleBorder(),
                    elevation: Dimentions.elevation,
                    child: Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 8.0,
                        ),
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      child: Center(
                        child: Text(
                          _viewModel.formattedTime,
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.darkSecondaryColor)
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 50),

                  SizedBox(
                    height: 140,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: _buildControlButtons(),
                    ),
                  ),
                  
                ],
              );
            }
          ),
        ),
      ),
    );
  }

  List<Widget> _buildControlButtons() {
    final style = ButtonStyle(
      textStyle: const WidgetStatePropertyAll<TextStyle>(
        TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      minimumSize: const WidgetStatePropertyAll(Size(200, 60)),
    );

    if (_viewModel.isRunning && !_viewModel.isPaused) {
      return [
        ElevatedButton(
          onPressed: _viewModel.pauseUnpause,
          style: style,
          child: const Text("Pause"),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () async {
            final confirm = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('End Session'),
                content: const Text('Are you sure you want to end the session?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('End'),
                  ),
                ],
              ),
            );

            if (confirm == true) {
              _viewModel.updateTotalTime().then((result) {
                switch (result) {
                  case Ok<void>():
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Study session saved.'))
                    );
                  case Error<void>():
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to save study session. Please check your internet connection and try again.'))
                    );
                }
              });
            }
          },
          style: style,
          child: const Text("End session"),
        ),
      ];
    } else if (_viewModel.isPaused) {
      return [
        ElevatedButton(
          onPressed: _viewModel.pauseUnpause,
          style: style,
          child: const Text("Resume"),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () async {
            final confirm = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('End Session'),
                content: const Text('Are you sure you want to end the session?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('End'),
                  ),
                ],
              ),
            );

            if (confirm == true) {
              _viewModel.updateTotalTime().then((result) {
                switch (result) {
                  case Ok<void>():
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Study session saved.'))
                    );
                  case Error<void>():
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to save study session. Please check your internet connection and try again.'))
                    );
                }
              });
            }
          },
          style: style,
          child: const Text("End session"),
        ),
      ];
    } else {
      return [
        ElevatedButton(
          onPressed: _viewModel.start,
          style: style,
          child: const Text("Start"),
        ),
      ];
    }
  }
}