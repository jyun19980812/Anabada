import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

import './font_size_provider.dart';
import './image_provider.dart';
import './settings.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final Map<String, TextEditingController> _controllers = {
    'username': TextEditingController(),
    'phone': TextEditingController(),
  };

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _currentPasswordController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      final data = userDoc.data();
      if (data != null) {
        _controllers['username']?.text = data['username'] ?? '';
        _controllers['phone']?.text = data['phone'] ?? '';
        final profileImageUrl = data['profileImageUrl'] as String?;
        if (profileImageUrl != null) {
          setState(() {
            _imageFile = XFile(profileImageUrl);
          });
        }
      }
    }
  }

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
    _passwordController.dispose();
    _currentPasswordController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("No user logged in");
      return;
    }

    try {
      await _reauthenticate(user);
      await _updateUserInfo(user);
      if (_imageFile != null) {
        await _uploadProfileImage(user);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SettingsScreen()),
      );
    } catch (e) {
      print("Error updating profile: $e");
    }
  }

  Future<void> _reauthenticate(User user) async {
    final currentPassword = _currentPasswordController.text;

    try {
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);
    } catch (e) {
      print("Error reauthenticating: $e");
      throw e;
    }
  }

  Future<void> _updateUserInfo(User user) async {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);

    final updatedData = _controllers.map((key, controller) => MapEntry(key, controller.text));
    await userDoc.update(updatedData);
    print("User info updated successfully");
  }

  Future<void> _uploadProfileImage(User user) async {
    final storage = FirebaseStorage.instanceFor(
      bucket: 'gs://anabada-74beb.appspot.com',  // Replace with your actual bucket name
    );
    final storageRef = storage.ref().child('profile_images/${user.uid}');
    final uploadTask = storageRef.putFile(File(_imageFile!.path));

    final snapshot = await uploadTask.whenComplete(() {});

    final downloadUrl = await snapshot.ref.getDownloadURL();

    final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
    await userDoc.update({'profileImageUrl': downloadUrl});

    setState(() {
      _imageFile = XFile(downloadUrl);
    });

    // 업데이트된 URL을 ProfileImageProvider에 설정
    Provider.of<ProfileImageProvider>(context, listen: false).setImageFile(_imageFile);
  }

  @override
  Widget build(BuildContext context) {
    final fontSizeProvider = Provider.of<FontSizeProvider>(context);
    const double baseFontSize = 16.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile Edit',
          style: TextStyle(fontSize: fontSizeProvider.getFontSize(baseFontSize)),
        ),
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
              _buildPasswordField(fontSizeProvider, baseFontSize),
              const SizedBox(height: 20),
              _buildCurrentPasswordField(fontSizeProvider, baseFontSize),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(fontSize: fontSizeProvider.getFontSize(baseFontSize)),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await _updateProfile();
                    },
                    child: Text(
                      'Confirm',
                      style: TextStyle(fontSize: fontSizeProvider.getFontSize(baseFontSize)),
                    ),
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
    double labelWidth = 80.0;

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
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: _controllers[key],
                decoration: InputDecoration(
                  labelText: 'Enter $key',
                  labelStyle: TextStyle(fontSize: fontSizeProvider.getFontSize(baseFontSize)),
                ),
                style: TextStyle(fontSize: fontSizeProvider.getFontSize(baseFontSize)),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildPasswordField(FontSizeProvider fontSizeProvider, double baseFontSize) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          SizedBox(
            width: 80.0,
            child: Text(
              'New Password',
              style: TextStyle(
                fontSize: fontSizeProvider.getFontSize(baseFontSize),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Enter new password',
                labelStyle: TextStyle(fontSize: fontSizeProvider.getFontSize(baseFontSize)),
              ),
              obscureText: true,
              style: TextStyle(fontSize: fontSizeProvider.getFontSize(baseFontSize)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentPasswordField(FontSizeProvider fontSizeProvider, double baseFontSize) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          SizedBox(
            width: 80.0,
            child: Text(
              'Password',
              style: TextStyle(
                fontSize: fontSizeProvider.getFontSize(baseFontSize),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _currentPasswordController,
              decoration: InputDecoration(
                labelText: 'Enter current password',
                labelStyle: TextStyle(fontSize: fontSizeProvider.getFontSize(baseFontSize)),
              ),
              obscureText: true,
              style: TextStyle(fontSize: fontSizeProvider.getFontSize(baseFontSize)),
            ),
          ),
        ],
      ),
    );
  }
}
