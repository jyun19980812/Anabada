import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileImageProvider with ChangeNotifier {
  XFile? _imageFile;
  String? _imageUrl;

  ProfileImageProvider() {
    _loadProfileImage();
  }

  XFile? get imageFile => _imageFile;
  String? get imageUrl => _imageUrl;

  void setImageFile(XFile? imageFile) {
    _imageFile = imageFile;
    notifyListeners();
  }

  Future<void> _loadProfileImage() async {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDoc.exists && userDoc['profileImageUrl'] != null) {
        _imageUrl = userDoc['profileImageUrl'];
        notifyListeners();
      }
    }
  }
}
