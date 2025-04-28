import 'package:flutter/material.dart';

import '../../../utils/result.dart';
import '../view_models/study_log_viewmodel.dart';

class StudyLogScreen extends StatefulWidget {
  const StudyLogScreen ({super.key, required this.viewModel});

  final StudyLogViewModel viewModel;

  @override
  _StudyLogScreenState createState() => _StudyLogScreenState();
}

class _StudyLogScreenState extends State<StudyLogScreen> {

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ListenableBuilder(
            listenable: widget.viewModel,
            builder: (context, _) {
              final studySessions = widget.viewModel.studySessions;

              if (studySessions == null) {
                return const Center(child: CircularProgressIndicator());
              }

              if (studySessions.isEmpty) {
                return const Center(child: Text('No study sessions found.'));
              }

              return ListView.builder(
                itemCount: studySessions.length,
                itemBuilder: (context, index) {
                  final session = studySessions[index];
                  return ListTile(
                    title: Text('Session ${index + 1}'),
                    subtitle: Text('Started at: ${session.startedAt}\nTime: ${session.time} ms'),
                    trailing: IconButton(
                      onPressed: () async {
                        await widget.viewModel.deleteStudySession(session);
                      },
                      icon: const Icon(Icons.delete)
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}