import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/GlobalComponents/button_global.dart';
import 'package:mobile_pos/Screens/SMS/message_history.dart';
import 'package:mobile_pos/Screens/SMS/sms_customer_list.dart';
import 'package:mobile_pos/Screens/SMS/sms_plan_screen.dart';
import 'package:mobile_pos/model/sms_model.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Provider/profile_provider.dart';
import '../../constant.dart';
import 'contact_list_screen.dart';

class SendSms extends StatefulWidget {
  const SendSms({Key? key}) : super(key: key);

  @override
  State<SendSms> createState() => _SendSmsState();
}

class _SendSmsState extends State<SendSms> {
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController messageContentController = TextEditingController();

  List<Contact> contacts = [];

  Future<void> getContacts() async {
    if (await FlutterContacts.requestPermission()) {
      List<Contact> contact = await FlutterContacts.getContacts();
      contacts.addAll(contact);
    }
  }

  @override
  void initState() {
    getContacts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (_, ref, watch) {
      final userProfileDetails = ref.watch(profileDetailsProvider);
      return userProfileDetails.when(data: (user) {
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
                'Sms left: ${user.smsBalance}',
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
            decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30))),
            child: SingleChildScrollView(
              child: Column(
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
                              children: const [
                                Icon(
                                  Icons.person_rounded,
                                  color: kGreyTextColor,
                                ),
                                Text(
                                  'Customer',
                                  style: TextStyle(color: kGreyTextColor),
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
                              children: const [
                                Icon(
                                  Icons.person_rounded,
                                  color: kGreyTextColor,
                                ),
                                Text(
                                  'Supplier',
                                  style: TextStyle(color: kGreyTextColor),
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
                              children: const [
                                Icon(
                                  Icons.person_rounded,
                                  color: kGreyTextColor,
                                ),
                                Text(
                                  'Dealer',
                                  style: TextStyle(color: kGreyTextColor),
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
                              children: const [
                                Icon(
                                  Icons.person_rounded,
                                  color: kGreyTextColor,
                                ),
                                Text(
                                  'Wholesaler',
                                  style: TextStyle(color: kGreyTextColor),
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
                        hintText: 'Enter Phone number',
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
                  Text(
                    '${selectedNumbers.length} numbers are selected',
                    style: const TextStyle(color: kGreyTextColor),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
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
                            hintText: 'Enter message content',
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
                              '${messageContentController.text.length} Character | 500 character/Message)',
                              style: TextStyle(color: kGreyTextColor.withOpacity(0.5)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ButtonGlobalWithoutIcon(
                    buttontext: 'Send Message',
                    buttonDecoration: kButtonDecoration.copyWith(color: kMainColor, borderRadius: BorderRadius.circular(20.0)),
                    onPressed: () async {
                      EasyLoading.show(status: 'Sending Sms');
                      final refr = FirebaseDatabase.instance.ref('Admin Panel').child('Sms List');
                      for (String element in selectedNumbers) {
                        SmsModel model = SmsModel(
                          customerPhone: element,
                          totalAmount: messageContentController.text,
                          sellerId: FirebaseAuth.instance.currentUser!.uid,
                          sellerName: user.companyName,
                          sellerMobile: user.phoneNumber,
                          type: 'Bulk',
                          status: false,
                        );
                        await refr.push().set(model.toJson());
                      }
                      final DatabaseReference personalInformationRef =
                      FirebaseDatabase.instance.ref().child(FirebaseAuth.instance.currentUser!.uid).child('Personal Information');
                      await personalInformationRef.update({'smsBalance': user.smsBalance! - selectedNumbers.length});
                      ref.refresh(profileDetailsProvider);
                      EasyLoading.showSuccess('Sms Sent');
                      messageContentController.clear();
                      selectedNumbers.clear();
                    },
                    buttonTextColor: Colors.white,
                  ),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: kMainColor),
                    ),
                    child: Column(
                      children:  [
                        const Text(
                          'Buy SMS',
                          style: TextStyle(color: kMainColor, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 4.0,
                        ),
                        Text(
                          'SMS Left: ${user.smsBalance}',
                          style: const TextStyle(color: Colors.redAccent),
                        ),
                      ],
                    ),
                  ).onTap(() => const SmsPlanScreen().launch(context)),
                ],
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
