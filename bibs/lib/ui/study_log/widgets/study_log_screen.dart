import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

import '../../../core/themes/dimentions.dart';
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
          SnackBar(content: Text('Failed to load page. Please check your internet connection and try again.'))
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
              final userProfile = widget.viewModel.userProfile;
              final studySessions = widget.viewModel.studySessions;

              if(userProfile == null) {
                return const CircularProgressIndicator();
              }

              if (studySessions == null) {
                return const CircularProgressIndicator();
              }

              if (studySessions.isEmpty) {
                return const Text('No study sessions found.');
              }

              return ListView(
                children: [
                  SizedBox(height: 16.0),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: Dimentions.paddingVertical, horizontal: Dimentions.paddingHorizontal),
                        child: Text(
                          "Your study sessions at ${userProfile.campus}",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  ...studySessions.mapIndexed((index, session) {
                    final startedAt = DateFormat('HH:mm / dd.MM.yyyy').format(session.startedAt);
                    final duration = widget.viewModel.formatDuration(Duration(milliseconds: session.duration));

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: Dimentions.paddingVertical, horizontal: Dimentions.paddingHorizontal),
                      child: Material(
                        elevation: Dimentions.elevation,
                        child: ListTile(
                          title: Text('Session #${studySessions.length - index}'),
                          subtitle: Text('Started at: $startedAt\nDuration: $duration'),
                          trailing: IconButton(
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('End Session'),
                                  content: const Text('Are you sure you want to delete this session?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(false),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(true),
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                ),
                              );

                              if (confirm == true) {
                                await widget.viewModel.deleteStudySession(session).then((result) {
                                  switch (result) {
                                    case Ok<void>():
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Study session #${studySessions.length - index + 1} deleted.'))
                                      );
                                    case Error<void>():
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Failed to delete study session. Please check your internet connection and try again.'))
                                      );
                                  }
                                });
                              }
                            },
                            icon: const Icon(Icons.delete),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}