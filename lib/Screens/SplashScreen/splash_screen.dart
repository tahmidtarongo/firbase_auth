import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/Screens/SplashScreen/on_board.dart';
import 'package:mobile_pos/constant.dart';
import 'package:nb_utils/nb_utils.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
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
    // OneSignal.shared.setAppId(onesignalAppId);

// The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
//     OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
//       print("Accepted permission: $accepted");
//     });
  }

  Future<void> updateNotifier() async {
    final prefs = await SharedPreferences.getInstance();
    isRtl = prefs.getBool('isRtl') ?? false;
    await Future.delayed(const Duration(seconds: 3));
    if (currentUser != null) {
      isPrintEnable = prefs.getBool('isPrintEnable') ?? false;
      const Home().launch(context, isNewTask: true);
    } else {
      isPrintEnable = prefs.getBool('isPrintEnable') ?? false;
      const OnBoard().launch(context, isNewTask: true);
    }
  }
  final CurrentUserData currentUserData = CurrentUserData();

  @override
  void initState() {
    super.initState();
    getPermission();
    getCurrency();
    updateNotifier();
    currentUserData.getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Directionality(
        textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
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
                  height: 400,
                  width: 400,
                  image: AssetImage(
                    'images/sb.png',
                  ),
                ),
              ),
              const Spacer(),
              Column(
                children: [
                  Center(
                    child: Text(
                      lang.S.of(context).powerdedByMobiPos,
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
      ),
    );
  }
}
