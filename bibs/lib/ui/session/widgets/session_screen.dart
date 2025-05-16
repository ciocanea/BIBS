import 'package:bibs/core/themes/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/themes/dimentions.dart';
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
                  Material(
                    shape: const CircleBorder(),
                    elevation: Dimentions.elevation,
                    child: Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primaryColor,
                          width: 8.0,
                        ),
                        color: AppColors.secondaryColor,
                      ),
                      child: Center(
                        child: Text(
                          widget.viewModel.formattedTime,
                          style: const TextStyle(fontSize: 24),
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

    if (widget.viewModel.isRunning && !widget.viewModel.isPaused) {
      return [
        ElevatedButton(
          onPressed: widget.viewModel.pauseUnpause,
          style: style,
          child: const Text("Take a break"),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: widget.viewModel.updateTotalTime,
          style: style,
          child: const Text("End session"),
        ),
      ];
    } else if (widget.viewModel.isPaused) {
      return [
        ElevatedButton(
          onPressed: widget.viewModel.pauseUnpause,
          style: style,
          child: const Text("Resume"),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: widget.viewModel.updateTotalTime,
          style: style,
          child: const Text("End session"),
        ),
      ];
    } else {
      return [
        ElevatedButton(
          onPressed: widget.viewModel.start,
          style: style,
          child: const Text("Start"),
        ),
      ];
    }
  }
}

