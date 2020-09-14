import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tabline/screens/about_screen.dart';
import 'package:tabline/screens/list_screen.dart';
import 'package:tabline/screens/map_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final _layoutPage = [
    ListScreen(),
    MapScreen(),
    AboutScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = 1;
  }

  void _onTapItem(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _layoutPage.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0.0,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey[200],
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        currentIndex: _selectedIndex,
        onTap: _onTapItem,
        items: [
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.list),
            title: Text('BERANDA'),
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.mapMarked),
            title: Text('LOKASI'),
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.infoCircle),
            title: Text('TENTANG'),
            backgroundColor: Colors.black,
          ),
        ],
      ),
    );
  }
}
