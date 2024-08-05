import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'recycling_screen2.dart';
import '../settings/font_size_provider.dart';

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
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    RecyclingScreen2(imageFile, widget.onTabTapped, widget.trashWeight)),
          );
        }
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final fontSizeProvider = Provider.of<FontSizeProvider>(context);
    final double baseFontSize = 20.0;
    return Scaffold(
      appBar: AppBar(
        title: Text('Taking Out Trash', style: TextStyle(fontSize: fontSizeProvider.getFontSize(baseFontSize + 4.0)),),
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
                  : Text("Please take a photo of recycling bin to prove that you are taking out the trash! \n\n (Tip: Gemini recognizes the recycling bin better if you take the picture of bin with the recycling symbol!)",
                  textAlign: TextAlign.center, style: TextStyle(fontSize: fontSizeProvider.getFontSize(baseFontSize))),
            ),
            SizedBox(height: 20),
            _imageFile == null
                ? ElevatedButton(
              onPressed: () {
                getImage(ImageSource.gallery);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: Icon(Icons.camera, color: Colors.white),
            ): Container(),

          ],
        ),
      ),
    );
  }
}
