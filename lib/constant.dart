import 'package:flutter/material.dart';

// const kMainColor = Color(0xFF3F8CFF);
const kMainColor = Color(0xFF567DF4);
const kGreyTextColor = Color(0xFF828282);
const kBorderColorTextField = Color(0xFFC2C2C2);
const kDarkWhite = Color(0xFFF1F7F7);
const kAlertColor = Color(0xFFFF8C34);
const kPremiumPlanColor = Color(0xFF8752EE);
const kPremiumPlanColor2 = Color(0xFFFF5F00);
List<String> selectedNumbers = [];
bool connected = false;
bool isPrintEnable = true;
List<String> paymentsTypeList = ['Cash', 'Card', 'Check', 'Bkash', 'Nagad', 'Mobile Pay', 'Due'];

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

List<String> businessCategory = [
  'Shoes',
  'Clothing',
  'Pharmacy',
  'Furniture',
  'Laundry',
  'Trading',
  'Handicraft',
  'Super Shop',
  'Sunglasses',
  'Coffee & Tea',
  'E-Commerce',
  'Manufacturing',
  'Poultry & Agro',
  'General Store',
  'Mobile Top up',
  'Bag & Luggage',
  'Vehicles & Parts',
  'Home & Kitchen',
  'Motorbike & parts',
  'Mobile & Gadgets',
  'Books & Stationery',
  'Sports & Exercise',
  'Gift, Toys & flowers',
  'Pet & Accessories',
  'Internet , Dish & TV',
  'Service & Repairing',
  'Hardware & sanitary',
  'Cosmetic & Jewellery',
  'Computer & Electronic',
  'Travel  Ticket & Rental',
  'Grocery,  Fruits & Bakery',
  'Saloon & Beauty Parlour',
  'Shop Rent & Office Rent',
  'Thai Aluminium & Glass',
  'Construction & Raw materials',
  'Others'
];
List<String> language = ['English'];

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
