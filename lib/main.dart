import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_pos/Screens/Authentication/forgot_password.dart';
import 'package:mobile_pos/Screens/Authentication/login_form.dart';
import 'package:mobile_pos/Screens/Authentication/register_form.dart';
import 'package:mobile_pos/Screens/Authentication/sign_in.dart';
import 'package:mobile_pos/Screens/Authentication/success_screen.dart';
import 'package:mobile_pos/Screens/Customers/customer_list.dart';
import 'package:mobile_pos/Screens/Delivery/delivery_address_list.dart';
import 'package:mobile_pos/Screens/Expense/expense_list.dart';
import 'package:mobile_pos/Screens/Home/home.dart';
import 'package:mobile_pos/Screens/Loss_Profit/loss_profit_screen.dart';
import 'package:mobile_pos/Screens/Payment/payment_options.dart';
import 'package:mobile_pos/Screens/Products/product_list.dart';
import 'package:mobile_pos/Screens/Profile/profile_screen.dart';
import 'package:mobile_pos/Screens/Purchase/purchase_contact.dart';
import 'package:mobile_pos/Screens/Report/reports.dart';
import 'package:mobile_pos/Screens/SMS/send_sms_screen.dart';
import 'package:mobile_pos/Screens/Sales/add_discount.dart';
import 'package:mobile_pos/Screens/Sales/add_promo_code.dart';
import 'package:mobile_pos/Screens/Sales/sales_contact.dart';
import 'package:mobile_pos/Screens/Sales/sales_details.dart';
import 'package:mobile_pos/Screens/Sales/sales_list.dart';
import 'package:mobile_pos/Screens/SplashScreen/on_board.dart';
import 'package:mobile_pos/Screens/SplashScreen/splash_screen.dart';
import 'package:mobile_pos/Screens/stock_list/stock_list.dart';
import 'package:mobile_pos/constant.dart';

import 'Screens/Authentication/profile_setup.dart';
import 'Screens/Due Calculation/due_calculation_contact_screen.dart';
import 'Screens/Legder/ledger_screen.dart';
import 'Screens/Purchase List/purchase_list_screen.dart';
import 'Screens/Purchase/choose_supplier_screen.dart';
import 'Screens/Sales List/sales_list_screen.dart';
import 'Screens/Warranty/warranty_screen.dart';
import 'firebase_options.dart';

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.white
    ..backgroundColor = kMainColor
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.white
    ..maskColor = kMainColor.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: "MaanPos",
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate();
  FirebaseDatabase.instance.setPersistenceEnabled(true);
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SalesPro',
      initialRoute: '/',
      builder: EasyLoading.init(),
      routes: {
        '/': (context) => const SplashScreen(),
        // '/': (context) => const ProPackagesScreen(),
        '/onBoard': (context) => const OnBoard(),
        '/signIn': (context) => const SignInScreen(),
        '/loginForm': (context) => const LoginForm(),
        '/signup': (context) => const RegisterScreen(),
        '/purchaseCustomer': (context) => const PurchaseContact(),
        '/forgotPassword': (context) => const ForgotPassword(),
        '/success': (context) => const SuccessScreen(),
        '/setupProfile': (context) => const ProfileSetup(),
        '/home': (context) => const Home(),
        '/profile': (context) => const ProfileScreen(),
        '/SMS': (context) => const SendSms(),
        // ignore: missing_required_param

        // '/AddProducts': (context) => AddProduct(),
        // '/UpdateProducts': (context) => const UpdateProduct(),

        '/Products': (context) => const ProductList(),
        '/SalesList': (context) => const SalesScreen(),
        // ignore: missing_required_param
        '/SalesDetails': (context) => SalesDetails(),
        // ignore: prefer_const_constructors
        '/salesCustomer': (context) => SalesContact(),
        '/addPromoCode': (context) => const AddPromoCode(),
        '/addDiscount': (context) => const AddDiscount(),
        '/Sales': (context) => const SalesContact(),
        '/Parties': (context) => const CustomerList(),
        '/Expense': (context) => const ExpenseList(),
        '/Stock List': (context) => const StockList(),
        '/Purchase': (context) => const PurchaseContacts(),
        '/Delivery': (context) => const DeliveryAddress(),
        '/Reports': (context) => const Reports(),
        '/Due List': (context) => const DueCalculationContactScreen(),
        '/PaymentOptions': (context) => const PaymentOptions(),
        '/Sales List': (context) => const SalesListScreen(),
        '/Purchase List': (context) => const PurchaseListScreen(),
        '/Loss/Profit': (context) => const LossProfitScreen(),
        '/Ledger': (context) => const LedgerScreen(),
        '/Warranty': (context) => const WarrantyScreen(),
      },
    );
  }
}
