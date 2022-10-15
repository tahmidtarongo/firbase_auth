import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:internet_popup/internet_popup.dart';
import 'package:mobile_pos/Screens/Home/home_screen.dart';
import 'package:mobile_pos/Screens/Report/reports.dart';
import 'package:mobile_pos/Screens/Settings/settings_screen.dart';

import '../../constant.dart';
import '../Sales/sales_contact.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[HomeScreen(), SalesContact(), Reports(), SettingScreen()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    InternetPopup().initialize(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        elevation: 6.0,
        selectedItemColor: kMainColor,
        // ignore: prefer_const_literals_to_create_immutables
        items: [
          const BottomNavigationBarItem(
            icon: Icon(FeatherIcons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(FeatherIcons.shoppingCart),
            label: 'Sales',
          ),
          const BottomNavigationBarItem(
            icon: Icon(FeatherIcons.fileText),
            label: 'Reports',
          ),
          const BottomNavigationBarItem(icon: Icon(FeatherIcons.settings), label: 'Settings'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
