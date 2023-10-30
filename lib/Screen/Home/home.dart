import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;

import '../Profile/profile.dart';
import 'home_screen.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  bool isNoInternet = false;

  static const List<Widget> _widgetOptions = <Widget>[HomeScreen(), HomeScreen(), HomeScreen(), Profile()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
        selectedItemColor: Colors.blue,
        // ignore: prefer_const_literals_to_create_immutables
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.add_shopping_cart),
            label: 'Cart',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.add_shopping_cart),
            label: 'Cart',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

// showDialogBox() {
//   showCupertinoDialog<String>(
//     context: context,
//     barrierDismissible: false,
//     builder: (BuildContext context) => CupertinoAlertDialog(
//       title: const Text('No Connection'),
//       content: const Text('Please check your internet connectivity'),
//       actions: <Widget>[
//         TextButton(
//           onPressed: () async {
//             Navigator.pop(context, 'Cancel');
//             setState(() => isAlertSet = false);
//             isDeviceConnected = await InternetConnectionChecker().hasConnection;
//             if (!isDeviceConnected && isAlertSet == false) {
//               showDialogBox();
//               setState(() => isAlertSet = true);
//             }
//           },
//           child: const Text('Try Again'),
//         ),
//       ],
//     ),
//   );
// }
}
