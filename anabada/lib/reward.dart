import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RewardScreen extends StatelessWidget {
  const RewardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Reward(),
    );
  }
}

class Reward extends StatefulWidget {
  const Reward({super.key});

  @override
  _RewardState createState() => _RewardState();
}

class _RewardState extends State<Reward> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int totalPoints = 0;
  List<Map<String, String>> purchasedProducts = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _fetchUserPoints();
  }

  Future<void> _fetchUserPoints() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
      setState(() {
        totalPoints = userDoc['total_points'] ?? 0; // Provide a default value
      });
    }
  }

  Future<void> _showPurchaseConfirmationDialog(BuildContext context, String brand, String value) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Purchase Confirmation'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to purchase a $value $brand gift card?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () async {
                Navigator.of(context).pop();
                await _redeemGiftCard(_scaffoldKey.currentContext!, brand, value);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _redeemGiftCard(BuildContext context, String brand, String value) async {
    User? user = _auth.currentUser;
    if (user != null) {
      int cardValue = int.parse(value.replaceAll('\$', ''));
      int pointSpent = cardValue * 1000;
      String cardId = _getCardId(brand, value);

      if (totalPoints >= pointSpent) {
        try {
          await _firestore.runTransaction((transaction) async {
            DocumentReference userRef = _firestore.collection('users').doc(user.uid);
            DocumentSnapshot userSnapshot = await transaction.get(userRef);

            if (userSnapshot.exists) {
              int newTotalPoints = userSnapshot['total_points'] - pointSpent;
              transaction.update(userRef, {
                'total_points': newTotalPoints,
              });

              transaction.set(_firestore.collection('gift_card_events').doc(), {
                'user_id': user.uid,
                'card_timestamp': Timestamp.now(),
                'point_spent': pointSpent,
                'card_id': cardId,
                'cancelled': false,
                'card_type': brand,
              });

              transaction.set(_firestore.collection('point_events').doc(), {
                'user_id': user.uid,
                'point_timestamp': Timestamp.now(),
                'point_amount': pointSpent,
                'point_earned': false,
              });

              setState(() {
                totalPoints = newTotalPoints;
                purchasedProducts.add({'brand': brand, 'value': value});
              });

              _showConfirmationMessage(context, brand, value);
            }
          });
        } catch (e) {
          _showErrorMessage(context, 'Failed to complete the purchase: $e');
        }
      } else {
        _showErrorMessage(context, 'Not enough points to redeem this gift card.');
      }
    }
  }

  String _getCardId(String brand, String value) {
    Map<String, String> cardIdMap = {
      'Starbucks\$10': '1',
      'Starbucks\$25': '2',
      'Starbucks\$50': '3',
      'Starbucks\$100': '4',
      'Amazon\$10': '5',
      'Amazon\$25': '6',
      'Amazon\$50': '7',
      'Amazon\$100': '8',
      'Walmart\$10': '9',
      'Walmart\$25': '10',
      'Walmart\$50': '11',
      'Walmart\$100': '12',
      'Target\$10': '13',
      'Target\$25': '14',
      'Target\$50': '15',
      'Target\$100': '16',
    };
    return cardIdMap['$brand$value'] ?? '';
  }

  void _showErrorMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showConfirmationMessage(BuildContext context, String brand, String value) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Purchase Complete'),
          content: Text('You have successfully redeemed a $value $brand gift card.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  'Benefits',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff009e73),
                  ),
                ),
                const SizedBox(width: 80),
                const Text(
                  'Points : ',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff009e73),
                  ),
                ),
                Text(
                  '$totalPoints P',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff009e73),
                  ),
                ),
              ],
            ),
          ),
          if (purchasedProducts.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8),
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
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(8),
              child: GridView.count(
                crossAxisCount: 2,
                padding: const EdgeInsets.all(8),
                children: [
                  GiftCard(
                    image: './assets/starbucksgiftcard.png',
                    value: '\$10',
                    onRedeem: () => _showPurchaseConfirmationDialog(context, 'Starbucks', '\$10'),
                  ),
                  GiftCard(
                    image: './assets/starbucksgiftcard.png',
                    value: '\$25',
                    onRedeem: () => _showPurchaseConfirmationDialog(context, 'Starbucks', '\$25'),
                  ),
                  GiftCard(
                    image: './assets/starbucksgiftcard.png',
                    value: '\$50',
                    onRedeem: () => _showPurchaseConfirmationDialog(context, 'Starbucks', '\$50'),
                  ),
                  GiftCard(
                    image: './assets/starbucksgiftcard.png',
                    value: '\$100',
                    onRedeem: () => _showPurchaseConfirmationDialog(context, 'Starbucks', '\$100'),
                  ),
                  GiftCard(
                    image: './assets/amazongiftcard.png',
                    value: '\$10',
                    onRedeem: () => _showPurchaseConfirmationDialog(context, 'Amazon', '\$10'),
                  ),
                  GiftCard(
                    image: './assets/amazongiftcard.png',
                    value: '\$25',
                    onRedeem: () => _showPurchaseConfirmationDialog(context, 'Amazon', '\$25'),
                  ),
                  GiftCard(
                    image: './assets/amazongiftcard.png',
                    value: '\$50',
                    onRedeem: () => _showPurchaseConfirmationDialog(context, 'Amazon', '\$50'),
                  ),
                  GiftCard(
                    image: './assets/amazongiftcard.png',
                    value: '\$100',
                    onRedeem: () => _showPurchaseConfirmationDialog(context, 'Amazon', '\$100'),
                  ),
                  GiftCard(
                    image: './assets/walmartsgiftcard.png',
                    value: '\$10',
                    onRedeem: () => _showPurchaseConfirmationDialog(context, 'Walmart', '\$10'),
                  ),
                  GiftCard(
                    image: './assets/walmartsgiftcard.png',
                    value: '\$25',
                    onRedeem: () => _showPurchaseConfirmationDialog(context, 'Walmart', '\$25'),
                  ),
                  GiftCard(
                    image: './assets/walmartsgiftcard.png',
                    value: '\$50',
                    onRedeem: () => _showPurchaseConfirmationDialog(context, 'Walmart', '\$50'),
                  ),
                  GiftCard(
                    image: './assets/walmartsgiftcard.png',
                    value: '\$100',
                    onRedeem: () => _showPurchaseConfirmationDialog(context, 'Walmart', '\$100'),
                  ),
                  GiftCard(
                    image: './assets/targetgiftcard.png',
                    value: '\$10',
                    onRedeem: () => _showPurchaseConfirmationDialog(context, 'Target', '\$10'),
                  ),
                  GiftCard(
                    image: './assets/targetgiftcard.png',
                    value: '\$25',
                    onRedeem: () => _showPurchaseConfirmationDialog(context, 'Target', '\$25'),
                  ),
                  GiftCard(
                    image: './assets/targetgiftcard.png',
                    value: '\$50',
                    onRedeem: () => _showPurchaseConfirmationDialog(context, 'Target', '\$50'),
                  ),
                  GiftCard(
                    image: './assets/targetgiftcard.png',
                    value: '\$100',
                    onRedeem: () => _showPurchaseConfirmationDialog(context, 'Target', '\$100'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GiftCard extends StatelessWidget {
  final String image;
  final String value;
  final VoidCallback onRedeem;

  const GiftCard({super.key, required this.image, required this.value, required this.onRedeem});

  @override
  Widget build(BuildContext context) {
    String brand = '';

    if (image.contains('starbucks')) {
      brand = 'Starbucks';
    } else if (image.contains('amazon')) {
      brand = 'Amazon';
    } else if (image.contains('walmart')) {
      brand = 'Walmart';
    } else if (image.contains('target')) {
      brand = 'Target';
    }
    return Container(
      child: Card(
        color: const Color.fromARGB(255, 228, 227, 227),
        elevation: 4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: onRedeem,
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
            const SizedBox(height: 8),
            LayoutBuilder(
              builder: (context, constraints) {
                double fontSize005 = constraints.maxWidth * 0.05;
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
                    const SizedBox(width: 5),
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
      ),
    );
  }
}
