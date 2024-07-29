import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';

import '/settings/font_size_provider.dart';
import '/settings/image_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final Map<String, TextEditingController> _controllers = {
    'username': TextEditingController(),
    'phone': TextEditingController(),
    'location': TextEditingController(),
    'email': TextEditingController(),
  };

  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  Future<void> _pickImage() async {
    try {
      final XFile? selectedImage = await _picker.pickImage(source: ImageSource.gallery);
      if (selectedImage != null) {
        setState(() {
          _imageFile = selectedImage;
        });
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  @override
  void dispose() {
    _controllers.forEach((key, controller) {
      controller.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fontSizeProvider = Provider.of<FontSizeProvider>(context);
    const double baseFontSize = 16.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Edit'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: InkWell(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    child: ClipOval(
                      child: _imageFile != null
                          ? (kIsWeb
                          ? Image.network(
                        _imageFile!.path,
                        fit: BoxFit.cover,
                        width: 100,
                        height: 100,
                      )
                          : Image.file(
                        File(_imageFile!.path),
                        fit: BoxFit.cover,
                        width: 100,
                        height: 100,
                      ))
                          : const Icon(Icons.camera_alt_outlined, size: 50),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ..._buildTextFields(fontSizeProvider, baseFontSize),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      // cancel action
                    },
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // confirm action
                      Provider.of<ProfileImageProvider>(context, listen:false).setImageFile(_imageFile);
                      Navigator.pop(context);
                    },
                    child: const Text('Confirm'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildTextFields(FontSizeProvider fontSizeProvider, double baseFontSize) {
    double labelWidth = 80.0; // label 고정해서 간격 조정

    return _controllers.keys.map((key) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          children: [
            SizedBox(
              width: labelWidth,
              child: Text(
                key,
                style: TextStyle(
                  fontSize: fontSizeProvider.getFontSize(baseFontSize),
                ),
                textAlign: TextAlign.center, // 중앙정렬해서 글자 밀려도 깔끔하게
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: _controllers[key],
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}
