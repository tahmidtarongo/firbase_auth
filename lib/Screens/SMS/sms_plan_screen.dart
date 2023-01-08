import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/GlobalComponents/button_global.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../constant.dart';
import 'message_history.dart';

class SmsPlanScreen extends StatefulWidget {
  const SmsPlanScreen({Key? key}) : super(key: key);

  @override
  State<SmsPlanScreen> createState() => _SmsPlanScreenState();
}

class _SmsPlanScreenState extends State<SmsPlanScreen> {
  String paymentMethod = 'Bkash';

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
            'Send SMS',
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
      body: Container(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.all(20.0),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30))),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Your message remains',
                    style: TextStyle(color: Colors.black, fontSize: 16.0),
                  ),
                  Text(
                    '50',
                    style: TextStyle(color: Colors.black, fontSize: 16.0),
                  ),
                ],
              ),
              ListView.builder(
                  itemCount: 5,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (_, i) {
                    return Container(
                      padding: const EdgeInsets.all(10.0),
                      margin: const EdgeInsets.only(top: 10.0),
                      decoration: BoxDecoration(color: Colors.white, border: Border.all(color: kGreyTextColor.withOpacity(0.5)), borderRadius: BorderRadius.circular(10.0)),
                      child: Row(
                        children: [
                          Row(
                            children: [
                              Column(
                                children: const [
                                  Text(
                                    '500',
                                    style: TextStyle(color: kMainColor, fontSize: 25.0, fontWeight: FontWeight.w600, letterSpacing: 2.0),
                                  ),
                                  Text(
                                    'SMS',
                                    style: TextStyle(color: kMainColor, fontSize: 18.0, letterSpacing: 4.0),
                                  )
                                ],
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 10.0),
                                width: 2.0,
                                height: 50.0,
                                color: kGreyTextColor.withOpacity(0.5),
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        '৳150',
                                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 18.0),
                                      ),
                                      const SizedBox(
                                        width: 4.0,
                                      ),
                                      Text(
                                        '৳150',
                                        style: TextStyle(color: kGreyTextColor.withOpacity(0.5), decoration: TextDecoration.lineThrough),
                                      ),
                                      const SizedBox(
                                        width: 4.0,
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(6.0),
                                        decoration: BoxDecoration(
                                          color: kAlertColor,
                                          borderRadius: BorderRadius.circular(20.0),
                                        ),
                                        child: const Text(
                                          '25% off',
                                          style: TextStyle(color: Colors.white, fontSize: 12.0),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 4.0,
                                  ),
                                  const Text(
                                    'Per sms 0.20 Taka  only',
                                    style: TextStyle(color: kGreyTextColor),
                                  )
                                ],
                              ),
                            ],
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: kGreyTextColor,
                          )
                        ],
                      ),
                    );
                  }),
              const SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Select Payment Method',
                    style: TextStyle(color: Colors.black, fontSize: 16.0),
                  ),
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(
                      color: paymentMethod == 'Bkash' ? kMainColor : Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(30.0)),
                child: RadioListTile(
                  value: 'Bkash',
                  groupValue: paymentMethod,
                  onChanged: (val) {
                    setState(() {
                      paymentMethod = val.toString();
                    });
                  },
                  secondary: CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage('images/bkash.png'),
                  ),
                  title: const Text(
                    'Bkash',
                    style: TextStyle(color: Colors.black),
                  ),
                  controlAffinity: ListTileControlAffinity.trailing,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(
                      color: paymentMethod == 'Credit or Debit Card' ? kMainColor : Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(30.0)),
                child: RadioListTile(
                  value: 'Credit or Debit Card',
                  groupValue: paymentMethod,
                  onChanged: (val) {
                    setState(() {
                      paymentMethod = val.toString();
                    });
                  },
                  secondary: const CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage('images/card.png'),
                  ),
                  title: const Text(
                    'Credit or Debit Card',
                    style: TextStyle(color: Colors.black),
                  ),
                  controlAffinity: ListTileControlAffinity.trailing,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(
                      color: paymentMethod == 'Paypal' ? kMainColor : Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(30.0)),
                child: RadioListTile(
                  value: 'Paypal',
                  groupValue: paymentMethod,
                  onChanged: (val) {
                    setState(() {
                      paymentMethod = val.toString();
                    });
                  },
                  secondary: const CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage('images/paypal.png'),
                  ),
                  title: const Text(
                    'Paypal',
                    style: TextStyle(color: Colors.black),
                  ),
                  controlAffinity: ListTileControlAffinity.trailing,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              ButtonGlobalWithoutIcon(
                buttontext: 'Continue',
                buttonDecoration: kButtonDecoration.copyWith(color: kMainColor, borderRadius: BorderRadius.circular(20.0)),
                onPressed: null,
                buttonTextColor: Colors.white,
              ),
              const SizedBox(
                height: 10.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
