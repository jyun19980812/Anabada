import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../settings/setting_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../settings/edit.dart';
import '../settings/image_provider.dart';
import '../settings/font_size_provider.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingOptions = Provider.of<SettingOptions>(context, listen: false); // image처럼 provider로 사용
    final fontSizeProvider = Provider.of<FontSizeProvider>(context, listen: false);
    const double baseFontSize = 20.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Account',
          style: TextStyle(fontSize: fontSizeProvider.getFontSize(baseFontSize + 5.0)),
        ),
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
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: fontSizeProvider.getFontSize(baseFontSize),
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: ' ($fullname)',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontSize: fontSizeProvider.getFontSize(baseFontSize * 0.75),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(width: 16.0),
                            ],
                          ),
                          const SizedBox(height: 16.0),
                          _ProfileInfoRow(totalPoints: totalPoints.toString(), totalRecycled: recycledValue.toStringAsFixed(2))
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
  final String totalPoints;
  final String totalRecycled;

  const _ProfileInfoRow({Key? key, required this.totalPoints, required this.totalRecycled}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fontSizeProvider = Provider.of<FontSizeProvider>(context, listen: false);
    const double baseFontSize = 16.0;

    return Container(
      height: 80,
      constraints: const BoxConstraints(maxWidth: 400),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _singleItem(context, 'Points', totalPoints),
          const VerticalDivider(),
          _singleItem(context, 'Recycled', totalRecycled),
        ],
      ),
    );
  }

  Widget _singleItem(BuildContext context, String title, String value) {
    final fontSizeProvider = Provider.of<FontSizeProvider>(context, listen: false);
    const double baseFontSize = 16.0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: fontSizeProvider.getFontSize(20.0),
            ),
          ),
        ),
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontSize: fontSizeProvider.getFontSize(baseFontSize),
          ),
        ),
      ],
    );
  }
}

class _TopPortion extends StatefulWidget {
  const _TopPortion();

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
                MaterialPageRoute(builder: (context) => EditProfileScreen()),
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
