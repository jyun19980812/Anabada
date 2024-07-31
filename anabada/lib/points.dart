import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class PointsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: AnalysisPage(),
      ),
    );
  }
}

class AnalysisPage extends StatefulWidget {
  @override
  _AnalysisPageState createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  DateTime? _selectedDate;
  int totalPoints = 0;
  double totalRecycled = 0.0;
  int todayEarned = 0;
  int monthEarned = 0;
  int totalEarned = 0;

  @override
  void initState() {
    super.initState();
    _getTotalPointsAndRecycled();
    _getEarnedPoints();
  }

  Future<void> _getTotalPointsAndRecycled() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      setState(() {
        totalPoints = userDoc.data()?['total_points'] ?? 0;
        totalRecycled = userDoc.data()?['total_recycled'] ?? 0.0;
      });
    }
  }

  Future<void> _getEarnedPoints() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
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

      for (var doc in querySnapshot.docs) {
        final timestamp = doc['point_timestamp'] as Timestamp;
        final pointAmount = doc['point_amount'] as int;

        if (timestamp.compareTo(todayStartTimestamp) >= 0) {
          todayPoints += pointAmount;
        }

        if (timestamp.compareTo(monthStartTimestamp) >= 0) {
          monthPoints += pointAmount;
        }

        totalPoints += pointAmount;
      }

      setState(() {
        todayEarned = todayPoints;
        monthEarned = monthPoints;
        totalEarned = totalPoints;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildHeader(),
            SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  _buildInfoCard(
                    icon: Icons.recycling,
                    title: 'Total Recycled',
                    value: '${totalRecycled.toStringAsFixed(2)} Pounds',
                  ),
                  _buildInfoCard(
                    icon: Icons.point_of_sale,
                    title: 'Total Points',
                    value: '$totalPoints P',
                  ),
                  _buildSummaryItem('$todayEarned', 'Today Earned'),
                  _buildSummaryItem('$monthEarned', 'This Month Earned'),
                ],
              ),
            ),
            SizedBox(height: 16),
            _buildAttendance(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'Points',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xff009e73)),
        ),
      ],
    );
  }

  Widget _buildInfoCard({required IconData icon, required String title, required String value}) {
    return Card(
      color: Colors.white,
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
                Icon(icon, size: 36, color: Color(0xff009e73)), // 조정된 아이콘 크기
                SizedBox(width: 8),
                Flexible(
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // 조정된 텍스트 크기
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(fontSize: 24, color: Color(0xff009e73)), // 조정된 값 텍스트 크기
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String amount, String title) {
    return Card(
      color: Colors.white,
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 35, // 조정된 원 크기
              backgroundColor: Color(0xff009e73),
              child: Text(
                amount,
                style: TextStyle(color: Colors.white, fontSize: 20), // 조정된 텍스트 크기
              ),
            ),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), // 조정된 텍스트 크기
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendance(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Attendance',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // 조정된 텍스트 크기
                  ),
                  Text('Selected'),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  _selectDate(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff009e73),
                ),
                child: Text('Calendar'),
              ),
            ],
          ),
          if (_selectedDate != null) _buildSelectedDate(),
        ],
      ),
    );
  }

  Widget _buildSelectedDate() {
    return _buildAttendanceItem(DateFormat('MMMM').format(_selectedDate!), 'Recycled 0 pounds');
  }

  Widget _buildAttendanceItem(String month, String status) {
    return ListTile(
      leading: Icon(Icons.circle, color: Color(0xff009e73), size: 28), // 조정된 아이콘 크기
      title: Text(
        month,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), // 조정된 텍스트 크기
      ),
      trailing: Text(
        status,
        style: TextStyle(fontSize: 16), // 조정된 텍스트 크기
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2199),
    );
    if (selected != null && selected != _selectedDate) {
      setState(() {
        _selectedDate = selected;
      });
    }
  }
}