import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/GlobalComponents/button_global.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Provider/customer_provider.dart';
import '../../Provider/delivery_address_provider.dart';
import '../../Provider/product_provider.dart';
import '../../Provider/profile_provider.dart';
import '../../constant.dart';
import '../Home/home.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Consumer(builder: (context, ref, _) {
        ref.refresh(profileDetailsProvider);
        ref.refresh(customerProvider);
        ref.refresh(deliveryAddressProvider);
        ref.refresh(productProvider);
        return Scaffold(
          resizeToAvoidBottomInset: true,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(image: AssetImage('images/success.png')),
              const SizedBox(height: 40.0),
              Text(
                'Congratulations',
                style: GoogleFonts.poppins(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "You are successfully login into your account. Stay with MaanPos.",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: kGreyTextColor,
                    fontSize: 20.0,
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: ButtonGlobalWithoutIcon(
              buttontext: 'Continue',
              buttonDecoration: kButtonDecoration.copyWith(color: kMainColor, borderRadius: const BorderRadius.all(Radius.circular(30))),
              onPressed: () async{
                await Future.delayed(const Duration(seconds: 1)).then((value) => const Home().launch(context));
                // Navigator.pushNamed(context, '/home');
              },
              buttonTextColor: Colors.white),
        );
      }),
    );
  }
}
