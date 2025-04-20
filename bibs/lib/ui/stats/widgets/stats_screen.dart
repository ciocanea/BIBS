import 'package:flutter/material.dart';

import '../../../utils/result.dart';
import '../view_models/stats_viewmodel.dart';


class StatsScreen extends StatefulWidget {
  const StatsScreen ({super.key, required this.viewModel});

  final StatsViewModel viewModel;

  @override
  _StatsScreenState createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {

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
      appBar: AppBar(
        title: Text('Stats'),
      ),
      body: SafeArea(
        child: Center(
          child: ListenableBuilder(
            listenable: widget.viewModel,
            builder:(context, _) {
              final userProfile = widget.viewModel.userProfile;
              final userTime = widget.viewModel.userTime;

              if(userProfile == null || userTime == null) {
                return const CircularProgressIndicator();
              }

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(userProfile.id),
                  Text(userProfile.username),
                  Text(userProfile.campus ?? 'null'),
                  Text(widget.viewModel.formattedUserTime)
                ],
              );
            }
          ),
        ),
      ),
    );
  }
}