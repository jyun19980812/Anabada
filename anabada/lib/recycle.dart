import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'settings/font_size_provider.dart';
import 'recycle/check_recycling_screen.dart';
import 'recycle/recycling_screen1.dart';

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
        setState(() {
          _imageFile = null;
        }); // 이미지 사용 후 메모리 해제
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: orientation == Orientation.portrait
                ? _buildPortraitLayout()
                : _buildLandscapeLayout(),
          );
        },
      ),
    );
  }

  Widget _buildPortraitLayout() {
    final fontSizeProvider = Provider.of<FontSizeProvider>(context);
    final double baseFontSize = 20.0;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Let's Recycle!",
          style: TextStyle(
              fontSize: fontSizeProvider.getFontSize(baseFontSize + 4.0),
              fontWeight: FontWeight.w700,
              color: Color(0xFF009E73),
              fontFamily: 'Ubuntu',
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Text(
          "Check whether you can recycle your trash! \n\n Please take the photo of your trash with clear background if possible for better accuracy.",
          style: TextStyle(
              fontSize: fontSizeProvider.getFontSize(baseFontSize - 4.0),
              fontWeight: FontWeight.w500,
              fontFamily: 'Ubuntu',
              color: Color(0xFF009E73),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Expanded(
          child: _buildButton("Can I Recycle?", "Take Picture and Ask Gemini whether you can recycle your trash!", Icons.question_mark, "check"),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: _buildButton("Ready to Earn Points?", "Earn the points by taking picture of recycling bin and your recycle trash to receive the points!", Icons.attach_money, "certify"),
        ),
      ],
    );
  }

  Widget _buildLandscapeLayout() {
    final fontSizeProvider = Provider.of<FontSizeProvider>(context);
    final double baseFontSize = 20.0;
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            "Let's Recycle!",
            style: TextStyle(
                fontSize: fontSizeProvider.getFontSize(baseFontSize + 4.0),
                fontWeight: FontWeight.w700,
                fontFamily: 'Ubuntu',
                color: Color(0xFF009E73),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            "Check whether you can recycle your trash!\n\n Please take the photo of your trash with clear background \n if possible for better accuracy.",
            style: TextStyle(
                fontSize: fontSizeProvider.getFontSize(baseFontSize),
                fontWeight: FontWeight.w700,
                fontFamily: 'Ubuntu',
                color: Color(0xFF0072b2),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          _buildButton("Can I Recycle?", "Take Picture and Ask Gemini whether you can recycle your trash!", Icons.question_mark, "check"),
          const SizedBox(height: 16),
          _buildButton("Ready to Earn Points?", "Earn the points by taking picture of recycling bin and your recycle trash to receive the points!", Icons.attach_money, "certify"),
        ],
      ),
    );
  }

  Widget _buildButton(String title, String subtitle, IconData icon, String buttonId) {
    final fontSizeProvider = Provider.of<FontSizeProvider>(context);
    final double baseFontSize = 20.0;
    return ElevatedButton(
      onPressed: () {
        getImage(ImageSource.camera, buttonId);
      },
      style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF009E73),
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(30),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 100, color: Colors.white),
          const SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSizeProvider.getFontSize(baseFontSize),
              fontFamily: 'Ubuntu',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSizeProvider.getFontSize(baseFontSize - 4.0),
              fontFamily: 'Ubuntu',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

