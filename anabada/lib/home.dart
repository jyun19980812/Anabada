import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'settings/font_size_provider.dart';

class HomeScreen extends StatelessWidget {
  final Function(int) onTabTapped;
  const HomeScreen({super.key, required this.onTabTapped});

  @override
  Widget build(BuildContext context) {
    final fontSizeProvider = Provider.of<FontSizeProvider>(context);
    const double baseFontSize = 20.0; // 폰트 S M L 용도 -> 기본 크기 바꾸고 싶으면 여기서 조정
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
                        Text(
                          'Points Available!',
                          style: TextStyle(
                              fontSize: fontSizeProvider.getFontSize(baseFontSize + 4.0),
                              color: Colors.white),
                          maxLines: 1,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Take a photo, recycle, and earn up to 100 points today!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: fontSizeProvider.getFontSize(baseFontSize),
                              color: Colors.white),
                          maxLines: 2,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Recycle!',
                          style: TextStyle(
                            fontSize: fontSizeProvider.getFontSize(baseFontSize),
                            fontWeight: FontWeight.bold,
                            color: Colors.white,),
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
                        Text(
                          'Want Reward?',
                          style: TextStyle(
                              fontSize: fontSizeProvider.getFontSize(baseFontSize + 4.0),
                              color: Colors.white),
                          maxLines: 1,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Spend your points for gift cards!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: fontSizeProvider.getFontSize(baseFontSize),
                              color: Colors.white),
                          maxLines: 2,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Reward!',
                          style: TextStyle(
                              fontSize: fontSizeProvider.getFontSize(baseFontSize),
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
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
                        Text(
                          'How Are You Doing?',
                          style: TextStyle(
                              fontSize: fontSizeProvider.getFontSize(baseFontSize),
                              color: Colors.white),
                          maxLines: 1,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'See where you are at with your points!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: fontSizeProvider.getFontSize(baseFontSize),
                              color: Colors.white),
                          maxLines: 2,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Check!',
                          style: TextStyle(
                              fontSize: fontSizeProvider.getFontSize(baseFontSize),
                              fontWeight: FontWeight.bold, color: Colors.white),
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
                        Text(
                          'Curious About Recycle?',
                          style: TextStyle(
                              fontSize: fontSizeProvider.getFontSize(baseFontSize),
                              color: Colors.white),
                          maxLines: 1,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Learn what and how to recycle!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: fontSizeProvider.getFontSize(baseFontSize),
                              color: Colors.white),
                          maxLines: 2,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Learn!',
                          style: TextStyle(
                              fontSize: fontSizeProvider.getFontSize(baseFontSize),
                              fontWeight: FontWeight.bold, color: Colors.white),
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