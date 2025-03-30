import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../view_models/session_viewmodel.dart';

class SessionScreen extends StatefulWidget {
  const SessionScreen ({super.key, required this.viewModel});

  final SessionViewModel viewModel;

  @override
  State<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  @override
  void dispose() {
    widget.viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Session"),
      ),
      body: SafeArea(
        child: Center(
          child: ListenableBuilder(
            listenable: widget.viewModel,
            builder:(context, _) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CupertinoButton(
                  onPressed: widget.viewModel.startStop,
                  child: Text(widget.viewModel.formattedTime),
                ),
                CupertinoButton(
                  onPressed: widget.viewModel.reset,
                  child: Text("Reset"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

