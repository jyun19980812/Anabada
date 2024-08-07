import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'settings/font_size_provider.dart';

class HomeScreen extends StatelessWidget {
  final Function(int) onTabTapped;
  const HomeScreen({super.key, required this.onTabTapped});

  @override
  Widget build(BuildContext context) {
    final fontSizeProvider = Provider.of<FontSizeProvider>(context);
    const double baseFontSize = 20.0;
    final double cardHeight = MediaQuery.of(context).size.height * 0.55;
    final double cardWidth = MediaQuery.of(context).size.width - 32;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildCard(
                context: context,
                icon: Icons.recycling,
                title: 'Points Available!',
                subtitle: 'Take a photo, recycle, and earn up to 100 points today!',
                actionText: 'Recycle!',
                onTap: () => onTabTapped(2),
                fontSizeProvider: fontSizeProvider,
                cardHeight: cardHeight,
                cardWidth: cardWidth,
                baseFontSize: baseFontSize,
              ),
              const SizedBox(height: 16),
              _buildCard(
                context: context,
                icon: Icons.card_giftcard,
                title: 'Want Reward?',
                subtitle: 'Spend your points for gift cards!',
                actionText: 'Reward!',
                onTap: () => onTabTapped(1),
                fontSizeProvider: fontSizeProvider,
                cardHeight: cardHeight,
                cardWidth: cardWidth,
                baseFontSize: baseFontSize,
              ),
              const SizedBox(height: 16),
              _buildCard(
                context: context,
                icon: Icons.point_of_sale,
                title: 'How Are You Doing?',
                subtitle: 'See where you are at with your points!',
                actionText: 'Check!',
                onTap: () => onTabTapped(3),
                fontSizeProvider: fontSizeProvider,
                cardHeight: cardHeight,
                cardWidth: cardWidth,
                baseFontSize: baseFontSize,
              ),
              const SizedBox(height: 16),
              _buildCard(
                context: context,
                icon: Icons.info,
                title: 'Curious About Recycle?',
                subtitle: 'Learn what and how to recycle!',
                actionText: 'Learn!',
                onTap: () => onTabTapped(4),
                fontSizeProvider: fontSizeProvider,
                cardHeight: cardHeight,
                cardWidth: cardWidth,
                baseFontSize: baseFontSize,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required String actionText,
    required VoidCallback onTap,
    required FontSizeProvider fontSizeProvider,
    required double cardHeight,
    required double cardWidth,
    required double baseFontSize,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: const Color(0xFF009E73),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container(
          height: cardHeight,
          width: cardWidth,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(icon, size: 50, color: Colors.white),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: fontSizeProvider.getFontSize(baseFontSize + 4.0),
                    color: Colors.white,
                    fontFamily: 'Ubuntu',
                  ),
                  maxLines: 1,
                ),
                const SizedBox(height: 10),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: fontSizeProvider.getFontSize(baseFontSize),
                    color: Colors.white,
                    fontFamily: 'Ubuntu',
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 10),
                Text(
                  actionText,
                  style: TextStyle(
                    fontSize: fontSizeProvider.getFontSize(baseFontSize),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Ubuntu',
                  ),
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
