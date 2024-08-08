import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../settings/font_size_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class QNAScreen extends StatefulWidget {
  const QNAScreen({super.key});

  @override
  _QNAScreenState createState() => _QNAScreenState();
}

class _QNAScreenState extends State<QNAScreen> {
  User? currentUser;
  int totalPoints = 0;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
  }

  void _sendEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'anabada0804@gmail.com',
      queryParameters: {
        'subject': 'Question',
        'body': 'Please\twrite\tyour\tmessage\there.'
      },
    );

    try {
      await launch(emailLaunchUri.toString());
    } catch (error) {
      print(error);
    }
  }

  void _changeProductEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'anabada0804@gmail.com',
      queryParameters: {
        'subject': 'Product\tchange',
        'body': 'Purchase\ttime:\t\nPurchased\tProduct:\t\nProduct\tfor\tchange:\n',
      },
    );

    try {
      await launch(emailLaunchUri.toString());
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final fontSizeProvider = Provider.of<FontSizeProvider>(context);
    final baseFontSize = 20.0;

    return Scaffold(
      appBar: AppBar(
        title: Text('QNA'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Text(
              'QNA',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Color(0xff009e73),
                fontSize: fontSizeProvider.getFontSize(baseFontSize + 10.0),
                fontFamily: 'Ubuntu',
              ),
            ),
            SizedBox(height: 20),

            ExpansionTile(
              title: Text('Q1. How long will it take to deliver the gift card?',
                style: TextStyle(
                  color: Color(0xff009e73),
                  fontSize: fontSizeProvider.getFontSize(baseFontSize + 0),
                  fontFamily: 'Ubuntu',),
              ),
              children: <Widget>[
                ListTile(
                  title: Text('Since the management team will send you the code directly, it will take about 2-3 days.',
                    style: TextStyle(
                      fontSize: fontSizeProvider.getFontSize(baseFontSize + 0),
                      fontFamily: 'Ubuntu',
                    ),
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text('Q2. I bought the wrong product that I didn\'t want.',
                style: TextStyle(
                  color: Color(0xff009e73),
                  fontSize: fontSizeProvider.getFontSize(baseFontSize + 0),
                  fontFamily: 'Ubuntu',
                ),
              ),
              children: <Widget>[
                ListTile(
                  title: Text('Please write the purchase time, purchased product, and product for change and send it to anabada0804@gmail.com.' ,
                    style: TextStyle(
                      fontSize: fontSizeProvider.getFontSize(baseFontSize + 0),
                      fontFamily: 'Ubuntu',
                    ),
                  ),
                ),
                OutlinedButton(
                  onPressed: () {
                    _changeProductEmail();
                  },
                  child: Text('Send e-mail'),
                ),
              ],
            ),
            ExpansionTile(
              title: Text('Q3. What is the point measurement policy?' ,
                style: TextStyle(
                  color: Color(0xff009e73),
                  fontSize: fontSizeProvider.getFontSize(baseFontSize + 0),
                  fontFamily: 'Ubuntu',
                ),
              ),
              children: <Widget>[
                ListTile(
                  title: Text('Points are awarded randomly between 1 and 20 points.' ,
                    style: TextStyle(
                      fontSize: fontSizeProvider.getFontSize(baseFontSize + 0),
                      fontFamily: 'Ubuntu',
                    ),
                  ),
                ),
              ],
            ),
            OutlinedButton(
              onPressed: () {
                _sendEmail();
                print('OutlinedButton pressed');
              },
              child: Text('Contact us',
                  style: TextStyle(
                    fontSize: fontSizeProvider.getFontSize(baseFontSize - 5.0),
                    fontFamily: 'Ubuntu',
                  ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}