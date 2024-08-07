import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'settings/font_size_provider.dart';

class InformationScreen extends StatelessWidget {
  const InformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const InformationContent(),
    );
  }
}

class InformationContent extends StatelessWidget {
  const InformationContent({super.key});

  final List<Map<String, dynamic>> faqItems = const [
    {
      'category': 'Paper/Cardboard',
      'description': 'Newspapers, mails, boxes, and books can be recycled. You just need to flatten the box or remove the hard cover of the book.',
      'icon': Icons.inventory_2,
    },
    {
      'category': 'Plastics',
      'description': 'Plastics labeled with numbers 1 and 2 are recyclable. Check local guidelines for numbers 3-7 plastics. Clean bottles, caps, and food containers before recycling.',
      'icon': Icons.recycling,
    },
    {
      'category': 'Aluminum',
      'description': 'Beverage cans can be recycled. Remove any food residue before recycling. Some aluminum items may need special programs.',
      'icon': Icons.local_drink,
    },
    {
      'category': 'Batteries',
      'description': 'Most batteries can be recycled but often need special handling. Check local guidelines for household, automotive, and rechargeable batteries.',
      'icon': Icons.battery_full,
    },
    {
      'category': 'Electronics',
      'description': 'E-waste includes computers, TVs, and cell phones. Many retailers and local programs offer recycling services.',
      'icon': Icons.devices,
    },
    {
      'category': 'Food',
      'description': 'Food waste can be composted. Check local programs for composting guidelines.',
      'icon': Icons.restaurant,
    },
    {
      'category': 'Lawn Materials',
      'description': 'Recycle leaves, grass clippings, and branches through composting or yard waste collection programs.',
      'icon': Icons.grass,
    },
    {
      'category': 'Used Oil',
      'description': 'Used motor oil can be recycled at specific collection points or automotive centers.',
      'icon': Icons.oil_barrel,
    },
    {
      'category': 'Household Hazardous Waste',
      'description': 'Includes items like paints, cleaners, and pesticides. Requires special handling and should be taken to hazardous waste collection events.',
      'icon': Icons.warning,
    },
    {
      'category': 'Tires',
      'description': 'Tires are recyclable but usually require specific drop-off locations.',
      'icon': Icons.directions_car,
    },
    {
      'category': 'Metal',
      'description': 'Scrap metal is recyclable; check local guidelines for large metal items.',
      'icon': Icons.hardware,
    },
    {
      'category': 'Miscellaneous',
      'description': 'Bulky items and those with special recycling needs should be checked against local guidelines.',
      'icon': Icons.category,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final fontSizeProvider = Provider.of<FontSizeProvider>(context);
    const double baseFontSize = 20.0;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recycle Information',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: const Color(0xff009e73),
                fontSize: fontSizeProvider.getFontSize(baseFontSize + 10.0),
                fontFamily: 'Ubuntu',
              ),
            ),
            const SizedBox(height: 16),
            ...faqItems.map((item) => FAQItem(
              category: item['category']!,
              categoryFontSize: fontSizeProvider.getFontSize(baseFontSize + 5.0),
              description: item['description']!,
              descriptionFontSize: fontSizeProvider.getFontSize(baseFontSize - 5.0),
              icon: item['icon']!,
            )),
          ],
        ),
      ),
    );
  }
}

class FAQItem extends StatelessWidget {
  final String category;
  final String description;
  final IconData icon;
  final double categoryFontSize;
  final double descriptionFontSize;

  const FAQItem({
    super.key,
    required this.category,
    required this.description,
    required this.icon,
    required this.categoryFontSize,
    required this.descriptionFontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                category,
                style: TextStyle(
                  fontSize: categoryFontSize,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Ubuntu',
                ),
              ),
            ),
            const SizedBox(width: 8),
            Icon(icon),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          description,
          style: TextStyle(
              fontSize: descriptionFontSize,
              fontFamily: 'Ubuntu',
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

void main() => runApp(
  const MaterialApp(
    home: InformationScreen(),
  ),
);
