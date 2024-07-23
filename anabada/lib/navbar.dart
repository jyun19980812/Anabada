import 'package:flutter/material.dart';
import 'home.dart';
import 'reward.dart';
import 'recycle.dart';
import 'points.dart';
import 'information.dart';
import 'settings.dart';

class ResponsiveNavBarPage extends StatelessWidget {
  final Widget child;
  ResponsiveNavBarPage({Key? key, required this.child}) : super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
        body: child,
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
                    title: Text(item),
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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ResponsiveNavBarPage(child: HomeScreen(onTabTapped: (index) {}))),
        );
        break;
      case 'Reward':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ResponsiveNavBarPage(child: const RewardScreen())),
        );
        break;
      case 'Recycle':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ResponsiveNavBarPage(child: const RecycleScreen())),
        );
        break;
      case 'Points':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ResponsiveNavBarPage(child: const PointsScreen())),
        );
        break;
      case 'Information':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ResponsiveNavBarPage(child: const InformationScreen())),
        );
        break;
      case 'Settings':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ResponsiveNavBarPage(child: const SettingsScreen())),
        );
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
  'Settings',
];

enum Menu { itemOne, itemTwo, itemThree }

class _ProfileIcon extends StatelessWidget {
  const _ProfileIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Menu>(
        icon: const Icon(Icons.person),
        offset: const Offset(0, 40),
        onSelected: (Menu item) {},
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
            ]);
  }
}
