import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'main.dart';

Random random = Random();

class RecycleScreen extends StatefulWidget {
  final Function(int) onTabTapped;
  const RecycleScreen({super.key, required this.onTabTapped});

  @override
  State<RecycleScreen> createState() => _RecycleScreenState();
}

class _RecycleScreenState extends State<RecycleScreen> {
  final ImagePicker picker = ImagePicker();
  XFile? _imageFile;

  Future<void> getImage(ImageSource imageSource, String buttonId) async {
    try {
      final XFile? imageFile = await picker.pickImage(
          source: imageSource, maxHeight: 300, maxWidth: 300);
      if (imageFile != null) {
        setState(() {
          _imageFile = imageFile;
        });
        if (buttonId == "certify") {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    RecyclingScreen1(imageFile, widget.onTabTapped)),
          );
        } else if (buttonId == "check") {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    CheckRecyclingScreen(imageFile, widget.onTabTapped)),
          );
        }
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Let's Recycle!",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF009E73)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text(
              "Check whether you can recycle your trash!",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF009E73)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Flexible(
              child: Column(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        getImage(ImageSource.gallery, "check");
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF009E73),
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.question_mark, size: 100, color: Colors.white),
                          const SizedBox(height: 20),
                          const Text(
                            "Can I Recycle?",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Take Picture and Ask Gemini whether you can recycle your trash!",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        getImage(ImageSource.gallery, "certify");
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF009E73),
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.attach_money, size: 100, color: Colors.white),
                          const SizedBox(height: 20),
                          const Text(
                            "Ready to Earn Points?",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Earn the points by taking picture of recycling bin and your recycle trash to receive the points!",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CheckRecyclingScreen extends StatefulWidget {
  final XFile imageFile;
  final Function(int) onTabTapped;

  CheckRecyclingScreen(this.imageFile, this.onTabTapped);

  @override
  _CheckRecyclingScreenState createState() => _CheckRecyclingScreenState();
}

class _CheckRecyclingScreenState extends State<CheckRecyclingScreen> {
  String result = "Checking...";
  late GenerativeModel model;

  @override
  void initState() {
    super.initState();
    initializeModel();
    checkRecyclability();
  }

  void initializeModel() {
    final apiKey = 'Your_API_KEY'; // Replace with your actual API key
    model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
  }

  Future<void> checkRecyclability() async {
    try {
      final imageBytes = await widget.imageFile.readAsBytes();
      final prompt = TextPart("What is this item, and is this item recyclable?");
      final imagePart = DataPart('image/jpg', imageBytes);

      final response = await model.generateContent([
        Content.multi([prompt, imagePart])
      ]);

      setState(() {
        result = response.text ?? "Error checking recyclability.";
      });
    } catch (e) {
      setState(() {
        result = "Error checking recyclability: $e";
      });
    }

    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResponsiveNavBarPage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checking...'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.green),
            SizedBox(height: 20),
            Text(result,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF009E73))),
          ],
        ),
      ),
    );
  }
}

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
      final userDoc =
      await FirebaseFirestore.instance.collection('users').doc(userId).get();
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
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ResponsiveNavBarPage(),
            ),
          );
        });
      } else {
        checkRecyclability();
      }
    } else {
      print("No user is currently logged in.");
    }
  }

  Future<void> checkRecyclability() async {
    try {
      final apiKey = 'Your_API_KEY'; // Replace with your actual API key
      final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);

      final imageBytes = await widget.imageFile.readAsBytes();
      final prompt1 = TextPart("Is this item recyclable?");
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
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => TakingOutScreen(widget.onTabTapped, trashWeight!),
            ),
          );
        } else {
          setState(() {
            result = "Error estimating weight. Please try again.";
          });
          Future.delayed(Duration(seconds: 5), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ResponsiveNavBarPage(),
              ),
            );
          });
        }
      } else {
        setState(() {
          result = "This item is not recyclable.";
        });
        Future.delayed(Duration(seconds: 5), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ResponsiveNavBarPage(),
            ),
          );
        });
      }
    } catch (e) {
      setState(() {
        result = "Error verifying recyclability: $e";
      });
      Future.delayed(Duration(seconds: 5), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResponsiveNavBarPage(),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recycling...'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.green),
            SizedBox(height: 20),
            Text(result),
          ],
        ),
      ),
    );
  }
}

class TakingOutScreen extends StatefulWidget {
  final Function(int) onTabTapped;
  final double trashWeight;

  const TakingOutScreen(this.onTabTapped, this.trashWeight, {super.key});

  @override
  State<TakingOutScreen> createState() => _TakingOutScreenState();
}

class _TakingOutScreenState extends State<TakingOutScreen> {
  final ImagePicker picker = ImagePicker();
  XFile? _imageFile;

  Future<void> getImage(ImageSource imageSource) async {
    try {
      final XFile? imageFile = await picker.pickImage(
          source: imageSource, maxHeight: 300, maxWidth: 300);
      if (imageFile != null) {
        setState(() {
          _imageFile = imageFile;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  RecyclingScreen2(imageFile, widget.onTabTapped, widget.trashWeight)),
        );
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    getImage(ImageSource.gallery);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Taking Out Trash'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 300,
              height: 300,
              child: _imageFile != null
                  ? Image.file(File(_imageFile!.path))
                  : Text("Please take a photo of you taking out trash",
                  textAlign: TextAlign.center),
            ),
            SizedBox(height: 20),
            _imageFile == null
                ? ElevatedButton(
              onPressed: () {
                getImage(ImageSource.camera);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: Icon(Icons.camera, color: Colors.white),
            )
                : Container(),
          ],
        ),
      ),
    );
  }
}

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
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ResponsiveNavBarPage(),
            ),
          );
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
      final apiKey = 'Your_API_KEY'; // Replace with your actual API key
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

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      GetPointScreen(recyclePoint, widget.onTabTapped)),
            );
          } else {
            setState(() {
              result = "Daily points limit reached. Try again tomorrow.";
            });
            Future.delayed(Duration(seconds: 5), () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ResponsiveNavBarPage(),
                ),
              );
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
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ResponsiveNavBarPage(),
            ),
          );
        });
      }
    } catch (e) {
      setState(() {
        result = "Error verifying recycling bin: $e";
      });
      Future.delayed(Duration(seconds: 5), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResponsiveNavBarPage(),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recycling...'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.green),
            SizedBox(height: 20),
            Text(result),
          ],
        ),
      ),
    );
  }
}

class GetPointScreen extends StatelessWidget {
  final int recyclePoint;
  final Function(int) onTabTapped;

  const GetPointScreen(this.recyclePoint, this.onTabTapped, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Points Earned!'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wallet, size: 100, color: Colors.green),
            SizedBox(height: 20),
            Text("You've got $recyclePoint points!",
                style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ResponsiveNavBarPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}