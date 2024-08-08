import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../settings/font_size_provider.dart';
import '../main.dart';

class GetPointScreen extends StatelessWidget {
  final int recyclePoint;
  final Function(int) onTabTapped;

  const GetPointScreen(this.recyclePoint, this.onTabTapped, {super.key});

  @override
  Widget build(BuildContext context) {
    final fontSizeProvider = Provider.of<FontSizeProvider>(context);
    final double baseFontSize = 20.0;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text('Points Earned!'),
        backgroundColor: isDarkMode ? Colors.grey[800] : Colors.white,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wallet, size: 100, color: Colors.green),
            SizedBox(height: 20),
            Text("You've got $recyclePoint points!",
                style: TextStyle(fontSize: fontSizeProvider.getFontSize(baseFontSize + 4.0))),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RootScreen(initialIndex: 2)),
                      (Route<dynamic> route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: Text('Back to Home', style: TextStyle(fontSize: fontSizeProvider.getFontSize(baseFontSize))),
            ),
          ],
        ),
      ),
    );
  }
}
