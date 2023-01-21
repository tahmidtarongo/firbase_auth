import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:launch_review/launch_review.dart';
import 'package:mobile_pos/Screens/SplashScreen/on_board.dart';
import 'package:mobile_pos/constant.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../GlobalComponents/button_global.dart';
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
    await [Permission.bluetoothScan, Permission.bluetoothConnect, Permission.notification].request();
  }

  getCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString('currency');
    if (!data.isEmptyOrNull) {
      currency = data!;
    } else {
      currency = '৳';
    }
    OneSignal.shared.setAppId(onesignalAppId);

// The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
      print("Accepted permission: $accepted");
    });
  }

  Future<void> updateNotifier() async {
    final prefs = await SharedPreferences.getInstance();
    InAppUpdate.checkForUpdate().then((updateInfo) {
      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {

        showConfirmDialogCustom(
          context,
          onAccept: (context) {
            LaunchReview.launch();
            if (currentUser != null) {
              isPrintEnable = prefs.getBool('isPrintEnable') ?? false;
              const Home().launch(context, isNewTask: true);
            } else {
              isPrintEnable = prefs.getBool('isPrintEnable') ?? false;
              const OnBoard().launch(context, isNewTask: true);
            }
          },
          onCancel: (context) {

          },
          barrierDismissible: false,
          title: 'Would you like to update the app?',
          subTitle: 'Please Update the app',
        );

        showDialog(context: context, builder: (context){
          return Dialog(
            child: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('images/update.png',height: 200.0,width: 200.0,),
                  const SizedBox(height: 10.0,),
                  const Text('New Version Available !',style: TextStyle(color: Colors.black,fontSize: 18.0,fontWeight: FontWeight.bold),),
                  const SizedBox(height: 4.0,),
                  const Text('Please update the app',style: TextStyle(color: kGreyTextColor),),
                  const SizedBox(height: 10.0,),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              border: Border.all(color: Colors.redAccent)
                          ),
                          child: Row(
                            children: const [
                              Icon(Icons.close,color: Colors.redAccent,),
                              Text('Maybe Later',style: TextStyle(color: Colors.redAccent,fontWeight: FontWeight.bold),),
                            ],
                          ),
                        ).onTap((){
                          if (currentUser != null) {
                            isPrintEnable = prefs.getBool('isPrintEnable') ?? false;
                            const Home().launch(context, isNewTask: true);
                          } else {
                            isPrintEnable = prefs.getBool('isPrintEnable') ?? false;
                            const OnBoard().launch(context, isNewTask: true);
                          }
                        }),
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              color: kMainColor
                          ),
                          child: Row(
                            children: const [
                              Text('Update Now',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                              Icon(Icons.arrow_forward_ios,color: Colors.white,),
                            ],
                          ),
                        ).onTap(() {
                          LaunchReview.launch();
                          if (currentUser != null) {
                            isPrintEnable = prefs.getBool('isPrintEnable') ?? false;
                            const Home().launch(context, isNewTask: true);
                          } else {
                            isPrintEnable = prefs.getBool('isPrintEnable') ?? false;
                            const OnBoard().launch(context, isNewTask: true);
                          }
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      }
    });

    // final adminPanelRef = FirebaseDatabase.instance.ref().child('Admin Panel');
    // adminPanelRef.keepSynced(true);
    // print('Not done');
    // adminPanelRef.child('App Update').orderByKey().get().then((value) {
    //   final updateData = jsonDecode(jsonEncode(value.value));
    //   forceUpdate = updateData['forceUpdateApp'] ?? false;
    //   normalUpdate = updateData['normalUpdateApp'] ?? false;
    //   updatedAppVersion = updateData['updatedAppVersion'] ?? '1.0.0';
    // });
    // print('done');
    // int thisAppVersion = int.parse(appVersion.replaceAll('.', ''));
    // int updateVersion = int.parse(updatedAppVersion.replaceAll('.', ''));
    //
    // if (normalUpdate && !forceUpdate && (updateVersion > thisAppVersion)) {
    //   isPrintEnable = prefs.getBool('isPrintEnable') ?? false;
    //   showDialog(
    //     barrierDismissible: false,
    //     context: context,
    //     builder: (BuildContext context) {
    //       return WillPopScope(
    //         onWillPop: () async => false,
    //         child: Padding(
    //           padding: const EdgeInsets.all(30.0),
    //           child: Center(
    //             child: Container(
    //               width: double.infinity,
    //               decoration: const BoxDecoration(
    //                 color: Colors.white,
    //                 borderRadius: BorderRadius.all(Radius.circular(30)),
    //               ),
    //               child: Column(
    //                 mainAxisSize: MainAxisSize.min,
    //                 children: [
    //                   Padding(
    //                     padding: const EdgeInsets.all(20),
    //                     child: Column(
    //                       children: [
    //                         const SizedBox(height: 20),
    //                         const Text(
    //                           'NEW UPDATE AVAILABLE',
    //                           style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: kMainColor),
    //                         ),
    //                         const SizedBox(height: 13),
    //                         const Text(
    //                           'Please update your app',
    //                           style: TextStyle(
    //                             fontSize: 20,
    //                           ),
    //                         ),
    //                         const SizedBox(height: 20),
    //                         Padding(
    //                           padding: const EdgeInsets.all(10.0),
    //                           child: GestureDetector(
    //                             onTap: () {
    //                               final url = Uri.parse(playStoreUrl);
    //                               launchUrl(
    //                                 url,
    //                                 mode: LaunchMode.externalApplication,
    //                               );
    //                             },
    //                             child: Container(
    //                               height: 50,
    //                               decoration: const BoxDecoration(
    //                                 color: kMainColor,
    //                                 borderRadius: BorderRadius.all(Radius.circular(20)),
    //                               ),
    //                               child: const Center(
    //                                   child: Text(
    //                                 'Update Now',
    //                                 style: TextStyle(color: Colors.white),
    //                               )),
    //                             ),
    //                           ),
    //                         ),
    //                         Padding(
    //                           padding: const EdgeInsets.all(10.0),
    //                           child: GestureDetector(
    //                             onTap: () {
    //                               if (currentUser != null) {
    //                                 const Home().launch(context);
    //                               } else {
    //                                 const OnBoard().launch(context);
    //                               }
    //                             },
    //                             child: Container(
    //                               height: 50,
    //                               decoration: const BoxDecoration(
    //                                 color: kMainColor,
    //                                 borderRadius: BorderRadius.all(Radius.circular(20)),
    //                               ),
    //                               child: const Center(
    //                                   child: Text(
    //                                 'Remember me later',
    //                                 style: TextStyle(color: Colors.white),
    //                               )),
    //                             ),
    //                           ),
    //                         ),
    //                       ],
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ),
    //         ),
    //       );
    //     },
    //   );
    // } else if (forceUpdate && (updateVersion > thisAppVersion)) {
    //   isPrintEnable = prefs.getBool('isPrintEnable') ?? true;
    //   showDialog(
    //     barrierDismissible: false,
    //     context: context,
    //     builder: (BuildContext context) {
    //       return WillPopScope(
    //         onWillPop: () async => false,
    //         child: Padding(
    //           padding: const EdgeInsets.all(30.0),
    //           child: Center(
    //             child: Container(
    //               width: double.infinity,
    //               decoration: const BoxDecoration(
    //                 color: Colors.white,
    //                 borderRadius: BorderRadius.all(Radius.circular(30)),
    //               ),
    //               child: Column(
    //                 mainAxisSize: MainAxisSize.min,
    //                 children: [
    //                   Padding(
    //                     padding: const EdgeInsets.all(20),
    //                     child: Column(
    //                       children: [
    //                         const SizedBox(height: 20),
    //                         const Text(
    //                           'NEW UPDATE AVAILABLE',
    //                           style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: kMainColor),
    //                         ),
    //                         const SizedBox(height: 13),
    //                         const Text(
    //                           'Please update your app',
    //                           style: TextStyle(
    //                             fontSize: 20,
    //                           ),
    //                         ),
    //                         const SizedBox(height: 20),
    //                         Padding(
    //                           padding: const EdgeInsets.all(10.0),
    //                           child: GestureDetector(
    //                             onTap: () {
    //                               final url = Uri.parse(playStoreUrl);
    //                               launchUrl(
    //                                 url,
    //                                 mode: LaunchMode.externalApplication,
    //                               );
    //                             },
    //                             child: Container(
    //                               height: 50,
    //                               decoration: const BoxDecoration(
    //                                 color: kMainColor,
    //                                 borderRadius: BorderRadius.all(Radius.circular(20)),
    //                               ),
    //                               child: const Center(
    //                                   child: Text(
    //                                 'Update Now',
    //                                 style: TextStyle(color: Colors.white),
    //                               )),
    //                             ),
    //                           ),
    //                         ),
    //                       ],
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ),
    //         ),
    //       );
    //     },
    //   );
    // }
  }

  @override
  void initState() {
    super.initState();
    getPermission();
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
