import 'package:flutter/material.dart';

import '../../../data/models/user_time/user_time_model.dart';

class LeaderboardDataSource extends DataTableSource {

  LeaderboardDataSource(this.userTimes, this.userId);
  
  final List<UserTime> userTimes;
  final String userId; 

  @override
  DataRow? getRow(int index) {
    if (index >= userTimes.length) return null;
    final userTime = userTimes[index];

    final isUserRow = userTime.userId == userId;
    return DataRow.byIndex(
      index: index,
      color: isUserRow
          ? WidgetStateProperty.all(const Color.fromARGB(119, 251, 255, 2))
          : null,
      cells: [
        DataCell(Text('${index + 1}')),
        DataCell(Text(userTime.username)),
        DataCell(Text(formattedUserTime(userTime.totalTime))),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => userTimes.length;

  @override
  int get selectedRowCount => 0;

  String formattedUserTime(int userTime) {
    final duration = Duration(milliseconds: userTime);

    final days = duration.inDays.toString();
    final hours = (duration.inHours % 24).toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');

    return '${days}D ${hours}H ${minutes}M ${seconds}S';
  }
}

class MyLeaderboard extends StatelessWidget {

  const MyLeaderboard({super.key, required this.leaderboardDataSource, required this.userId});

  final List<UserTime> leaderboardDataSource;
  final String userId;

  @override
  Widget build(BuildContext context){
    return PaginatedDataTable(
      header: Text('Leaderboard'),
      columns: const [
        DataColumn(label: Text('Pos.')),
        DataColumn(label: Text('Username')),
        DataColumn(label: Text('Total Time'))
      ],
      source: LeaderboardDataSource(leaderboardDataSource, userId),
      rowsPerPage: 5,
    );
  }
}