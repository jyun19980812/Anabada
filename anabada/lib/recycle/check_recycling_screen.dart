import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../settings/font_size_provider.dart';
import '../main.dart';

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
    final apiKey = 'YOUR-API-KEY'; // Replace with your actual API key
    model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
  }

  Future<void> checkRecyclability() async {
    try {
      final imageBytes = await widget.imageFile.readAsBytes();
      final prompt = TextPart("Is this item recyclable? Answer in Yes or No, and ignore any background objects such as hands or ground.");
      final imagePart = DataPart('image/jpg', imageBytes);

      final response = await model.generateContent([
        Content.multi([prompt, imagePart])
      ]);

      String resultText = response.text ?? "Error checking recyclability.";
      if (mounted) {
        setState(() {
          result = resultText;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          result = "Error checking recyclability: $e";
        });
      }
    }

    Future.delayed(Duration(seconds: 10), () {
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

  @override
  Widget build(BuildContext context) {
    final fontSizeProvider = Provider.of<FontSizeProvider>(context);
    final double baseFontSize = 20.0;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text('Checking...', style: TextStyle(fontSize: fontSizeProvider.getFontSize(baseFontSize + 4.0)),),
        backgroundColor: isDarkMode ? Colors.grey[800] : Colors.white,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.green),
            SizedBox(height: 20),
            Text(result,
                style: TextStyle(
                    fontSize: fontSizeProvider.getFontSize(baseFontSize + 4.0),
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF009E73))),
          ],
        ),
      ),
    );
  }
}
