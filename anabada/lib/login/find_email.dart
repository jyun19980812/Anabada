import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login.dart';
import 'find_password.dart';

class FindIdScreen extends StatefulWidget {
  const FindIdScreen({super.key});

  @override
  _FindIdScreenState createState() => _FindIdScreenState();
}

class _FindIdScreenState extends State<FindIdScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  bool isEmailFound = false;
  String message = '';

  Future<void> _onFindEmail() async {
    if (fullNameController.text.isNotEmpty && phoneController.text.isNotEmpty) {
      try {
        // Firestore에서 사용자 정보 조회
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('fullname', isEqualTo: fullNameController.text)
            .where('phone', isEqualTo: phoneController.text)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          var userDoc = querySnapshot.docs.first;
          var userEmail = userDoc['email'];

          setState(() {
            isEmailFound = true;
            message = 'Your Registered Email Is: $userEmail';
          });
        } else {
          setState(() {
            message = 'No user found with provided full name and phone number.';
          });
        }
      } catch (e) {
        setState(() {
          message = 'Failed to find email. Please try again.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Find My Email',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 48),
              TextField(
                controller: fullNameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Full Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Phone #',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _onFindEmail,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const AutoSizeText(
                    'Find Email',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    maxLines: 1
                ),
              ),
              const SizedBox(height: 16),
              if (isEmailFound || message.isNotEmpty)
                AutoSizeText(
                  message,
                  style: const TextStyle(color: Colors.white),
                  maxLines: 1,
                ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
                      );
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );
                    },
                    child: const Text(
                      'Sign In!',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      backgroundColor: const Color(0xFF4CAF50),
    );
  }
}
