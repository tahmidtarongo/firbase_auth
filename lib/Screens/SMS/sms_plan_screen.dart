import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/GlobalComponents/button_global.dart';
import 'package:mobile_pos/Provider/sms_history_provider.dart';
import 'package:mobile_pos/Screens/SMS/sms_plan_payment_screen.dart';
import 'package:mobile_pos/model/sms_subscription_plan_model.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../constant.dart';
import 'message_history.dart';

class SmsPlanScreen extends StatefulWidget {
  const SmsPlanScreen({Key? key, required this.smsBalance}) : super(key: key);
  final String smsBalance;
  @override
  State<SmsPlanScreen> createState() => _SmsPlanScreenState();
}

class _SmsPlanScreenState extends State<SmsPlanScreen> {
  String paymentMethod = 'Bkash';
  SmsSubscriptionPlanModel smsSubscriptionPlanModel = SmsSubscriptionPlanModel(smsPackName: '', smsPackPrice: null, smsPackOfferPrice: null, numberOfSMS: 0, smsValidityInDay: 0);

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
            'Buy SMS',
            style: GoogleFonts.poppins(
              color: Colors.white,
            ),
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
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20.0),
        color: Colors.white,
        child: ButtonGlobalWithoutIcon(
          buttontext: 'Pay with Bkash',
          buttonDecoration: kButtonDecoration.copyWith(color: kMainColor, borderRadius: BorderRadius.circular(20.0)),
          onPressed: (){
            SmsPlanPaymentScreen(model: smsSubscriptionPlanModel).launch(context);
          },
          buttonTextColor: Colors.white,
        ),
      ),
      body: Consumer(builder: (_, ref, watch) {
        final smsPackage = ref.watch(smsPackageProvider);
        return smsPackage.when(data: (package) {
          if(smsSubscriptionPlanModel.smsPackName.isEmpty){
            smsSubscriptionPlanModel = package[0];
          }

          return Container(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.all(20.0),
            decoration: const BoxDecoration(color:Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30))),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Your message remains',
                        style: TextStyle(color: Colors.black, fontSize: 16.0),
                      ),
                      Text(
                        widget.smsBalance,
                        style: const TextStyle(color: Colors.black, fontSize: 16.0),
                      ),
                    ],
                  ),
                  ListView.builder(
                      itemCount: package.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (_, i) {
                        return Container(
                          padding: const EdgeInsets.all(10.0),
                          margin: const EdgeInsets.only(top: 10.0),
                          decoration: BoxDecoration(color:  package[i].smsPackName == smsSubscriptionPlanModel.smsPackName ? kMainColor.withOpacity(0.1): Colors.white, border: Border.all(color: kGreyTextColor.withOpacity(0.5)), borderRadius: BorderRadius.circular(10.0)),
                          child: Row(
                            children: [
                              Row(
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        package[i].numberOfSMS.toString(),
                                        style: const TextStyle(color: kMainColor, fontSize: 25.0, fontWeight: FontWeight.w600, letterSpacing: 2.0),
                                      ),
                                      const Text(
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
                                          Text(
                                            '৳${package[i].smsPackOfferPrice.toString()}',
                                            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 18.0),
                                          ),
                                          const SizedBox(
                                            width: 4.0,
                                          ),
                                          Text(
                                            '৳${package[i].smsPackPrice.toString()}',
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
                                            child: Text(
                                              '${(((package[i].smsPackOfferPrice * 100) ~/ package[i].smsPackPrice) - 100).abs()}% off',
                                              style: const TextStyle(color: Colors.white, fontSize: 12.0),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 4.0,
                                      ),
                                      Text(
                                        'Per sms ${(package[i].smsPackOfferPrice / package[i].numberOfSMS).toString().substring(0, 3)} Taka  only',
                                        style: const TextStyle(color: kGreyTextColor),
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
                        ).onTap((){
                          setState(() {
                            smsSubscriptionPlanModel = package[i];
                          });
                        });
                      }),
                  const SizedBox(
                    height: 20.0,
                  ),

                ],
              ),
            ),
          );
        }, error: (e, stack) {
          return Text(e.toString());
        }, loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
      }),
    );
  }
}
