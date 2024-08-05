import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../settings/font_size_provider.dart';
import '../main.dart';
import 'get_point_screen.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:math';

Random random = Random();

class RecyclingScreen2 extends StatefulWidget {
  final XFile imageFile;
  final Function(int) onTabTapped;
  final double trashWeight;

  RecyclingScreen2(this.imageFile, this.onTabTapped, this.trashWeight);

  @override
  _RecyclingScreen2State createState() => _RecyclingScreen2State();
}

class _RecyclingScreen2State extends State<RecyclingScreen2> {
  String result = "Now Recycling...";
  int recyclePoint = random.nextInt(20) + 1; // 1~20 사이의 랜덤 포인트

  @override
  void initState() {
    super.initState();
    checkDailyPoints();
  }

  Future<void> checkDailyPoints() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userId = user.uid;
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      int dailyPoints = userDoc.data()?['daily_points'] ?? 0;
      Timestamp? lastUpdated = userDoc.data()?['last_updated'];

      final now = Timestamp.now();
      final today = DateTime(now.toDate().year, now.toDate().month, now.toDate().day);
      final lastUpdatedDay = lastUpdated != null
          ? DateTime(lastUpdated.toDate().year, lastUpdated.toDate().month,
          lastUpdated.toDate().day)
          : today.subtract(Duration(days: 1)); // If lastUpdated is null, set to previous day

      if (today.isAfter(lastUpdatedDay)) {
        dailyPoints = 0;
      }

      if (dailyPoints >= 100) {
        setState(() {
          result = "Daily points limit reached. Try again tomorrow.";
        });
        Future.delayed(Duration(seconds: 5), () {
          if (mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => RootScreen(initialIndex: 2),
              ),
                  (Route<dynamic> route) => false,
            );
          }
        });
      } else {
        verifyRecyclingBin();
      }
    } else {
      print("No user is currently logged in.");
    }
  }


  Future<void> verifyRecyclingBin() async {
    try {
      final apiKey = 'AIzaSyCmAbRKhYxdJKljPlWK5Sk_hgWMFLSDRYY'; // Replace with your actual API key
      final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);

      final imageBytes = await widget.imageFile.readAsBytes();
      final prompt = TextPart("Is this a recycling trash bin?");
      final imagePart = DataPart('image/jpeg', imageBytes);

      final response = await model.generateContent([
        Content.multi([prompt, imagePart])
      ]);

      final apiResult = response.text ?? "Error verifying recycling bin.";
      if (apiResult.contains("yes") || apiResult.contains("Yes")) {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final userId = user.uid;

          final userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .get();
          int newTotalPoints = userDoc['total_points'] + recyclePoint;
          double newTotalRecycled = userDoc['total_recycled'] + await widget.trashWeight;
          int dailyPoints = userDoc.data()?['daily_points'] ?? 0;
          Timestamp? lastUpdated =
          userDoc.data()?['last_updated'];

          final now = Timestamp.now();
          final today = DateTime(
              now.toDate().year, now.toDate().month, now.toDate().day);
          final lastUpdatedDay = lastUpdated != null
              ? DateTime(lastUpdated.toDate().year, lastUpdated.toDate().month,
              lastUpdated.toDate().day)
              : today.subtract(Duration(days: 1)); // If lastUpdated is null, set to previous day

          if (today.isAfter(lastUpdatedDay)) {
            dailyPoints = 0;
          }

          if (dailyPoints + recyclePoint <= 100) {
            dailyPoints += recyclePoint;

            await FirebaseFirestore.instance
                .collection('users')
                .doc(userId)
                .update({
              'daily_points': dailyPoints,
              'total_points': newTotalPoints,
              'last_updated': now,
              'total_recycled': newTotalRecycled,
            });

            await FirebaseFirestore.instance.collection('point_events').add({
              'user_id': userId,
              'point_timestamp': now,
              'point_earned': true,
              'point_amount': recyclePoint,
            });

            await FirebaseFirestore.instance
                .collection('recycle_events')
                .add({
              'user_id': userId,
              'recycle_timestamp': now,
              'points_awarded': recyclePoint,
              'amount_recycled': widget.trashWeight, // Store the weight
            });

            if (mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        GetPointScreen(recyclePoint, widget.onTabTapped)),
              );
            }
          } else {
            setState(() {
              result = "Daily points limit reached. Try again tomorrow.";
            });
            Future.delayed(Duration(seconds: 5), () {
              if (mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RootScreen(initialIndex: 2),
                  ),
                      (Route<dynamic> route) => false,
                );
              }
            });
          }
        } else {
          print("No user is currently logged in.");
        }
      } else {
        setState(() {
          result = "The image is not recognized as a recycling bin.";
        });
        Future.delayed(Duration(seconds: 5), () {
          if (mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => RootScreen(initialIndex: 2),
              ),
                  (Route<dynamic> route) => false,
            );
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          result = "Error verifying recycling bin: $e";
        });
      }
      Future.delayed(Duration(seconds: 5), () {
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => RootScreen(initialIndex: 2),
            ),
                (Route<dynamic> route) => false,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final fontSizeProvider = Provider.of<FontSizeProvider>(context);
    final double baseFontSize = 20.0;
    return Scaffold(
      appBar: AppBar(
        title: Text('Recycling...', style: TextStyle(fontSize: fontSizeProvider.getFontSize(baseFontSize + 4.0))),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.green),
            SizedBox(height: 20),
            Text(result, style: TextStyle(fontSize: fontSizeProvider.getFontSize(baseFontSize))),
          ],
        ),
      ),
    );
  }
}
