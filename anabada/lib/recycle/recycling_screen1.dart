import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../main.dart';
import 'taking_out_screen.dart';
import '../settings/font_size_provider.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class RecyclingScreen1 extends StatefulWidget {
  final XFile imageFile;
  final Function(int) onTabTapped;

  RecyclingScreen1(this.imageFile, this.onTabTapped);

  @override
  _RecyclingScreen1State createState() => _RecyclingScreen1State();
}

class _RecyclingScreen1State extends State<RecyclingScreen1> {
  String result = "Recycling...";
  double? trashWeight; // Variable to store the estimated weight

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
        print(dailyPoints);
        checkRecyclability();
      }
    } else {
      print("No user is currently logged in.");
    }
  }

  Future<void> checkRecyclability() async {
    try {
      final apiKey = 'AIzaSyCmAbRKhYxdJKljPlWK5Sk_hgWMFLSDRYY'; // Replace with your actual API key
      final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);

      final imageBytes = await widget.imageFile.readAsBytes();
      final prompt1 = TextPart("Is this item recyclable? Ignore any background objects such as hands or ground.");
      final prompt2 = TextPart(
          "Estimate the weight of the trash in lbs and respond with the number only.");
      final imagePart = DataPart('image/jpeg', imageBytes);

      final response1 = await model.generateContent([
        Content.multi([prompt1, imagePart])
      ]);

      final apiResult1 = response1.text ?? "Error verifying recyclability.";
      if (apiResult1.contains("yes") || apiResult1.contains("Yes")) {
        final response2 = await model.generateContent([
          Content.multi([prompt2, imagePart])
        ]);
        final apiResult2 = response2.text ?? "Error estimating weight.";
        trashWeight = double.tryParse(apiResult2); // Save the estimated weight
        if (trashWeight != null) {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    TakingOutScreen(widget.onTabTapped, trashWeight!),
              ),
            );
          }
        } else {
          setState(() {
            result = "Error estimating weight. Please try again.";
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
        setState(() {
          result = "This item is not recyclable.";
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
          result = "Error verifying recyclability: $e";
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text('Recycling...', style: TextStyle(fontSize: fontSizeProvider.getFontSize(baseFontSize + 4.0)),),
        backgroundColor: isDarkMode ? Colors.grey[800] : Colors.white,
        foregroundColor: Colors.white,
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
