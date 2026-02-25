import 'package:flutter/material.dart';

import '../../../core/themes/colors.dart';
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
        DataCell(Row(
          children: [
            Text('${index + 1}'),
            SizedBox(width: 10.0),
            CircleAvatar(
              backgroundColor: AppColors.primaryColor,
              radius: 18,
              backgroundImage: userTime.imagePath != null
                ? NetworkImage(userTime.imagePath!)
                : null,
              child: userTime.imagePath == null
                  ? const Icon(Icons.person, size: 24, color: AppColors.secondaryColor,)
                  : null,
            ),
          ],
        )),
        DataCell(Text(userTime.username, overflow: TextOverflow.ellipsis)),
        DataCell(Text(formattedUserTime(userTime.totalTime), overflow: TextOverflow.ellipsis)),
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
    final hours = (duration.inHours % 24).toString().padLeft(1, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(1, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(1, '0');

    return '${days}d ${hours}h ${minutes}m ${seconds}s';
  }
}

class MyLeaderboard extends StatefulWidget {
  const MyLeaderboard({
    super.key,
    required this.leaderboardDataSource,
    required this.userId,
    this.rowsPerPage = 30,
  });

  final List<UserTime> leaderboardDataSource;
  final String userId;
  final int rowsPerPage;

  @override
  State<MyLeaderboard> createState() => _MyLeaderboardState();
}

class _MyLeaderboardState extends State<MyLeaderboard> {
  late final int _userPageIndex;
  late final int _initialFirstRowIndex;
  late final Key _tableKey;

  @override
  void initState() {
    super.initState();
    final userIndex = widget.leaderboardDataSource.indexWhere((u) => u.userId == widget.userId);
    _userPageIndex = userIndex >= 0 ? userIndex ~/ widget.rowsPerPage : 0;
    _initialFirstRowIndex = _userPageIndex * widget.rowsPerPage;

    // Changing the key will force the DataTable to rebuild from scratch.
    _tableKey = ValueKey('leaderboard-${_initialFirstRowIndex}');
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: PaginatedDataTable(
              key: _tableKey, // critical to force jump to new page
              columns: const [
                DataColumn(label: Center(child: Text('Pos.'))),
                DataColumn(label: Center(child: Text('Username'))),
                DataColumn(label: Center(child: Text('Total Time'))),
              ],
              source: LeaderboardDataSource(widget.leaderboardDataSource, widget.userId),
              rowsPerPage: widget.rowsPerPage,
              columnSpacing: 12,
              initialFirstRowIndex: _initialFirstRowIndex,
              onPageChanged: (_) {}, // optional
            ),
          ),
        );
      },
    );
  }
}
