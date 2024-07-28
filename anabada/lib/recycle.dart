import 'dart:io'; // 파일 관련 기능 사용을 위해 필요
import 'package:anabada/main.dart'; // 메인 앱 파일을 가져오기 위해 필요
import 'package:flutter/foundation.dart'; // kIsWeb을 사용하기 위해 필요
import 'package:flutter/material.dart'; // Flutter의 기본 위젯 및 테마 가져오기
import 'package:flutter/widgets.dart'; // Flutter의 기본 위젯 가져오기
import 'package:image_picker/image_picker.dart'; // 이미지 선택 기능을 사용하기 위해 필요
import 'dart:math'; // 난수 생성기를 사용하기 위해 필요

Random random = Random(); // 난수 생성기 인스턴스 생성

class RecycleScreen extends StatefulWidget { // 상태를 가지는 위젯 생성
  final Function(int) onTabTapped; // 탭 변경을 위한 콜백 함수
  const RecycleScreen({super.key, required this.onTabTapped}); // 생성자
  @override
  State<RecycleScreen> createState() => _RecycleScreenState(); // 상태 클래스 생성
}

class _RecycleScreenState extends State<RecycleScreen> { // 상태 클래스 정의
  final ImagePicker picker = ImagePicker(); // 이미지 선택기 인스턴스 생성
  XFile? _imageFile; // 선택된 이미지 파일을 저장할 변수

  Future<void> getImage(ImageSource imageSource, String buttonId) async { // 이미지 선택 함수
    try {
      final XFile? imageFile = await picker.pickImage( // 이미지 선택
          source: imageSource, maxHeight: 300, maxWidth: 300); // 이미지 크기 제한
      if (imageFile != null) { // 이미지가 선택되었으면
        setState(() { // 상태 업데이트
          _imageFile = imageFile; // 이미지 파일 저장
        });
        // 이미지를 선택한 후 조건에 따라 다른 화면으로 이동
        if (buttonId == "certify") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RecyclingScreen1(imageFile, widget.onTabTapped)), // RecyclingScreen1으로 이동
          );
        } else if (buttonId == "check") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CheckRecyclingScreen(imageFile, widget.onTabTapped)), // CheckRecyclingScreen으로 이동
          );
        }
      }
    } catch (e) {
      print("디버깅용 이미지 호출 에러 : $e"); // 오류 발생 시 출력
    }
  }

  @override
  Widget build(BuildContext context) { // 위젯 빌드 함수
    return Scaffold( // Scaffold 위젯 사용
      appBar: AppBar(), // 상단 앱바
      body: Row( // 가로 방향 레이아웃
        mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 아이템 간격을 균등하게 설정
        children: [
          Expanded( // 자식 위젯을 화면의 절반 차지하게 설정
            child: Container( // 컨테이너 위젯
              margin: EdgeInsets.only(right: 10), // 오른쪽 간격 추가
              child: Center( // 가운데 정렬
                child: ElevatedButton( // 버튼 위젯
                  onPressed: () {
                    getImage(ImageSource.camera, "certify"); // 카메라를 이용해 이미지 선택
                  },
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, double.infinity), // 버튼이 화면의 반을 차지하도록 설정
                      backgroundColor: const Color(0xFF009E73), // 버튼 배경색
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)) // 둥근 모서리 설정
                      )
                  ),
                  child: Column( // 세로 방향 레이아웃
                    mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬
                    children: [
                      Icon(Icons.recycling, color: Colors.white, size: 200), // 아이콘 추가
                      SizedBox(height: 20), // 간격 추가
                      const Text("Certifying Recyclable Waste", // 텍스트 추가
                          style: TextStyle(
                              color: Colors.white, // 텍스트 색상
                              fontSize: 24
                          )
                      ),
                      Text('')
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded( // 자식 위젯을 화면의 절반 차지하게 설정
            child: Container( // 컨테이너 위젯
              margin: EdgeInsets.only(left: 10), // 왼쪽 간격 추가
              child: Center( // 가운데 정렬
                child: ElevatedButton( // 버튼 위젯
                  onPressed: () {
                    getImage(ImageSource.camera, "check"); // 카메라를 이용해 이미지 선택
                  },
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, double.infinity), // 버튼이 화면의 반을 차지하도록 설정
                      backgroundColor: const Color(0xFF009E73), // 버튼 배경색
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)) // 둥근 모서리 설정
                      )
                  ),
                  child: Column( // 세로 방향 레이아웃
                    mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬
                    children: [
                      Icon(Icons.check, color: Colors.white, size: 200), // 아이콘 추가
                      SizedBox(height: 20), // 간격 추가
                      const Text("Check Recyclable Waste", // 텍스트 추가
                          style: TextStyle(
                              color: Colors.white, // 텍스트 색상
                              fontSize: 24
                          )
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoArea() { // 사진 영역 빌드 함수
    if (_imageFile != null) { // 이미지 파일이 있으면
      return Center(
        child: kIsWeb
            ? Image.network(_imageFile!.path) // 웹에서는 Image.network 사용
            : Image.file(File(_imageFile!.path)), // 모바일에서는 Image.file 사용
      );
    } else {
      return const Center(
        child: Text(
          "Certifing Recyclable waste", // 텍스트 추가
          style: TextStyle(color: Colors.black,
              backgroundColor: Colors.white,
              fontSize: 16),
        ),
      );
    }
  }
}

class CheckRecyclingScreen extends StatelessWidget { // CheckRecyclingScreen 클래스 정의
  final XFile imageFile; // 이미지 파일 변수
  final Function(int) onTabTapped; // 탭 변경 콜백 함수
  CheckRecyclingScreen(this.imageFile, this.onTabTapped); // 생성자
  @override
  Widget build(BuildContext context) { // 위젯 빌드 함수
    // 5초 후에 RecycleScreen으로 이동
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ResponsiveNavBarPage()), // ResponsiveNavBarPage로 이동
      );
    });
    return Scaffold( // Scaffold 위젯 사용
      extendBodyBehindAppBar: true, // 앱바 뒤로 바디 확장
      appBar: AppBar( // 상단 앱바
        backgroundColor: Colors.white, // 배경색 설정
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black,), // 뒤로가기 아이콘
          onPressed: () {
            Navigator.pop(context); // 뒤로가기
          },
        ),
      ),
      body: Center( // 가운데 정렬
        child: Column( // 세로 방향 레이아웃
          mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬
          children: const [
            CircularProgressIndicator(color: Color(0xFF009E73)), // 리사이클링 표시 (회전 애니메이션)
            SizedBox(height: 30), // 위 아래 간격 조정하기
            Text('Checking Recyclable Waste...') // 텍스트 추가
          ],
        ),
      ),
    );
  }
}


