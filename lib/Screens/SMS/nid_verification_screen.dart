import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/Screens/SMS/send_sms_screen.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../constant.dart';

class NidVerification extends StatefulWidget {
  const NidVerification({Key? key}) : super(key: key);

  @override
  State<NidVerification> createState() => _NidVerificationState();
}

class _NidVerificationState extends State<NidVerification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainColor,
      appBar: AppBar(
        backgroundColor: kMainColor,
        title: Text(
          'KYC Verification',
          style: GoogleFonts.poppins(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0.0,
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            const  Text('Identity Verify',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600),),
            const Text('You need to identity verify before buying messages',style: TextStyle(color: kGreyTextColor,fontSize: 12.0),),
            const SizedBox(height: 20.0,),
            Card(
              elevation: 2.0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          CircleAvatar(
                            backgroundColor: kMainColor,
                            child: Icon(LineIcons.identification_card_1),
                          ),
                          SizedBox(width: 6.0,),
                          Text('Goverment ID',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 18.0),),

                        ],
                      ),
                      const SizedBox(height: 10.0,),
                      const Text('Take a driver\'s license, national identity card or passport photo',style: TextStyle(color: kGreyTextColor,),textAlign: TextAlign.center,maxLines: 2,),
                      const SizedBox(height: 20.0,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.add_circle_outline_rounded,color: kMainColor,),
                          SizedBox(width: 4.0,),
                          Text('Add Document',style: TextStyle(color: kMainColor,decoration: TextDecoration.underline)),
                        ],
                      ).onTap((){
                        const SendSms().launch(context);
                      }),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height:50.0,),
            Image.asset('images/nid_verification.png')
          ],
        ),
      ),
    );
  }
}
