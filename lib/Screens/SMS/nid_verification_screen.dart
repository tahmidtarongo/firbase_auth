import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/Screens/SMS/send_sms_screen.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
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
          lang.S.of(context).kycVerification,
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
            Text(lang.S.of(context).identityVerify,style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w600),),
            Text(lang.S.of(context).youNeedToIdentityVerifyBeforeYouBuying,style: const TextStyle(color: kGreyTextColor,fontSize: 12.0),),
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
                        children:  [
                          const CircleAvatar(
                            backgroundColor: kMainColor,
                            child: Icon(LineIcons.identification_card_1),
                          ),
                          const SizedBox(width: 6.0,),
                          Text(lang.S.of(context).govermentId,style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 18.0),),

                        ],
                      ),
                      const SizedBox(height: 10.0,),
                      Text(lang.S.of(context).takeADriveruser,style: const TextStyle(color: kGreyTextColor,),textAlign: TextAlign.center,maxLines: 2,),
                      const SizedBox(height: 20.0,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:  [
                          const Icon(Icons.add_circle_outline_rounded,color: kMainColor,),
                          const SizedBox(width: 4.0,),
                          Text(lang.S.of(context).addDucument,style: const TextStyle(color: kMainColor,decoration: TextDecoration.underline)),
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
