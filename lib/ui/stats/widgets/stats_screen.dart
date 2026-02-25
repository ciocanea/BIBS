import 'package:flutter/material.dart';

import '../../../core/themes/colors.dart';
import '../../../core/themes/dimentions.dart';
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
                            widget.viewModel.formattedUserTime,
                            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.darkSecondaryColor, height: 1.2)
                          ),
                        ),
                      ),
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