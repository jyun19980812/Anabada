import 'dart:io';
import 'package:anabada/home.dart';
import 'package:anabada/points.dart';
import 'package:flutter/foundation.dart'; // kIsWeb을 사용하기 위해 필요
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:math';
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
  Future<void> getImage(ImageSource imageSource) async {
    try {
      final XFile? imageFile = await picker.pickImage(
          source: imageSource, maxHeight: 300, maxWidth: 300);
      if (imageFile != null) {
        setState(() {
          _imageFile = imageFile;
        });
        // 이미지를 선택한 후 다음 화면으로 이동
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RecyclingScreen1(imageFile, widget.onTabTapped)),
        );
      }
    } catch (e) {
      print("디버깅용 이미지 호출 에러 : $e");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Row(
        children: [
          Expanded(
            child: Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 150,
                    height: 150,
                    child: _buildPhotoArea(),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      getImage(ImageSource.camera);
                    },
                    child: const Icon(Icons.recycling, color: Color(0xFF009E73)),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      getImage(ImageSource.camera);
                    },
                    child: const Text("Check Recyclable waste"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildPhotoArea() {
    if (_imageFile != null) {
      return Center(
        child: kIsWeb
            ? Image.network(_imageFile!.path) // 웹에서는 Image.network 사용
            : Image.file(File(_imageFile!.path)), // 모바일에서는 Image.file 사용
      );
    } else {
      return const Center(
        child: Text(
          "Certifing Recyclable waste",
          style: TextStyle(color: Colors.black,
              backgroundColor: Colors.white,
              fontSize: 16),
        ),
      );
    }
  }
}
class RecyclingScreen1 extends StatelessWidget {
  final XFile imageFile;
  final Function(int) onTabTapped;
  RecyclingScreen1(this.imageFile, this.onTabTapped);
  @override
  Widget build(BuildContext context) {
    // 5초 후에 getPointScreen으로 이동
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TakingOutScreen(onTabTapped)),
      );
    });
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // 뒤로가기
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(color: Color(0xFF009E73)), // 리사이클링 표시 (회전 애니메이션)
            SizedBox(height: 30), // 위 아래 간격 조정하기
            Text('Now Recycling...')
          ],
        ),
      ),
    );
  }
}
class TakingOutScreen extends StatefulWidget {
  final Function(int) onTabTapped;
  const TakingOutScreen(this.onTabTapped, {super.key});
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
        // 이미지를 선택한 후 다음 화면으로 이동
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RecyclingScreen2(imageFile, widget.onTabTapped)),
        );
      }
    } catch (e) {
      print("디버깅용 이미지 호출 에러 : $e");
    }
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 300,
                height: 300,
                child: _buildPhotoArea2(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      getImage(ImageSource.camera);
                    },
                    child: const Icon(Icons.camera, color: Color(0xFF009E73)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildPhotoArea2() {
    if (_imageFile != null) {
      return Center(
        child: kIsWeb
            ? Image.network(_imageFile!.path) // 웹에서는 Image.network 사용
            : Image.file(File(_imageFile!.path)), // 모바일에서는 Image.file 사용
      );
    } else {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Please take a photo you taking out trash",
                style:TextStyle(
                  color: Colors.black,
                  backgroundColor: Colors.white,
                  fontSize: 16,
                )
            ),
          ],
        ),
      );
    }
  }
}
class RecyclingScreen2 extends StatelessWidget {
  final XFile imageFile;
  final Function(int) onTabTapped;
  RecyclingScreen2(this.imageFile, this.onTabTapped);
  @override
  Widget build(BuildContext context) {
    // recyclePoint 만들기
    int recyclePoint = random.nextInt(101);
    // 10초 후에 getPointScreen으로 이동
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => getPointScreen(recyclePoint, onTabTapped)),
      );
    });
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          backgroundColor: Colors.white
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(color: Color(0xFF009E73)), // 리사이클링 표시 (회전 애니메이션)
            SizedBox(height: 30), // 위 아래 간격 조정하기
            Text('Now Recycling...')
          ],
        ),
      ),
    );
  }
}
class getPointScreen extends StatelessWidget {
  final int recyclePoint;
  final Function(int) onTabTapped;
  const getPointScreen(this.recyclePoint, this.onTabTapped, {super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wallet, color: Color(0xFF009E73), size: 200),
            const SizedBox(height: 30),
            Text("You've got $recyclePoint points!"),
            const SizedBox(height: 30),
            ElevatedButton(
              child: Icon(Icons.check, color: Color(0xFF009E73)),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen(onTabTapped: onTabTapped)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}