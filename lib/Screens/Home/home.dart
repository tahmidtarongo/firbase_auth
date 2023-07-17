
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:mobile_pos/Screens/Home/home_screen.dart';
import 'package:mobile_pos/Screens/Report/reports.dart';
import 'package:mobile_pos/Screens/Settings/settings_screen.dart';
import 'package:mobile_pos/subscription.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
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
  bool isDeviceConnected = false;
  bool isAlertSet = false;
  bool isNoInternet = false;

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
    Subscription.getUserLimitsData(context: context, wannaShowMsg: true);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainColor,
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        elevation: 6.0,
        selectedItemColor: kMainColor,
        // ignore: prefer_const_literals_to_create_immutables
        items: [
           BottomNavigationBarItem(
            icon: const Icon(FeatherIcons.home),
            label: lang.S.of(context).home,
          ),
           BottomNavigationBarItem(
            icon: const Icon(FeatherIcons.shoppingCart),
            label: lang.S.of(context).sales,
          ),
           BottomNavigationBarItem(
            icon: const Icon(FeatherIcons.fileText),
            label: lang.S.of(context).reports,
          ),
          BottomNavigationBarItem(icon: const Icon(FeatherIcons.settings), label: lang.S.of(context).setting),
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
