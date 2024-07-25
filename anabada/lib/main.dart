import 'package:flutter/material.dart';
import 'home.dart';
import 'reward.dart';
import 'recycle.dart';
import 'points.dart';
import 'information.dart';
import 'account/account.dart';
import 'settings.dart';
import 'login/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  // Provider로 폰트 크기 전체 반영하기 위해 MultiProvider 추가
  runApp(MultiProvider(
    providers:[
      ChangeNotifierProvider(create: (_) => FontSizeProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Tab App',
      theme: ThemeData(
        primaryColor: const Color(0xFF009E73),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF009E73),
          foregroundColor: Colors.white,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Color(0xFF009E73),
          unselectedItemColor: Colors.black,
        ),
      ),
      home: const LoginScreen(),
    );
  }
}

class ResponsiveNavBarPage extends StatefulWidget {
  const ResponsiveNavBarPage({Key? key}) : super(key: key);

  @override
  _ResponsiveNavBarPageState createState() => _ResponsiveNavBarPageState();
}

class _ResponsiveNavBarPageState extends State<ResponsiveNavBarPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;

  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages.addAll([
      HomeScreen(onTabTapped: _onTabTapped),
      const RewardScreen(),
      const RecycleScreen(),
      const PointsScreen(),
      InformationScreen(),
    ]);
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isLargeScreen = width > 800;

    return Theme(
      data: ThemeData.light(),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          titleSpacing: 0,
          leading: isLargeScreen
              ? null
              : IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                ),
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo-no-background.png',
                  height: 35,
                ),
                if (isLargeScreen) Expanded(child: _navBarItems(context))
              ],
            ),
          ),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: CircleAvatar(child: _ProfileIcon()),
            )
          ],
        ),
        drawer: isLargeScreen ? null : _drawer(context),
        body: _pages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          selectedItemColor: const Color(0xFF009E73),
          unselectedItemColor: const Color(0xFF009E73),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.card_giftcard),
              label: 'Reward',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.recycling),
              label: 'Recycle',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.point_of_sale),
              label: 'Points',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.info),
              label: 'Information',
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawer(BuildContext context) => Drawer(
        child: ListView(
          children: _menuItems
              .map((item) => ListTile(
                    onTap: () {
                      _navigateTo(context, item);
                      _scaffoldKey.currentState?.openEndDrawer();
                    },
                    title: Text(item, style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF009E73)),),
                  ))
              .toList(),
        ),
      );

  Widget _navBarItems(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _menuItems
            .map(
              (item) => InkWell(
                onTap: () {
                  _navigateTo(context, item);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 24.0, horizontal: 16),
                  child: Text(
                    item,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            )
            .toList(),
      );

  void _navigateTo(BuildContext context, String item) {
    switch (item) {
      case 'Home':
        setState(() {
          _currentIndex = 0;
        });
        break;
      case 'Reward':
        setState(() {
          _currentIndex = 1;
        });
        break;
      case 'Recycle':
        setState(() {
          _currentIndex = 2;
        });
        break;
      case 'Points':
        setState(() {
          _currentIndex = 3;
        });
        break;
      case 'Information':
        setState(() {
          _currentIndex = 4;
        });
        break;
    }
  }
}

final List<String> _menuItems = <String>[
  'Home',
  'Reward',
  'Recycle',
  'Points',
  'Information',
];

enum Menu { itemOne, itemTwo, itemThree }

class _ProfileIcon extends StatelessWidget {
  const _ProfileIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Menu>(
      icon: const Icon(Icons.person),
      offset: const Offset(0, 40),
      onSelected: (Menu item) {
        switch (item) {
          case Menu.itemOne:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AccountScreen()),
            );
            break;
          case Menu.itemTwo:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            );
            break;
          case Menu.itemThree:
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
              (Route<dynamic> route) => false,
            );
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
        const PopupMenuItem<Menu>(
          value: Menu.itemOne,
          child: Text('Account'),
        ),
        const PopupMenuItem<Menu>(
          value: Menu.itemTwo,
          child: Text('Settings'),
        ),
        const PopupMenuItem<Menu>(
          value: Menu.itemThree,
          child: Text('Sign Out'),
        ),
      ],
    );
  }
}