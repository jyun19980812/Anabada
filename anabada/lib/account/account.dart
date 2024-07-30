import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '/settings/image_provider.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

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
                          const SnackBar(
                            content: Text("Friend request sent!"),
                            duration: Duration(seconds: 2),
                          ),
                        );},
                        heroTag: 'friend_request',
                        elevation: 0,
                        backgroundColor: const Color(0xFF009e73),
                        label: const Text("Friend Request", style: TextStyle(color: Color(0xFFffffff))),
                        icon: const Icon(Icons.person_add_alt_1, color: Color(0xFFffffff)),
                      ),
                      const SizedBox(width: 16.0),
                      FloatingActionButton.extended(
                        onPressed: () {showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Send a Message"),
                            content: const TextField(
                              decoration: InputDecoration(hintText: "Enter your message here"),
                            ),
                            actions: [
                              TextButton(
                                child: const Text("Send"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        );},
                        heroTag: 'message',
                        elevation: 0,
                        backgroundColor: const Color(0xFF0072b2),
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
  const _ProfileInfoRow();

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
  const _TopPortion();

  @override
  State<_TopPortion> createState() => _TopPortionState();
}

class _TopPortionState extends State<_TopPortion> {
  final ImageProvider<Object> _image = const AssetImage('assets/default.jpg'); // Default image path

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        print("Selected image path: ${image.path}");  // 로그에 경로 출력
        setState(() {
          // _image = FileImage(File(image.path));  // 이미지 업데이트
          Provider.of<ProfileImageProvider>(context, listen: false).setImageFile(image); // Provider로 이미지 업뎃
        });
      }
    } catch (e) {
      print("Image pick error: $e");  // 에러 로깅
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileImageProvider = Provider.of<ProfileImageProvider>(context);
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
            onTap: _pickImage,
            child: SizedBox(
              width: 150,
              height: 150,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: profileImageProvider.imageFile != null
                        ? (kIsWeb
                          ? NetworkImage(profileImageProvider.imageFile!.path) // 웹에서 테스트 시 오류 방지
                          : FileImage(File(profileImageProvider.imageFile!.path)) as ImageProvider)
                        : const AssetImage('assets/default.jpg'),
                  ),
                ),
                child: profileImageProvider.imageFile == null
                      ? const Icon(Icons.person, size: 100, color: Colors.white)  // 사진이 없으면 아이콘
                      : null, // 있으면 아무것도 안 띄움
              ),
            ),
          ),
        )
      ],
    );
  }
}