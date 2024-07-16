
import 'package:flutter/material.dart';

import '../screens/home_screen.dart';
import '../screens/scan_qr.dart';
import '../screens/setting_screen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}
class _HomePage extends State<HomePage>{
  int _selectedIndex = 0;

  static  final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const SettingScreen(),
    const ScanQr(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items:  const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home,),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings,),
            label: 'Setting',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner, ),
            label: 'Scan QR',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green[800],
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,

      ),
    );
  }
}