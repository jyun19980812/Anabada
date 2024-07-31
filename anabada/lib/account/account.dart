import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/settings/setting_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/settings/edit.dart';
import '/settings/image_provider.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settingOptions = Provider.of<SettingOptions>(context, listen: false); // image처럼 provider로 사용

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        backgroundColor: const Color(0xFF009E73),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("User data not found"));
          }
          var userData = snapshot.data!.data() as Map<String, dynamic>;
          var username = userData['username'] ?? 'No Name';
          var fullname = userData['fullname'] ?? '';
          var totalPoints = userData['total_points'] ?? 0;
          var totalRecycled = (userData['total_recycled'] ?? 0).toDouble();

          return FutureBuilder<bool>(
            future: settingOptions.isKgEnabled(),
            builder: (context, kgSnapshot) {
              if (kgSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              bool isGramEnabled = kgSnapshot.data ?? false;
              double recycledValue = isGramEnabled ? totalRecycled * 453.592 : totalRecycled;

              return Column(
                children: [
                  const Expanded(flex: 2, child: _TopPortion()),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          RichText(
                            text: TextSpan(
                              text: username,
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                              children: <TextSpan>[
                                TextSpan(
                                  text: ' ($fullname)',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FloatingActionButton.extended(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Friend request sent!"),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                },
                                heroTag: 'friend_request',
                                elevation: 0,
                                backgroundColor: Color(0xFF009e73),
                                label: const Text("Friend Request", style: TextStyle(color: Color(0xFFffffff))),
                                icon: const Icon(Icons.person_add_alt_1, color: Color(0xFFffffff)),
                              ),
                              const SizedBox(width: 16.0),
                              FloatingActionButton.extended(
                                onPressed: () {
                                  showDialog(
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
                                  );
                                },
                                heroTag: 'message',
                                elevation: 0,
                                backgroundColor: Color(0xFF0072b2),
                                label: const Text("Message", style: TextStyle(color: Color(0xFFffffff)),),
                                icon: const Icon(Icons.message_rounded, color: Color(0xFFffffff),),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16.0),
                          _ProfileInfoRow(totalPoints: totalPoints, totalRecycled: recycledValue)
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _ProfileInfoRow extends StatelessWidget {
  final int totalPoints;
  final double totalRecycled;

  const _ProfileInfoRow({Key? key, required this.totalPoints, required this.totalRecycled}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      constraints: const BoxConstraints(maxWidth: 400),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _singleItem(context, 'Points', totalPoints.toString()),
          const VerticalDivider(),
          _singleItem(context, 'Recycled', totalRecycled.toStringAsFixed(2)),
        ],
      ),
    );
  }

  Widget _singleItem(BuildContext context, String title, String value) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      Text(
        title,
        style: Theme.of(context).textTheme.bodySmall,
      )
    ],
  );
}

class _TopPortion extends StatefulWidget {
  const _TopPortion({Key? key}) : super(key: key);

  @override
  State<_TopPortion> createState() => _TopPortionState();
}

class _TopPortionState extends State<_TopPortion> {
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
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EditProfileScreen()),
              );
            },
            child: SizedBox(
              width: 150,
              height: 150,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: profileImageProvider.imageUrl != null
                        ? NetworkImage(profileImageProvider.imageUrl!)
                        : const AssetImage('assets/default.jpg'),
                  ),
                ),
                child: profileImageProvider.imageUrl == null
                    ? Icon(Icons.person, size: 100, color: Colors.white)
                    : null,
              ),
            ),
          ),
        )
      ],
    );
  }
}
