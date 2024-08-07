import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../settings/font_size_provider.dart';

class RewardHistoryScreen extends StatefulWidget {
  const RewardHistoryScreen({super.key});

  @override
  _RewardHistoryScreenState createState() => _RewardHistoryScreenState();
}

class _RewardHistoryScreenState extends State<RewardHistoryScreen> {
  User? currentUser;
  int totalPoints = 0;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    final fontSizeProvider = Provider.of<FontSizeProvider>(context);
    final baseFontSize = 20.0;

    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Reward History'),
        ),
        body: Center(
          child: Text('Please log in to see your reward history.'),
        ),
      );
    }

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
                fontFamily: 'Ubuntu',
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('gift_card_events')
                    .where('user_id', isEqualTo: currentUser!.uid)
                    .orderBy('card_timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final giftCardEvents = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: giftCardEvents.length,
                    itemBuilder: (context, index) {
                      final giftCardEvent = giftCardEvents[index];
                      final date = (giftCardEvent['card_timestamp'] as Timestamp).toDate();
                      final description = 'Order History\n${giftCardEvent['card_type']}';
                      final pointsSpent = giftCardEvent['point_spent'];
                      final points = 'Spent $pointsSpent points';
                      final imageUrl = 'assets/${giftCardEvent['card_type'].toLowerCase()}giftcard.png';

                      return RewardCard(
                        date: '${date.year}. ${date.month}. ${date.day}.',
                        description: description,
                        points: points,
                        imageUrl: imageUrl,
                      );
                    },
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
                Text(
                  date,
                  style: TextStyle(
                    fontSize: fontSizeProvider.getFontSize(baseFontSize),
                    fontFamily: 'Ubuntu',
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: fontSizeProvider.getFontSize(baseFontSize),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Ubuntu',
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  points,
                  style: TextStyle(
                    fontSize: fontSizeProvider.getFontSize(baseFontSize),
                    fontFamily: 'Ubuntu',
                  ),
                ),
              ],
            ),
            Spacer(),
            Image.asset(imageUrl, height: 100),
          ],
        ),
      ),
    );
  }
}
