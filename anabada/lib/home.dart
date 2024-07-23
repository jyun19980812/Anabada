import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class HomeScreen extends StatelessWidget {
  final Function(int) onTabTapped;
  const HomeScreen({Key? key, required this.onTabTapped}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double cardHeight = MediaQuery.of(context).size.height * 0.5;
    final double cardWidth = MediaQuery.of(context).size.width - 32; // 패딩을 제외한 너비

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                onTabTapped(2); // Recycle 탭으로 이동
              },
              child: Card(
                color: const Color(0xFF009E73),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: SizedBox(
                  height: cardHeight,
                  width: cardWidth, // 가로 길이를 화면 가득 채우기
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Icons.recycling, size: 50, color: Colors.white),
                        const SizedBox(height: 10),
                        const AutoSizeText(
                          'Points Available!',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                          maxLines: 1,
                        ),
                        const SizedBox(height: 10),
                        const AutoSizeText(
                          'Take a photo, recycle, and earn up to 100 points today!',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.white),
                          maxLines: 2,
                        ),
                        const SizedBox(height: 10),
                        const AutoSizeText(
                          'Recycle!',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                onTabTapped(1); // Reward 탭으로 이동
              },
              child: Card(
                color: const Color(0xFF009E73),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: SizedBox(
                  height: cardHeight,
                  width: cardWidth, // 가로 길이를 화면 가득 채우기
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Icons.card_giftcard, size: 50, color: Colors.white),
                        const SizedBox(height: 10),
                        const AutoSizeText(
                          'Want Reward?',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                          maxLines: 1,
                        ),
                        const SizedBox(height: 10),
                        const AutoSizeText(
                          'Spend your points for gift cards!',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.white),
                          maxLines: 2,
                        ),
                        const SizedBox(height: 10),
                        const AutoSizeText(
                          'Reward!',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                onTabTapped(3); // Points 탭으로 이동
              },
              child: Card(
                color: const Color(0xFF009E73),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: SizedBox(
                  height: cardHeight,
                  width: cardWidth, // 가로 길이를 화면 가득 채우기
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Icons.point_of_sale, size: 50, color: Colors.white),
                        const SizedBox(height: 10),
                        const AutoSizeText(
                          'How Are You Doing?',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                          maxLines: 1,
                        ),
                        const SizedBox(height: 10),
                        const AutoSizeText(
                          'See where you are at with your points!',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.white),
                          maxLines: 2,
                        ),
                        const SizedBox(height: 10),
                        const AutoSizeText(
                          'Check!',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                onTabTapped(4); // Information 탭으로 이동
              },
              child: Card(
                color: const Color(0xFF009E73),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: SizedBox(
                  height: cardHeight,
                  width: cardWidth, // 가로 길이를 화면 가득 채우기
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Icons.info, size: 50, color: Colors.white),
                        const SizedBox(height: 10),
                        const AutoSizeText(
                          'Curious About Recycle?',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                          maxLines: 1,
                        ),
                        const SizedBox(height: 10),
                        const AutoSizeText(
                          'Learn what and how to recycle!',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.white),
                          maxLines: 2,
                        ),
                        const SizedBox(height: 10),
                        const AutoSizeText(
                          'Learn!',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}