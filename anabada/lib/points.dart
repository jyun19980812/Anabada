import 'package:flutter/material.dart';





class PointsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Analysis'),
        ),
        body: AnalysisPage(),
      ),
    );
  }
}

class AnalysisPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          _buildTodayRecycled(),
          _buildDetails(),
          _buildAttendance(),
          _buildSummary(),
          _buildStateData(),
          _buildRanking(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Analysis',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Icon(Icons.notifications),
        ],
      ),
    );
  }

  Widget _buildTodayRecycled() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Today Recycled',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '50KG',
                style: TextStyle(fontSize: 36, color: Colors.green),
              ),
              Icon(Icons.check, color: Colors.green, size: 36),
            ],
          ),
          Column(
            children: [
              _buildRecycledType('Plastic'),
              _buildRecycledType('Battery'),
              _buildRecycledType('Paper'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecycledType(String type) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Chip(
        label: Text(type),
      ),
    );
  }

  Widget _buildDetails() {
    // Details 그래프를 위한 임시 위젯
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Details',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Container(
            height: 150,
            width: double.infinity,
            color: Colors.grey[300], // 그래프를 나타내는 임시 컨테이너
            child: Text("여기에 그래프", textAlign: TextAlign.center,),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendance() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Attendance',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text('From January ~ July'),
          _buildAttendanceItem('January', 'Recycled 0/10kg'),
          _buildAttendanceItem('February', 'Recycled 0/10kg'),
          _buildAttendanceItem('March', 'Recycled 0/10kg'),
          _buildAttendanceItem('April', 'Recycled 0/10kg'),
          _buildAttendanceItem('May', 'Recycled 0/10kg'),
          _buildAttendanceItem('June', 'Recycled 0/10kg'),
        ],
      ),
    );
  }

  Widget _buildAttendanceItem(String month, String status) {
    return ListTile(
      // if문 써서 리사이클 한 양 없으면 "Did not recyle!" 나오게 해야할듯
      leading : Icon(Icons.circle, color: Color(0xff009e73)),
      title: Text(month, style: TextStyle(fontWeight: FontWeight.bold),),
      trailing: Text(status),
    );
  }

  Widget _buildSummary() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryItem('50', 'Total Earned', 'Today Earned'),
          _buildSummaryItem('523', 'Total Earned', 'This Month Earned'),
          _buildSummaryItem('2523', 'Total Earned', 'Total Earned'),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String amount, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.green,
            child: Text(
              amount,
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text(subtitle, style: TextStyle(color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStateData() {
    // 주 데이터 요약을 위한 임시 위젯
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Massachusetts',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Container(
            height: 100,
            color: Colors.grey[300], // 주 데이터를 나타내는 임시 컨테이너
          ),
        ],
      ),
    );
  }

  Widget _buildRanking() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children  : [Text(
              'Ranking',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
              Tooltip(
                message: 'This is a help icon.',
                child: Icon(Icons.question_mark_rounded),
              ),
          ],
          ),
          _buildRankingItem('Massachusetts', '2.97'),
          _buildRankingItem('Pennsylvania', '1.77'),
        ],
      ),
    );
  }

  Widget _buildRankingItem(String state, String score) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.green,
        child: Text(state.substring(0, 1)),
      ),
      title: Text(state),
      trailing: Text(score),
    );
  }
}
