import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/Screens/SplashScreen/on_board.dart';
import 'package:mobile_pos/constant.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../currency.dart';
import '../Home/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String newUpdateVersion = '1.1';
  var currentUser = FirebaseAuth.instance.currentUser;
  bool isUpdateAvailable = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  void showSnack(String text) {
    if (_scaffoldKey.currentContext != null) {
      ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(SnackBar(content: Text(text)));
    }
  }

  void getPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
    ].request();
  }

  getCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString('currency');
    if (!data.isEmptyOrNull) {
      currency = data!;
    } else {
      currency = '৳';
    }
  }

  Future<void> updateNotifier() async {
    bool forceUpdate = false;
    bool normalUpdate = false;
    String updatedAppVersion = '';
    final adminPanelRef = FirebaseDatabase.instance.ref().child('Admin Panel');
    adminPanelRef.keepSynced(true);
    await FirebaseDatabase.instance.ref().child('Admin Panel').child('App Update').orderByKey().get().then((value) {
      final updateData = jsonDecode(jsonEncode(value.value));
      forceUpdate = updateData['forceUpdateApp'];
      normalUpdate = updateData['normalUpdateApp'];
      updatedAppVersion = updateData['updatedAppVersion'];
    });

    int thisAppVersion = int.parse(appVersion.replaceAll('.', ''));
    int updateVersion = int.parse(updatedAppVersion.replaceAll('.', ''));

    if (normalUpdate && !forceUpdate && (updateVersion > thisAppVersion)) {
      final prefs = await SharedPreferences.getInstance();
      isPrintEnable = prefs.getBool('isPrintEnable') ?? true;
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Center(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            const Text(
                              'NEW UPDATE AVAILABLE',
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: kMainColor),
                            ),
                            const SizedBox(height: 13),
                            const Text(
                              'Please update your app',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: GestureDetector(
                                onTap: () {
                                  final url = Uri.parse(playStoreUrl);
                                  launchUrl(
                                    url,
                                    mode: LaunchMode.externalApplication,
                                  );
                                },
                                child: Container(
                                  height: 50,
                                  decoration: const BoxDecoration(
                                    color: kMainColor,
                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                  ),
                                  child: const Center(
                                      child: Text(
                                    'Update Now',
                                    style: TextStyle(color: Colors.white),
                                  )),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: GestureDetector(
                                onTap: () {
                                  if (currentUser != null) {
                                    const Home().launch(context);
                                  } else {
                                    const OnBoard().launch(context);
                                  }
                                },
                                child: Container(
                                  height: 50,
                                  decoration: const BoxDecoration(
                                    color: kMainColor,
                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                  ),
                                  child: const Center(
                                      child: Text(
                                    'Remember me later',
                                    style: TextStyle(color: Colors.white),
                                  )),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    } else if (forceUpdate && (updateVersion > thisAppVersion)) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Center(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            const Text(
                              'NEW UPDATE AVAILABLE',
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: kMainColor),
                            ),
                            const SizedBox(height: 13),
                            const Text(
                              'Please update your app',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: GestureDetector(
                                onTap: () {
                                  final url = Uri.parse(playStoreUrl);
                                  launchUrl(
                                    url,
                                    mode: LaunchMode.externalApplication,
                                  );
                                },
                                child: Container(
                                  height: 50,
                                  decoration: const BoxDecoration(
                                    color: kMainColor,
                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                  ),
                                  child: const Center(
                                      child: Text(
                                    'Update Now',
                                    style: TextStyle(color: Colors.white),
                                  )),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    } else {
      if (currentUser != null) {
        const Home().launch(context, isNewTask: true);
      } else {
        const OnBoard().launch(context, isNewTask: true);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrency();
    updateNotifier();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kMainColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: context.height() / 3),
            Container(
              padding: const EdgeInsets.all(30),
              height: context.height() / 4,
              width: context.height() / 4,
              decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(360))),
              child: const Image(
                image: AssetImage(
                  'images/maan_pos.png',
                ),
              ),
            ),
            const Spacer(),
            Column(
              children: [
                Center(
                  child: Text(
                    'Powered By Maan Technology',
                    style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.normal, fontSize: 17),
                  ),
                ),
                Center(
                  child: Text(
                    'V $appVersion',
                    style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.normal),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
