import 'package:flutter/material.dart';

class RewardScreen extends StatelessWidget {
  const RewardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Reward(),
    );
  }
}

class Reward extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Benefits',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff009e73),
                  ),
                ),
                Text(
                  'Points : 5000p',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff009e73),
                  ),
                ),
              ],
            ), // Row
          ), // Padding
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10), // 둥근 모서리 설정
              ),
              padding: EdgeInsets.all(8), // 패딩 추가
              child: GridView.count(
                crossAxisCount: 2,
                padding: EdgeInsets.all(8),
                children: [
                  GiftCard(image: './assets/starbucksgiftcard.png', value: '\$10'),
                  GiftCard(image: 'starbucksgiftcard.png', value: '\$25'),
                  GiftCard(image: 'starbucksgiftcard.png', value: '\$50'),
                  GiftCard(image: 'starbucksgiftcard.png', value: '\$100'),
                  GiftCard(image: 'amazongiftcard.png', value: '\$10'),
                  GiftCard(image: 'amazongiftcard.png', value: '\$25'),
                  GiftCard(image: 'amazongiftcard.png', value: '\$50'),
                  GiftCard(image: 'amazongiftcard.png', value: '\$100'),
                  GiftCard(image: 'walmartsgiftcard.png', value: '\$10'),
                  GiftCard(image: 'walmartsgiftcard.png', value: '\$25'),
                  GiftCard(image: 'walmartsgiftcard.png', value: '\$50'),
                  GiftCard(image: 'walmartsgiftcard.png', value: '\$100'),
                ],
              ), // GridView.count
            ), // Container
          ), // Expanded
        ],
      ), // Column
    ); // Scaffold
  }
}

class GiftCard extends StatelessWidget {
  final String image;
  final String value;

  GiftCard({required this.image, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Card(
      color: const Color.fromARGB(255, 228, 227, 227),
      elevation: 4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ProductDetailScreen(image: image, value: value),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  image,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ));
  }
}

class ProductDetailScreen extends StatelessWidget {
  final String image;
  final String value;

  ProductDetailScreen({required this.image, required this.value});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Detail'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              image,
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            // 추가로 상세 정보 등을 여기에 추가할 수 있습니다.
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                child: ElevatedButton(
                  onPressed: () {
                    // 구매 버튼을 눌렀을 때의 동작을 여기에 추가합니다.
                  },
                  child: Text('Purchase'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
