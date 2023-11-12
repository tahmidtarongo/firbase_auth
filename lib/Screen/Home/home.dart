// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mobile_pos/Providers/product_provider.dart';
import 'package:provider/provider.dart';

import '../../Providers/student_provider.dart';
import '../Auth/sign_in_screen.dart';
import '../Cart/cart_screen.dart';
import '../Orders/orders_screen.dart';
import '../Product/add_product_screen.dart';
import '../Profile/profile.dart';
import '../fev Screem/fav_screen.dart';
import 'home_screen.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  int _selectedIndex2 = 0;
  bool isNoInternet = false;
  String page = 'cart';
  Future<void> logOut() async {
    await FirebaseAuth.instance.signOut();

    EasyLoading.showSuccess('LogOut Done');
    Navigator.popUntil(context, (route) => false);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SignInScreen(),
        ));
  }

  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    CartScreen(),
    FavScreen(),
    Profile(),
    AddProductScreen(),
    OrdersScreen(),
  ];

  void _onItemTapped(int index) {
    if (index == 3) {
      openDrawer();
    } else {
      setState(() {
        _selectedIndex = index;
        _selectedIndex2 = index;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<ProfileProvider>(context, listen: false).getProfile();
    Provider.of<ProductProvider>(context, listen: false).getProductsFromFirebase();
  }

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  void openDrawer() {
    _key.currentState?.openEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        key: _key,
        endDrawer: Drawer(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 60,
                ),
                Card(
                  child: ListTile(
                    onTap: () {
                      setState(() {
                        _selectedIndex2 = 3;
                      });
                      _key.currentState?.closeEndDrawer();
                    },
                    title: const Text('Profile'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                  ),
                ),
                Visibility(
                  visible: Provider.of<ProfileProvider>(context).profile.isAdmin ?? false,
                  child: Card(
                    child: ListTile(
                      onTap: () {
                        setState(() {
                          _selectedIndex2 = 4;
                        });
                        _key.currentState?.closeEndDrawer();
                      },
                      title: const Text('Add Product'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                    ),
                  ),
                ),
                Visibility(
                  visible: Provider.of<ProfileProvider>(context).profile.isAdmin ?? false,
                  child: Card(
                    child: ListTile(
                      onTap: () {
                        setState(() {
                          _selectedIndex2 = 5;
                        });
                        _key.currentState?.closeEndDrawer();
                      },
                      title: const Text('Order List'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    onTap: logOut,
                    title: const Text('Logout'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex2),
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
              icon: Icon(Icons.heart_broken),
              label: 'Fev',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
