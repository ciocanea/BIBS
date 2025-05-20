import 'package:flutter/material.dart';

import '../../../utils/result.dart';
import '../view_models/stats_viewmodel.dart';
import 'leaderboard.dart';


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
      body: SafeArea(
        child: Center(
          child: ListenableBuilder(
            listenable: widget.viewModel,
            builder:(context, _) {
              final userProfile = widget.viewModel.userProfile;
              final userTime = widget.viewModel.userTotalTime;
              final leaderboard = widget.viewModel.leaderboard;

              if(userProfile == null || userTime == null) {
                return const CircularProgressIndicator();
              }

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 32.0),

                    // Text(
                    //   "Total study time at ${userProfile.campus}",
                    //   style: Theme.of(context).textTheme.headlineMedium,
                    // ),

                    // SizedBox(height: 16.0),

                    Text(
                      widget.viewModel.formattedUserTime,
                      style: Theme.of(context).textTheme.headlineLarge
                    ),

                    SizedBox(height: 32.0),

                    Divider(),

                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Also studying at ${userProfile.campus}',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                    
                    MyLeaderboard(
                      leaderboardDataSource: leaderboard!,
                      userId: userProfile.userId,
                    ),
                  ],
                ),
              );
            }
          ),
        ),
      ),
    );
  }
}