class RecyclingScreen1 extends StatelessWidget { // RecyclingScreen1 클래스 정의
  final XFile imageFile; // 이미지 파일 변수
  final Function(int) onTabTapped; // 탭 변경 콜백 함수
  RecyclingScreen1(this.imageFile, this.onTabTapped); // 생성자
  @override
  Widget build(BuildContext context) { // 위젯 빌드 함수
    // 5초 후에 getPointScreen으로 이동
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TakingOutScreen(onTabTapped)), // TakingOutScreen으로 이동
      );
    });
    return Scaffold( // Scaffold 위젯 사용
      extendBodyBehindAppBar: true, // 앱바 뒤로 바디 확장
      appBar: AppBar( // 상단 앱바
        backgroundColor: Colors.white, // 배경색 설정
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black), // 뒤로가기 아이콘
          onPressed: () {
            Navigator.pop(context); // 뒤로가기
          },
        ),
      ),
      body: Center( // 가운데 정렬
        child: Column( // 세로 방향 레이아웃
          mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬
          children: const [
            CircularProgressIndicator(color: Color(0xFF009E73)), // 리사이클링 표시 (회전 애니메이션)
            SizedBox(height: 30), // 위 아래 간격 조정하기
            Text('Now Recycling...') // 텍스트 추가
          ],
        ),
      ),
    );
  }
}

class TakingOutScreen extends StatefulWidget { // TakingOutScreen 클래스 정의
  final Function(int) onTabTapped; // 탭 변경 콜백 함수
  const TakingOutScreen(this.onTabTapped, {super.key}); // 생성자
  @override
  State<TakingOutScreen> createState() => _TakingOutScreenState(); // 상태 클래스 생성
}

class _TakingOutScreenState extends State<TakingOutScreen> { // 상태 클래스 정의
  final ImagePicker picker = ImagePicker(); // 이미지 선택기 인스턴스 생성
  XFile? _imageFile; // 선택된 이미지 파일을 저장할 변수

  Future<void> getImage(ImageSource imageSource) async { // 이미지 선택 함수
    try {
      final XFile? imageFile = await picker.pickImage( // 이미지 선택
          source: imageSource, maxHeight: 300, maxWidth: 300); // 이미지 크기 제한
      if (imageFile != null) { // 이미지가 선택되었으면
        setState(() { // 상태 업데이트
          _imageFile = imageFile; // 이미지 파일 저장
        });
        // 이미지를 선택한 후 다음 화면으로 이동
        Navigator.push( // 화면 전환
          context,
          MaterialPageRoute(builder: (context) => RecyclingScreen2(imageFile, widget.onTabTapped)), // RecyclingScreen2로 이동
        );
      }
    } catch (e) {
      print("디버깅용 이미지 호출 에러 : $e"); // 오류 발생 시 출력
    }
  }

