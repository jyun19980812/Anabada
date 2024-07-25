import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        backgroundColor: const Color(0xFF009E73),
      ),
      body: Column(
        children: [
          const Expanded(flex: 2, child: _TopPortion()),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    "John Dow",
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FloatingActionButton.extended(
                        onPressed: () {ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Friend request sent!"),
                            duration: Duration(seconds: 2),
                          ),
                        );},
                        heroTag: 'friend_request',
                        elevation: 0,
                        backgroundColor: Color(0xFF009e73),
                        label: const Text("Friend Request", style: TextStyle(color: Color(0xFFffffff))),
                        icon: const Icon(Icons.person_add_alt_1, color: Color(0xFFffffff)),
                      ),
                      const SizedBox(width: 16.0),
                      FloatingActionButton.extended(
                        onPressed: () {showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("Send a Message"),
                            content: TextField(
                              decoration: InputDecoration(hintText: "Enter your message here"),
                            ),
                            actions: [
                              TextButton(
                                child: Text("Send"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        );},
                        heroTag: 'message',
                        elevation: 0,
                        backgroundColor: Color(0xFF0072b2),
                        label: const Text("Message", style: TextStyle(color: Color(0xFFffffff)),),
                        icon: const Icon(Icons.message_rounded, color: Color(0xFFffffff),),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const _ProfileInfoRow()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileInfoRow extends StatelessWidget {
  const _ProfileInfoRow({Key? key}) : super(key: key);

  final List<ProfileInfoItem> _items = const [
    ProfileInfoItem("Friends", 200),
    ProfileInfoItem("Recycled (lbs)", 50),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      constraints: const BoxConstraints(maxWidth: 400),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _items
            .map((item) => Expanded(
            child: Row(
              children: [
                if (_items.indexOf(item) != 0) const VerticalDivider(),
                Expanded(child: _singleItem(context, item)),
              ],
            )))
            .toList(),
      ),
    );
  }

  Widget _singleItem(BuildContext context, ProfileInfoItem item) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          item.value.toString(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      Text(
        item.title,
        style: Theme.of(context).textTheme.bodySmall,
      )
    ],
  );
}

class ProfileInfoItem {
  final String title;
  final int value;
  const ProfileInfoItem(this.title, this.value);
}

class _TopPortion extends StatefulWidget {
  const _TopPortion({Key? key}) : super(key: key);

  @override
  State<_TopPortion> createState() => _TopPortionState();
}

class _TopPortionState extends State<_TopPortion> {
  ImageProvider<Object>? _image = const AssetImage('assets/default.jpg'); // Default image path

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        print("Selected image path: ${image.path}");  // 로그에 경로 출력
        setState(() {
          _image = FileImage(File(image.path));  // 이미지 업데이트
        });
      }
    } catch (e) {
      print("Image pick error: $e");  // 에러 로깅
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 50),
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Color(0xFF00FFB9), Color(0xFF009E73)]),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              )),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: _pickImage,  // Add tap functionality
            child: SizedBox(
              width: 150,
              height: 150,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: _image!,  // Use user-selected image
                  ),
                ),
                child: const Icon(Icons.person, size: 100, color: Colors.white), // Default icon
              ),
            ),
          ),
        )
      ],
    );
  }
}