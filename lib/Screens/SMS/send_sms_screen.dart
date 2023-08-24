import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/GlobalComponents/button_global.dart';
import 'package:mobile_pos/Screens/SMS/message_history.dart';
import 'package:mobile_pos/Screens/SMS/sms_customer_list.dart';
import 'package:mobile_pos/Screens/SMS/sms_plan_screen.dart';
import 'package:mobile_pos/Screens/SMS/upload_nid.dart';
import 'package:mobile_pos/model/sms_model.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import '../../Provider/profile_provider.dart';
import '../../constant.dart';
import '../../currency.dart';
import 'contact_list_screen.dart';

class SendSms extends StatefulWidget {
  const SendSms({Key? key}) : super(key: key);

  @override
  State<SendSms> createState() => _SendSmsState();
}

class _SendSmsState extends State<SendSms> {
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController messageContentController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (_, ref, watch) {
      final userProfileDetails = ref.watch(profileDetailsProvider);
      return userProfileDetails.when(data: (user) {
        return Scaffold(
          backgroundColor: kMainColor,
          appBar: user.verificationStatus == 'pending'
              ? AppBar(
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
                )
              : AppBar(
                  backgroundColor: kMainColor,
                  title: ListTile(
                    onTap: () => const MessageHistory().launch(context),
                    contentPadding: EdgeInsets.zero,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          lang.S.of(context).sendSms,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 4.0, bottom: 4.0),
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(20.0), border: Border.all(color: Colors.white)),
                          child: Text(
                            'Sms left: ${user.smsBalance}',
                            style: GoogleFonts.poppins(color: Colors.white, fontSize: 10.0),
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.history,
                          color: Colors.white,
                        ),
                        Text(
                          lang.S.of(context).history,
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
            decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30))),
            child: RefreshIndicator(
              onRefresh: () async => await ref.refresh(profileDetailsProvider),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: user.verificationStatus == 'pending'
                    ? Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                             Text(
                               lang.S.of(context).identityVerify,
                              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
                            ),
                             Text(
                              lang.S.of(context).youNeedToIdentityVerifyBeforeYouBuying,
                              style: const TextStyle(color: kGreyTextColor, fontSize: 12.0),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
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
                                          const SizedBox(
                                            width: 6.0,
                                          ),
                                          Text(
                                            lang.S.of(context).govermentId,
                                            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 18.0),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10.0,
                                      ),
                                       Text(
                                        lang.S.of(context).takeADriveruser,
                                        style: const TextStyle(
                                          color: kGreyTextColor,
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                      ),
                                      const SizedBox(
                                        height: 20.0,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children:  [
                                          const Icon(
                                            Icons.add_circle_outline_rounded,
                                            color: kMainColor,
                                          ),
                                          const SizedBox(
                                            width: 4.0,
                                          ),
                                          Text(lang.S.of(context).addDucument, style: const TextStyle(color: kMainColor, decoration: TextDecoration.underline)),
                                        ],
                                      ).onTap(() {
                                        const UploadNid().launch(context);
                                      }),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 50.0,
                            ),
                            Image.asset('images/nid_verification.png')
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          const SizedBox(
                            height: 20.0,
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: kGreyTextColor,
                                      ),
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    child: Row(
                                      children:  [
                                        const Icon(
                                          Icons.person_rounded,
                                          color: kGreyTextColor,
                                        ),
                                        Text(
                                          lang.S.of(context).customer,
                                          style: const TextStyle(color: kGreyTextColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10.0,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: kGreyTextColor,
                                      ),
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    child: Row(
                                      children:  [
                                        const Icon(
                                          Icons.person_rounded,
                                          color: kGreyTextColor,
                                        ),
                                        Text(
                                          lang.S.of(context).supplier,
                                          style: const TextStyle(color: kGreyTextColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10.0),
                                  Container(
                                    padding: const EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: kGreyTextColor,
                                      ),
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    child: Row(
                                      children:  [
                                        const Icon(
                                          Icons.person_rounded,
                                          color: kGreyTextColor,
                                        ),
                                        Text(
                                          lang.S.of(context).dealer,
                                          style: const TextStyle(color: kGreyTextColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10.0),
                                  Container(
                                    padding: const EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: kGreyTextColor,
                                      ),
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    child: Row(
                                      children:  [
                                        const Icon(
                                          Icons.person_rounded,
                                          color: kGreyTextColor,
                                        ),
                                        Text(
                                          lang.S.of(context).wholSeller,
                                          style: const TextStyle(color: kGreyTextColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ).onTap(
                                () {
                                  const SmsCustomerList().launch(context);
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: AppTextField(
                              textFieldType: TextFieldType.PHONE,
                              controller: phoneNumberController,
                              onFieldSubmitted: (val) {
                                setState(() {
                                  selectedNumbers.add(val);
                                  phoneNumberController.clear();
                                });
                              },
                              decoration: InputDecoration(
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Image.asset(
                                    'images/phonebook.png',
                                    height: 50.0,
                                    width: 50.0,
                                  ).onTap(
                                    () {
                                      const ContactListScreen().launch(context);
                                    },
                                  ),
                                ),
                                labelText: '',
                                hintText: lang.S.of(context).enterPhoneNumber,
                                hintStyle: TextStyle(color: kGreyTextColor.withOpacity(0.5)),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: kGreyTextColor.withOpacity(0.2)),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: kGreyTextColor.withOpacity(0.2)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: kGreyTextColor.withOpacity(0.2)),
                                ),
                              ),
                            ),
                          ),
                          HorizontalList(
                              itemCount: selectedNumbers.length,
                              itemBuilder: (_, i) {
                                return Chip(
                                  deleteIcon: const Icon(
                                    Icons.close,
                                    size: 20.0,
                                  ),
                                  onDeleted: () {
                                    setState(() {
                                      selectedNumbers.removeAt(i);
                                    });
                                  },
                                  deleteIconColor: Colors.red,
                                  backgroundColor: kMainColor.withOpacity(0.1),
                                  label: Text(
                                    selectedNumbers[i],
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                  iconTheme: const IconThemeData(color: Colors.red),
                                );
                              }),
                          Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Text(
                                '${selectedNumbers.length} numbers are selected',
                                style: const TextStyle(color: kGreyTextColor),
                              )).visible(selectedNumbers.isNotEmpty),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                            child: Column(
                              children: [
                                AppTextField(
                                  // ignore: deprecated_member_use
                                  textFieldType: TextFieldType.MULTILINE,
                                  controller: messageContentController,
                                  onChanged: (val) {
                                    setState(() {});
                                  },
                                  minLines: 4,
                                  maxLines: 5,
                                  enabled: true,
                                  decoration: InputDecoration(
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    labelText: '',
                                    hintText: lang.S.of(context).enterMessageContent,
                                    suffixIcon: const Padding(
                                      padding: EdgeInsets.only(top: 100.0, right: 10.0),
                                      child: Text(
                                        '-Riyad Store',
                                        style: TextStyle(color: kGreyTextColor),
                                      ),
                                    ),
                                    hintStyle: TextStyle(color: kGreyTextColor.withOpacity(0.5)),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: kGreyTextColor.withOpacity(0.2)),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(color: kGreyTextColor.withOpacity(0.2)),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: kGreyTextColor.withOpacity(0.2)),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 4.0,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '${messageContentController.text.length} Character | 160 character/Message)',
                                      style: TextStyle(color: kGreyTextColor.withOpacity(0.5)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          ButtonGlobalWithoutIcon(
                            buttontext: lang.S.of(context).sendMessage,
                            buttonDecoration: kButtonDecoration.copyWith(color: kMainColor, borderRadius: BorderRadius.circular(20.0)),
                            onPressed: () async {
                              EasyLoading.show(status: 'Sending Sms');
                              final refr = FirebaseDatabase.instance.ref('Admin Panel').child('Sms List');
                              for (String element in selectedNumbers) {
                                SmsModel model = SmsModel(
                                  customerPhone: element,
                                  totalAmount: messageContentController.text,
                                  sellerId: constUserId,
                                  sellerName: user.companyName,
                                  sellerMobile: user.phoneNumber,
                                  type: 'Bulk',
                                  status: false,
                                );
                                await refr.push().set(model.toJson());
                                await Future.delayed(const Duration(seconds: 2));
                              }
                              EasyLoading.showSuccess('Sms Sent');
                              messageContentController.clear();
                              selectedNumbers.clear();
                            },
                            buttonTextColor: Colors.white,
                          ),
                          Container(
                            width: context.width() / 1.3,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30.0),
                              border: Border.all(color: kAlertColor),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(
                                  width: 10.0,
                                ),
                                Text(
                                  'Your SMS Left: ${user.smsBalance}',
                                  style: const TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w600),
                                ),
                                Expanded(
                                    child: ButtonGlobalWithoutIcon(
                                  buttontext: lang.S.of(context).buySms,
                                  buttonDecoration: kButtonDecoration.copyWith(color: kAlertColor, borderRadius: BorderRadius.circular(20.0)),
                                  onPressed: null,
                                  buttonTextColor: Colors.white,
                                ))
                              ],
                            ),
                          ).onTap(() => SmsPlanScreen(
                                smsBalance: user.smsBalance.toString(),
                              ).launch(context)),
                        ],
                      ),
              ),
            ),
          ),
        );
      }, error: (e, stack) {
        return Scaffold(
          body: Center(
            child: Text(e.toString()),
          ),
        );
      }, loading: () {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      });
    });
  }
}
