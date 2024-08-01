import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../settings/font_size_provider.dart';
import 'login.dart';
import 'find_email.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  bool isPasswordSent = false;
  String message = '';

  Future<void> _onResetPassword() async {
    if (emailController.text.isNotEmpty &&
        fullNameController.text.isNotEmpty &&
        phoneController.text.isNotEmpty) {
      try {
        // Firestore에서 사용자 정보 조회
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: emailController.text)
            .where('fullname', isEqualTo: fullNameController.text)
            .where('phone', isEqualTo: phoneController.text)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          var userDoc = querySnapshot.docs.first;

          // Firebase Auth를 통해 비밀번호 재설정 이메일 전송
          await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text);

          setState(() {
            isPasswordSent = true;
            message = 'A password reset link has been sent to your email!';
          });
        } else {
          setState(() {
            message = 'No user found with provided email, full name, and phone number.';
          });
        }
      } catch (e) {
        setState(() {
          message = 'Failed to send password reset email. Please try again.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final fontSizeProvider = Provider.of<FontSizeProvider>(context);
    final double baseFontSize = 20.0;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AutoSizeText(
                'Find Password',
                style: TextStyle(
                  fontSize: fontSizeProvider.getFontSize(baseFontSize + 12.0),
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                maxLines: 1,
              ),
              const SizedBox(height: 48),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Email',
                  hintStyle: TextStyle(
                    fontSize: fontSizeProvider.getFontSize(baseFontSize),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: fullNameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Full Name',
                  hintStyle: TextStyle(
                    fontSize: fontSizeProvider.getFontSize(baseFontSize),
                  ),
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
                  hintText: 'Phone',
                  hintStyle: TextStyle(
                    fontSize: fontSizeProvider.getFontSize(baseFontSize),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _onResetPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: AutoSizeText(
                  'Find PW',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: fontSizeProvider.getFontSize(18),
                  ),
                  maxLines: 1,
                ),
              ),
              const SizedBox(height: 16),
              if (isPasswordSent || message.isNotEmpty)
                AutoSizeText(
                  message,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: fontSizeProvider.getFontSize(13),
                  ),
                  maxLines: 2,
                ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const FindIdScreen()),
                      );
                    },
                    child: Text(
                      'Forgot ID?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: fontSizeProvider.getFontSize(baseFontSize),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );
                    },
                    child: Text(
                      'Sign In!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: fontSizeProvider.getFontSize(baseFontSize),
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
