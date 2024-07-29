import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';

class ProfileImageProvider with ChangeNotifier {
  XFile? _imageFile;

  XFile? get imageFile => _imageFile;

  void setImageFile(XFile? imageFile) {
    _imageFile = imageFile;
    notifyListeners();
  }
}
