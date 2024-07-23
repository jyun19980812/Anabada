import 'package:flutter/material.dart';

class InformationScreen extends StatelessWidget {
  final List<Map<String, dynamic>> faqItems = [
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
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'FAQ',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Color(0xff009e73),
                  fontSize: 30,
                ),
              ),
              SizedBox(height: 16),
              ...faqItems.map((item) {
                return FAQItem(
                  category: item['category']!,
                  description: item['description']!,
                  icon: item['icon']!,
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}

class FAQItem extends StatelessWidget {
  final String category;
  final String description;
  final IconData icon;

  const FAQItem({
    required this.category,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              category,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 8),
            Icon(icon), // Custom icon
          ],
        ),
        SizedBox(height: 8),
        Text(
          description,
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}

void main() => runApp(MaterialApp(
  home: InformationScreen(),
));
