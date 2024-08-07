import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import './settings/setting_options.dart'; // import SettingOptions class
import './settings/font_size_provider.dart';

class PointsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnalysisPage(),
    );
  }
}

class AnalysisPage extends StatefulWidget {
  @override
  _AnalysisPageState createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  DateTime? _startDate;
  DateTime? _endDate;
  int totalPoints = 0;
  double totalRecycled = 0.0;
  int todayEarned = 0;
  int monthEarned = 0;
  int totalEarned = 0;
  int rangeEarned = 0;
  bool _isDisposed = false;
  bool _isKgEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _fetchData();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final settingOptions = Provider.of<SettingOptions>(context, listen: false);
    bool isKgEnabled = await settingOptions.isKgEnabled();
    if (!_isDisposed) {
      setState(() {
        _isKgEnabled = isKgEnabled;
      });
    }
  }

  Future<void> _fetchData() async {
    await _getTotalPointsAndRecycled();
    await _getEarnedPoints();
  }

  Future<void> _getTotalPointsAndRecycled() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && !_isDisposed) {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (!_isDisposed) {
        setState(() {
          totalPoints = userDoc.data()?['total_points'] ?? 0;
          totalRecycled = userDoc.data()?['total_recycled'] ?? 0.0;
          if (_isKgEnabled) {
            totalRecycled *= 453.592; // Convert kg to pounds if setting is disabled
          }
        });
      }
    }
  }

  Future<void> _getEarnedPoints() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && !_isDisposed) {
      final now = DateTime.now();
      final todayStart = DateTime(now.year, now.month, now.day);
      final monthStart = DateTime(now.year, now.month, 1);

      final todayStartTimestamp = Timestamp.fromDate(todayStart);
      final monthStartTimestamp = Timestamp.fromDate(monthStart);

      final querySnapshot = await FirebaseFirestore.instance
          .collection('point_events')
          .where('user_id', isEqualTo: user.uid)
          .get();

      int todayPoints = 0;
      int monthPoints = 0;
      int totalPoints = 0;
      int totalRangePoints = 0;

      for (var doc in querySnapshot.docs) {
        final timestamp = doc['point_timestamp'] as Timestamp;
        final pointAmount = doc['point_amount'] as int;
        final pointEarned = doc['point_earned'] as bool;

        if (pointEarned) {
          if (timestamp.compareTo(todayStartTimestamp) >= 0) {
            todayPoints += pointAmount;
          }

          if (timestamp.compareTo(monthStartTimestamp) >= 0) {
            monthPoints += pointAmount;
          }

          if (_startDate != null && _endDate != null) {
            final startTimestamp = Timestamp.fromDate(_startDate!);
            final endTimestamp = Timestamp.fromDate(_endDate!.add(Duration(days: 1)));
            if (timestamp.compareTo(startTimestamp) >= 0 && timestamp.compareTo(endTimestamp) < 0) {
              totalRangePoints += pointAmount;
            }
          }
          totalPoints += pointAmount;
        }
      }

      if (!_isDisposed) {
        setState(() {
          todayEarned = todayPoints;
          monthEarned = monthPoints;
          totalEarned = totalPoints;
          rangeEarned = totalRangePoints;
        });
      }
    }
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
      await _fetchData(); // Re-fetch data to update the range points
    }
  }

  @override
  Widget build(BuildContext context) {
    final fontSizeProvider = Provider.of<FontSizeProvider>(context);
    const double baseFontSize = 16.0;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _Header(fontSizeProvider: fontSizeProvider),
            SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  _InfoCard(
                    icon: Icons.recycling,
                    title: 'Total Recycled',
                    value: _isKgEnabled
                        ? '${totalRecycled.toStringAsFixed(2)} g'
                        : '${totalRecycled.toStringAsFixed(2)} lbs',
                    fontSizeProvider: fontSizeProvider,
                    baseFontSize: baseFontSize,
                  ),
                  _InfoCard(
                    icon: Icons.point_of_sale,
                    title: 'Total Points',
                    value: '$totalPoints P',
                    fontSizeProvider: fontSizeProvider,
                    baseFontSize: baseFontSize,
                  ),
                  _SummaryItem(
                    amount: '$todayEarned',
                    title: 'Today Earned',
                    fontSizeProvider: fontSizeProvider,
                    baseFontSize: baseFontSize,
                  ),
                  _SummaryItem(
                    amount: '$monthEarned',
                    title: 'This Month Earned',
                    fontSizeProvider: fontSizeProvider,
                    baseFontSize: baseFontSize,
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            _AttendanceSection(
              startDate: _startDate,
              endDate: _endDate,
              onSelectDateRange: _selectDateRange,
              rangeEarned: rangeEarned,
              fontSizeProvider: fontSizeProvider,
              baseFontSize: baseFontSize,
            )
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final FontSizeProvider fontSizeProvider;

  const _Header({required this.fontSizeProvider});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'Points',
          style: TextStyle(
            fontSize: fontSizeProvider.getFontSize(26.0),
            fontWeight: FontWeight.bold,
            color: Color(0xff009e73),
            fontFamily: 'Ubuntu',
          ),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final FontSizeProvider fontSizeProvider;
  final double baseFontSize;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.fontSizeProvider,
    required this.baseFontSize,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Card(
      color: isDarkMode ? Colors.grey[800] : Colors.white,
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Color(0xff009e73)),
                SizedBox(width: 8),
                Flexible(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: fontSizeProvider.getFontSize(baseFontSize - 1.0),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Ubuntu',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                  fontSize: fontSizeProvider.getFontSize(baseFontSize + 6.0),
                  color: Color(0xff009e73),
                  fontFamily: 'Ubuntu'
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String amount;
  final String title;
  final FontSizeProvider fontSizeProvider;
  final double baseFontSize;

  const _SummaryItem({
    required this.amount,
    required this.title,
    required this.fontSizeProvider,
    required this.baseFontSize,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Card(
      color: isDarkMode ? Colors.grey[800] : Colors.white,
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 35.0,
              backgroundColor: Color(0xff009e73),
              child: Text(
                amount,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: fontSizeProvider.getFontSize(18.0),
                  fontFamily: 'Ubuntu',
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: fontSizeProvider.getFontSize(14.0),
                fontWeight: FontWeight.bold,
                fontFamily: 'Ubuntu',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _AttendanceSection extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final Function(BuildContext) onSelectDateRange;
  final int rangeEarned;
  final FontSizeProvider fontSizeProvider;
  final double baseFontSize;

  const _AttendanceSection({
    required this.startDate,
    required this.endDate,
    required this.onSelectDateRange,
    required this.rangeEarned,
    required this.fontSizeProvider,
    required this.baseFontSize,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            spreadRadius: 1,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _AttendanceHeader(
            onSelectDateRange: onSelectDateRange,
            fontSizeProvider: fontSizeProvider,
            baseFontSize: baseFontSize,
          ),
          if (startDate != null)
            Text(
              'Start Date: ${DateFormat('yyyy-MM-dd').format(startDate!)}',
              style: TextStyle(
                fontSize: fontSizeProvider.getFontSize(baseFontSize),
                fontFamily: 'Ubuntu',
              ),
            ),
          if (endDate != null)
            Text(
              'End Date: ${DateFormat('yyyy-MM-dd').format(endDate!)}',
              style: TextStyle(
                fontSize: fontSizeProvider.getFontSize(baseFontSize),
                fontFamily: 'Ubuntu',
              ),
            ),
          SizedBox(height: 8),
          Text(
            'Points Earned: $rangeEarned P',
            style: TextStyle(
              fontSize: fontSizeProvider.getFontSize(baseFontSize),
              fontFamily: 'Ubuntu',
            ),
          ),
        ],
      ),
    );
  }
}

class _AttendanceHeader extends StatelessWidget {
  final Function(BuildContext) onSelectDateRange;
  final FontSizeProvider fontSizeProvider;
  final double baseFontSize;

  const _AttendanceHeader({
    required this.onSelectDateRange,
    required this.fontSizeProvider,
    required this.baseFontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Attendance',
              style: TextStyle(
                  fontSize: fontSizeProvider.getFontSize(18.0),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Ubuntu'
              ),
            ),
          ],
        ),
        ElevatedButton(
          onPressed: () => onSelectDateRange(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xff009e73),
          ),
          child: Text(
            'Calendar',
            style: TextStyle(
              fontSize: fontSizeProvider.getFontSize(baseFontSize),
              fontFamily: 'Ubuntu',
            ),
          ),
        ),
      ],
    );
  }
}

class _AttendanceItem extends StatelessWidget {
  final String month;
  final String status;
  final FontSizeProvider fontSizeProvider;
  final double baseFontSize;

  const _AttendanceItem({
    required this.month,
    required this.status,
    required this.fontSizeProvider,
    required this.baseFontSize,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.circle,
        color: Color(0xff009e73),
        size: 28.0,
      ),
      title: Text(
        month,
        style: TextStyle(
            fontSize: fontSizeProvider.getFontSize(baseFontSize),
            fontFamily: 'Ubuntu'
        ),
      ),
      subtitle: Text(
        status,
        style: TextStyle(
            fontSize: fontSizeProvider.getFontSize(baseFontSize - 2.0),
            fontFamily: 'Ubuntu'
        ),
      ),
    );
  }
}