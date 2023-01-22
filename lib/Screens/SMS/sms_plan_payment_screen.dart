import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/model/sms_subscription_plan_model.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../constant.dart';
import 'message_history.dart';



class SmsPlanPaymentScreen extends StatefulWidget {
  const SmsPlanPaymentScreen({Key? key, required this.model}) : super(key: key);

  final SmsSubscriptionPlanModel model;


  @override
  State<SmsPlanPaymentScreen> createState() => _SmsPlanPaymentScreenState();
}

class _SmsPlanPaymentScreenState extends State<SmsPlanPaymentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainColor,
      appBar: AppBar(
        backgroundColor: kMainColor,
        title: ListTile(
          onTap: () => const MessageHistory().launch(context),
          contentPadding: EdgeInsets.zero,
          title: Text(
            'Complete Transaction',
            style: GoogleFonts.poppins(
              color: Colors.white,
            ),
          ),
          subtitle: Text(
            'Sms left: 27',
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 10.0),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.history,
                color: Colors.white,
              ),
              Text(
                'History',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0.0,
      ),
    );
  }
}
