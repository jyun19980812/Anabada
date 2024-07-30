import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/settings/font_size_provider.dart';

class RewardHistoryScreen extends StatefulWidget {
  const RewardHistoryScreen({super.key});

  @override
  _RewardHistoryScreenState createState() => _RewardHistoryScreenState();
}

class _RewardHistoryScreenState extends State<RewardHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    final fontSizeProvider = Provider.of<FontSizeProvider>(context);
    final baseFontSize = 20.0;

    return Scaffold(
      appBar: AppBar(
        title: Text('Reward History'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Text(
              'Reward History',
              style: TextStyle(
                fontSize: fontSizeProvider.getFontSize(baseFontSize),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  return RewardCard(
                    date: '2024. 07. 24.',
                    description: '구매 내역\n스타벅스 \$10',
                    points: '${(index + 1) * 10000 + 2350} points',
                    imageUrl: 'assets/starbucksgiftcard.png', // 이미지 경로에 맞게 변경하세요
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RewardCard extends StatelessWidget {
  final String date;
  final String description;
  final String points;
  final String imageUrl;

  RewardCard({
    required this.date,
    required this.description,
    required this.points,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final fontSizeProvider = Provider.of<FontSizeProvider>(context);
    final baseFontSize = 18.0;

    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(date),
                SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: fontSizeProvider.getFontSize(baseFontSize),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(points),
              ],
            ),
            Spacer(),
            Image.asset(imageUrl, height: 50), // 이미지 크기와 경로에 맞게 조절하세요
          ],
        ),
      ),
    );
  }
}
