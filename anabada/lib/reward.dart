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

var point = '5010P';

class Reward extends StatefulWidget {
  @override
  _RewardState createState() => _RewardState();
}

class _RewardState extends State<Reward> {
  List<Map<String, String>> purchasedProducts = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Benefits',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff009e73),
                  ),
                ),
                SizedBox(
                  width: 80,
                ),
                Text(
                  'Points : ',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff009e73),
                  ),
                ),
                Text(
                  point,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff009e73),
                  ),
                ),
              ],
            ), // Row
          ), // Padding
          // 구매한 제품 보여주는 박스
          if (purchasedProducts.isNotEmpty)
            Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                children: purchasedProducts.map((product) {
                  return Card(
                    child: ListTile(
                      title: Text('${product['brand']} gift card'),
                      subtitle: Text('Value: ${product['value']}'),
                    ),
                  );
                }).toList(),
              ),
            ),
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
                  GiftCard(
                      image: './assets/starbucksgiftcard.png', value: '\$10'),
                  GiftCard(
                      image: './assets/starbucksgiftcard.png', value: '\$25'),
                  GiftCard(
                      image: './assets/starbucksgiftcard.png', value: '\$50'),
                  GiftCard(
                      image: './assets/starbucksgiftcard.png', value: '\$100'),
                  GiftCard(image: './assets/amazongiftcard.png', value: '\$10'),
                  GiftCard(image: './assets/amazongiftcard.png', value: '\$25'),
                  GiftCard(image: './assets/amazongiftcard.png', value: '\$50'),
                  GiftCard(
                      image: './assets/amazongiftcard.png', value: '\$100'),
                  GiftCard(
                      image: './assets/walmartsgiftcard.png', value: '\$10'),
                  GiftCard(
                      image: './assets/walmartsgiftcard.png', value: '\$25'),
                  GiftCard(
                      image: './assets/walmartsgiftcard.png', value: '\$50'),
                  GiftCard(
                      image: './assets/walmartsgiftcard.png', value: '\$100'),
                  GiftCard(image: './assets/targetgiftcard.png', value: '\$10'),
                  GiftCard(image: './assets/targetgiftcard.png', value: '\$25'),
                  GiftCard(image: './assets/targetgiftcard.png', value: '\$50'),
                  GiftCard(
                      image: './assets/targetgiftcard.png', value: '\$100'),
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
    String brand = '';

    if (image.contains('starbucks')) {
      brand = 'Starbucks';
    } else if (image.contains('amazon')) {
      brand = 'Amazon';
    } else if (image.contains('walmart')) {
      brand = 'Walmart';
    }
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
                borderRadius: BorderRadius.circular(15),
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
          LayoutBuilder(
            builder: (context, constraints) {
              double fontSize005 =
                  constraints.maxWidth * 0.05; // 부모 컨테이너의 너비의 10%
              double fontSize01 = constraints.maxWidth * 0.1;
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    brand,
                    style: TextStyle(
                      fontSize: fontSize005,
                    ),
                  ),
                  Text(
                    " gift card ",
                    style: TextStyle(
                      fontSize: fontSize005,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: fontSize01,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              );
            },
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
    String brand = '';

    if (image.contains('starbucks')) {
      brand = 'Starbucks';
    } else if (image.contains('amazon')) {
      brand = 'Amazon';
    } else if (image.contains('walmart')) {
      brand = 'Walmart';
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Detail'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(25),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  image,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                brand,
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
              Text(
                "gift card  ",
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ]),
            // 추가로 상세 정보 등을 여기에 추가할 수 있습니다.
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                child: ElevatedButton(
                  onPressed: () {
                    _showPurchaseDialog(context);
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

  void _showPurchaseDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Purchase Confirmation'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Current Points: $point'),
              SizedBox(height: 10),
              Text('Points after Purchase: 3000P'),
              SizedBox(height: 20),
              Text('Do you really want to purchase this gift card?'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 모달 닫기
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // 구매 로직 추가
                Navigator.of(context).pop(); // 모달 닫기
                _showConfirmationMessage(context);
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }
}

void _showConfirmationMessage(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Purchase Complete'),
        content: Text('We will send you the gift card shortly.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // 모달 닫기
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}