  @override
  Widget build(BuildContext context) { // 위젯 빌드 함수
    return SafeArea( // 안전 영역 확보
      child: Container( // 컨테이너 위젯
        color: Colors.white, // 배경색 설정
        child: Center( // 가운데 정렬
          child: Column( // 세로 방향 레이아웃
            mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬
            children: [
              SizedBox(
                width: 300,
                height: 300,
                child: _buildPhotoArea2(), // 사진 영역 빌드 함수 호출
              ),
              Row( // 가로 방향 레이아웃
                mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬
                children: [
                  ElevatedButton(
                    onPressed: () {
                      getImage(ImageSource.camera); // 카메라를 이용해 이미지 선택
                    },
                    child: const Icon(Icons.camera, color: Color(0xFF009E73)), // 아이콘 추가
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoArea2() { // 사진 영역 빌드 함수
    if (_imageFile != null) { // 이미지 파일이 있으면
      return Center(
        child: kIsWeb
            ? Image.network(_imageFile!.path) // 웹에서는 Image.network 사용
            : Image.file(File(_imageFile!.path)), // 모바일에서는 Image.file 사용
      );
    } else {
      return const Center(
        child: Column( // 세로 방향 레이아웃
          mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬
          children: [
            Text("Please take a photo you taking out trash", // 텍스트 추가
                style: TextStyle(
                  color: Colors.black, // 텍스트 색상
                  backgroundColor: Colors.white, // 배경색
                  fontSize: 16, // 글자 크기
                )
            ),
          ],
        ),
      );
    }
  }
}

class RecyclingScreen2 extends StatelessWidget { // RecyclingScreen2 클래스 정의
  final XFile imageFile; // 이미지 파일 변수
  final Function(int) onTabTapped; // 탭 변경 콜백 함수
  RecyclingScreen2(this.imageFile, this.onTabTapped); // 생성자

  @override
  Widget build(BuildContext context) { // 위젯 빌드 함수
    // recyclePoint 만들기
    int recyclePoint = random.nextInt(101); // 난수 생성 (0부터 100 사이)

    // 10초 후에 getPointScreen으로 이동
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => getPointScreen(recyclePoint, onTabTapped)), // getPointScreen으로 이동
      );
    });

    return Scaffold( // Scaffold 위젯 사용
      extendBodyBehindAppBar: true, // 앱바 뒤로 바디 확장
      appBar: AppBar(
          backgroundColor: Colors.white // 배경색 설정
      ),
      body: Center( // 가운데 정렬
        child: Column( // 세로 방향 레이아웃
          mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬
          children: const [
            CircularProgressIndicator(color: Color(0xFF009E73)), // 리사이클링 표시 (회전 애니메이션)
            SizedBox(height: 30), // 위 아래 간격 조정하기
            Text('Now Recycling...') // 텍스트 추가
          ],
        ),
      ),
    );
  }
}

class getPointScreen extends StatelessWidget { // getPointScreen 클래스 정의
  final int recyclePoint; // 리사이클 포인트 변수
  final Function(int) onTabTapped; // 탭 변경 콜백 함수
  const getPointScreen(this.recyclePoint, this.onTabTapped, {super.key}); // 생성자

  @override
  Widget build(BuildContext context) { // 위젯 빌드 함수
    return Scaffold( // Scaffold 위젯 사용
      appBar: AppBar(
          backgroundColor: Colors.white // 배경색 설정
      ),
      body: Center( // 가운데 정렬
        child: Column( // 세로 방향 레이아웃
          mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬
          children: [
            const Icon(Icons.wallet, color: Color(0xFF009E73), size: 200), // 아이콘 추가
            const SizedBox(height: 30), // 간격 추가
            Text("You've got $recyclePoint points!"), // 포인트 텍스트 추가
            const SizedBox(height: 30), // 간격 추가
            ElevatedButton(
              child: Icon(Icons.check, color: Color(0xFF009E73)), // 아이콘 추가
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const ResponsiveNavBarPage()), // ResponsiveNavBarPage로 이동
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CheckRecyclableWasteScreen extends StatelessWidget { // RecyclingScreen2 클래스 정의
  final XFile imageFile; // 이미지 파일 변수
  final Function(int) onTabTapped; // 탭 변경 콜백 함수
  CheckRecyclableWasteScreen(this.imageFile, this.onTabTapped); // 생성자

  @override
  Widget build(BuildContext context) { // 위젯 빌드 함수

    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ResponsiveNavBarPage()), // getPointScreen으로 이동
      );
    });

    return Scaffold( // Scaffold 위젯 사용
      extendBodyBehindAppBar: true, // 앱바 뒤로 바디 확장
      appBar: AppBar(
          backgroundColor: Colors.white // 배경색 설정
      ),
      body: Center( // 가운데 정렬
        child: Column( // 세로 방향 레이아웃
          mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬
          children: const [
            CircularProgressIndicator(color: Color(0xFF009E73)), // 리사이클링 표시 (회전 애니메이션)
            SizedBox(height: 30), // 위 아래 간격 조정하기
            Text('Now Recycling...') // 텍스트 추가
          ],
        ),
      ),
    );
  }
}