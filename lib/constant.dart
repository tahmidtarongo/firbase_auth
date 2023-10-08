import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:shared_preferences/shared_preferences.dart';

// const kMainColor = Color(0xFF3F8CFF);
// const kMainColor = Color(0xff3949AB);
const kMainColor = Color(0xff04A65A);
const kGreyTextColor = Color(0xFF828282);
const kBorderColorTextField = Color(0xFFC2C2C2);
const kDarkWhite = Color(0xFFF1F7F7);
const kTitleColor = Color(0xFF000000);
const kAlertColor = Color(0xFFFF8C34);
const kPremiumPlanColor = Color(0xFF8752EE);
const kPremiumPlanColor2 = Color(0xFFFF5F00);
List<String> selectedNumbers = [];

Future<String> getSaleID({required String id}) async {
  String key = '';
  await FirebaseDatabase.instance.ref().child('Admin Panel').child('Seller List').orderByKey().get().then((value) async {
    for (var element in value.children) {
      var data = jsonDecode(jsonEncode(element.value));
      if (data['userId'].toString() == id) {
        key = element.key.toString();
      }
    }
  });
  return key;
}

Future<void> welcomeEmail({required String email}) async {
  final smtpServer = SmtpServer(
    'smtp.stackmail.com',
    port: 587,
    username: 'hello@smartbiashara.com',
    password: 'qwerty7890@',
  );
  final message = Message()
    ..from = const Address('mhello@smartbiashara.com')
    ..recipients.add(email)
    ..subject = 'Welcome to SmartBiashara(POS)!'
    ..html =
        '<h3>Welcome to SmartBiashara(POS)!</h3><p>Were thrilled to have you join us on your journey to streamline and optimize your business operations.</p><p>Our powerful Point of Sale system is here to simplify transactions and boost your business efficiency.</p><p>Let\'s embark on this smart business adventure together!</p><p>Karibu Sana</p>';

  try {
    final sendReport = await send(message, smtpServer);
    print('Message sent: ${sendReport.mail}');
  } catch (e) {
    print('Error sending email: $e');
  }
}

final kTextStyle = GoogleFonts.manrope(
  color: Colors.white,
);

bool connected = false;
bool isPrintEnable = true;
List<String> paymentsTypeList = ['Cash'];

const String onesignalAppId = '1549acc6-6958-4c79-bea0-b8fdae3cbdce';

//___________currency__________________________

const String appVersion = '1.4.0';
const String playStoreUrl = "market://details?id=com.maantechnology.mobipos";

const String paypalClientId = 'ASWARYNRARFIbKf8U4u5Bq9-8tYVszzpkfRhohErQil3izlffjVQE-L0K2M0_bobdPhj2Qyf7uHoGctI';
const String paypalClientSecret = 'EDNYPyTGpziJzfVhqsf75iodgFGSCOZAKXTHuD9YR5PWt5ruwc1HIzgT6STEznFfGro5E8h466i0sPtb';
const bool sandbox = true;

const kButtonDecoration = BoxDecoration(
  borderRadius: BorderRadius.all(
    Radius.circular(5),
  ),
);

Future<String> getUserID() async {
  final prefs = await SharedPreferences.getInstance();
  final String? uid = prefs.getString('userId');

  return uid ?? '';
}

const kInputDecoration = InputDecoration(
  hintStyle: TextStyle(color: kBorderColorTextField),
  filled: true,
  fillColor: Colors.white70,
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
    borderSide: BorderSide(color: kBorderColorTextField, width: 2),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(6.0)),
    borderSide: BorderSide(color: kBorderColorTextField, width: 2),
  ),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(1.0),
    borderSide: const BorderSide(color: kBorderColorTextField),
  );
}

final otpInputDecoration = InputDecoration(
  contentPadding: const EdgeInsets.symmetric(vertical: 5.0),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

final List<String> businessCategory = [
  'Bag & Luggage',
  'Books & Stationery',
  'Clothing',
  'Construction & Raw materials',
  'Coffee & Tea',
  'Cosmetic & Jewellery',
  'Computer & Electronic',
  'E-Commerce',
  'Furniture',
  'General Store',
  'Gift, Toys & flowers',
  'Grocery, Fruits & Bakery',
  'Handicraft',
  'Home & Kitchen',
  'Hardware & sanitary',
  'Internet, Dish & TV',
  'Laundry',
  'Manufacturing',
  'Mobile Top up',
  'Motorbike & parts',
  'Mobile & Gadgets',
  'Pharmacy',
  'Poultry & Agro',
  'Pet & Accessories',
  'Rice mill',
  'Super Shop',
  'Sunglasses',
  'Service & Repairing',
  'Sports & Exercise',
  'Shoes',
  'Saloon & Beauty Parlour',
  'Shop Rent & Office Rent',
  'Travel Ticket & Rental',
  'Trading',
  'Thai Aluminium & Glass',
  'Vehicles & Parts',
  'Others',
];

List<String> language = ['English', 'Swahili'];

List<String> productCategory = ['Fashion', 'Electronics', 'Computer', 'Gadgets', 'Watches', 'Cloths'];

List<String> userRole = [
  'Super Admin',
  'Admin',
  'User',
];

List<String> paymentType = [
  'Cheque',
  'Deposit',
  'Cash',
  'Transfer',
  'Sales',
];
List<String> posStats = [
  'Daily',
  'Monthly',
  'Yearly',
];
List<String> saleStats = [
  'Weekly',
  'Monthly',
  'Yearly',
];

bool isRtl = false;
