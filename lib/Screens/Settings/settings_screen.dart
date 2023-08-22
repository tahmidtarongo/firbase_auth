import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/Language/language.dart';
import 'package:mobile_pos/Language/language_screen.dart';
import 'package:mobile_pos/Screens/Profile%20Screen/profile_details.dart';
import 'package:mobile_pos/Screens/Settings/feedback_screen.dart';
import 'package:mobile_pos/Screens/Settings/invoice_settings.dart';
import 'package:mobile_pos/Screens/Settings/live_chat_support_screen.dart';
import 'package:mobile_pos/Screens/SplashScreen/splash_screen.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:restart_app/restart_app.dart';
import '../../Provider/profile_provider.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import '../../constant.dart';
import '../../currency.dart';
import '../../model/personal_information_model.dart';
import '../Shimmers/home_screen_appbar_shimmer.dart';
import '../subscription/package_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String? dropdownValue = 'Tsh (TZ Shillings)';

  bool expanded = false;
  bool expandedHelp = false;
  bool expandedAbout = false;
  bool selected = false;
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    EasyLoading.showSuccess('Successfully Logged Out');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    printerIsEnable();
    getCurrency();
  }

  getCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString('currency');

    if (!data.isEmptyOrNull) {
      for (var element in items) {
        if (element.substring(0, 2).contains(data!)) {
          setState(() {
            dropdownValue = element;
          });
          break;
        }
      }
    } else {
      setState(() {
        dropdownValue = items[0];
      });
    }
  }

  void printerIsEnable() async {
    final prefs = await SharedPreferences.getInstance();

    isPrintEnable = prefs.getBool('isPrintEnable') ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer(builder: (context, ref, _) {
        AsyncValue<PersonalInformationModel> userProfileDetails = ref.watch(profileDetailsProvider);
        return Scaffold(
          backgroundColor: kMainColor,
          body: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                Card(
                  elevation: 0.0,
                  color: kMainColor,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: userProfileDetails.when(data: (details) {
                      return Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              const ProfileDetails().launch(context);
                            },
                            child: Container(
                              height: 42,
                              width: 42,
                              decoration: BoxDecoration(
                                image: DecorationImage(image: NetworkImage(details.pictureUrl ?? ''), fit: BoxFit.cover),
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                details.companyName ?? '',
                                style: GoogleFonts.poppins(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                details.businessCategory ?? '',
                                style: GoogleFonts.poppins(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }, error: (e, stack) {
                      return Text(e.toString());
                    }, loading: () {
                      return const HomeScreenAppBarShimmer();
                    }),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  height: context.height(),
                  decoration:
                      const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30))),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      ListTile(
                        title: Text(
                          lang.S.of(context).profile,
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 18.0,
                          ),
                        ),
                        onTap: () {
                          const ProfileDetails().launch(context);
                        },
                        leading: const Icon(
                          Icons.person_outline_rounded,
                          color: kMainColor,
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          color: kGreyTextColor,
                        ),
                      ),
                      // ListTile(
                      //   onTap: () => EasyLoading.showError('Coming Soon'),
                      //   title: Text(
                      //     'Create Online Store',
                      //     style: GoogleFonts.poppins(
                      //       color: Colors.black,
                      //       fontSize: 18.0,
                      //     ),
                      //   ),
                      //   leading: const Icon(
                      //     Icons.shopping_bag_outlined,
                      //     color: kMainColor,
                      //   ),
                      //   trailing: const Icon(
                      //     Icons.arrow_forward_ios,
                      //     color: kGreyTextColor,
                      //   ),
                      // ),
                      // ExpansionPanelList(
                      //   expandedHeaderPadding: EdgeInsets.zero,
                      //   expansionCallback: (int index, bool isExpanded) {},
                      //   animationDuration: const Duration(seconds: 1),
                      //   elevation: 0,
                      //   dividerColor: Colors.white,
                      //   children: [
                      //     ExpansionPanel(
                      //       headerBuilder: (BuildContext context, bool isExpanded) {
                      //         return Row(
                      //           children: [
                      //             const Padding(
                      //               padding: EdgeInsets.only(left: 16.0),
                      //               child: Icon(
                      //                 Icons.handyman_outlined,
                      //                 color: kMainColor,
                      //               ),
                      //             ),
                      //             TextButton(
                      //               child: Padding(
                      //                 padding: const EdgeInsets.only(left: 24.0),
                      //                 child: Text(
                      //                   'Settings',
                      //                   style: GoogleFonts.poppins(
                      //                     fontSize: 18.0,
                      //                     color: expanded == false ? Colors.black : kMainColor,
                      //                   ),
                      //                 ),
                      //               ),
                      //               onPressed: () {
                      //                 EasyLoading.showError('Coming Soon');
                      //                 // setState(() {
                      //                 //   expanded == false ? expanded = true : expanded = false;
                      //                 // });
                      //               },
                      //             ),
                      //           ],
                      //         );
                      //       },
                      //       body: Column(
                      //         children: [
                      //           Padding(
                      //             padding: const EdgeInsets.only(left: 55.0),
                      //             child: ListTile(
                      //               title: Text(
                      //                 'Notification Setting',
                      //                 style: GoogleFonts.poppins(
                      //                   color: Colors.black,
                      //                   fontSize: 16.0,
                      //                 ),
                      //               ),
                      //               trailing: const Icon(
                      //                 Icons.arrow_forward_ios,
                      //                 color: kGreyTextColor,
                      //                 size: 16.0,
                      //               ),
                      //               onTap: () => showDialog(
                      //                 context: context,
                      //                 builder: (BuildContext context) => Dialog(
                      //                   shape: RoundedRectangleBorder(
                      //                     borderRadius: BorderRadius.circular(12.0),
                      //                   ),
                      //                   child: const NoticationSettings(),
                      //                 ),
                      //               ),
                      //             ),
                      //           ),
                      //           Padding(
                      //             padding: const EdgeInsets.only(left: 55.0),
                      //             child: ListTile(
                      //               title: Text(
                      //                 'Language Setting',
                      //                 style: GoogleFonts.poppins(
                      //                   color: Colors.black,
                      //                   fontSize: 16.0,
                      //                 ),
                      //               ),
                      //               onTap: () => showDialog(
                      //                 context: context,
                      //                 builder: (BuildContext context) => Dialog(
                      //                   shape: RoundedRectangleBorder(
                      //                     borderRadius: BorderRadius.circular(12.0),
                      //                   ),
                      //                   // ignore: sized_box_for_whitespace
                      //                   child: Container(
                      //                     height: 400.0,
                      //                     width: MediaQuery.of(context).size.width - 80,
                      //                     child: Column(
                      //                       children: [
                      //                         const SizedBox(
                      //                           height: 20.0,
                      //                         ),
                      //                         Text(
                      //                           'Select Language',
                      //                           style: GoogleFonts.poppins(
                      //                             color: Colors.black,
                      //                             fontSize: 20.0,
                      //                             fontWeight: FontWeight.bold,
                      //                           ),
                      //                         ),
                      //                         ...List.generate(
                      //                           language.length,
                      //                           (index) => ListTile(
                      //                             title: Text(language[index]),
                      //                             trailing: const Icon(
                      //                               Icons.check_circle_outline,
                      //                               color: kGreyTextColor,
                      //                             ),
                      //                             onTap: () {
                      //                               setState(() {
                      //                                 selected == false ? selected = true : selected = false;
                      //                               });
                      //                               Navigator.pop(context);
                      //                             },
                      //                           ),
                      //                         ),
                      //                       ],
                      //                     ),
                      //                   ),
                      //                 ),
                      //               ),
                      //               trailing: const Icon(
                      //                 Icons.arrow_forward_ios,
                      //                 color: kGreyTextColor,
                      //                 size: 16.0,
                      //               ),
                      //             ),
                      //           ),
                      //           Padding(
                      //             padding: const EdgeInsets.only(left: 55.0),
                      //             child: ListTile(
                      //               title: Text(
                      //                 'Online Store Setting',
                      //                 style: GoogleFonts.poppins(
                      //                   color: Colors.black,
                      //                   fontSize: 16.0,
                      //                 ),
                      //               ),
                      //               trailing: const Icon(
                      //                 Icons.arrow_forward_ios,
                      //                 color: kGreyTextColor,
                      //                 size: 16.0,
                      //               ),
                      //             ),
                      //           ),
                      //           Padding(
                      //             padding: const EdgeInsets.only(left: 55.0),
                      //             child: ListTile(
                      //               title: Text(
                      //                 'App Update',
                      //                 style: GoogleFonts.poppins(
                      //                   color: Colors.black,
                      //                   fontSize: 16.0,
                      //                 ),
                      //               ),
                      //               trailing: const Icon(
                      //                 Icons.arrow_forward_ios,
                      //                 color: kGreyTextColor,
                      //                 size: 16.0,
                      //               ),
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //       isExpanded: expanded,
                      //     ),
                      //   ],
                      // ),
                      // ExpansionPanelList(
                      //   expandedHeaderPadding: EdgeInsets.zero,
                      //   expansionCallback: (int index, bool isExpanded) {},
                      //   animationDuration: const Duration(seconds: 1),
                      //   elevation: 0,
                      //   dividerColor: Colors.white,
                      //   children: [
                      //     ExpansionPanel(
                      //       headerBuilder: (BuildContext context, bool isExpanded) {
                      //         return Row(
                      //           children: [
                      //             const Padding(
                      //               padding: EdgeInsets.only(left: 16.0),
                      //               child: Icon(
                      //                 Icons.help_outline_rounded,
                      //                 color: kMainColor,
                      //               ),
                      //             ),
                      //             TextButton(
                      //               child: Padding(
                      //                 padding: const EdgeInsets.only(left: 24.0),
                      //                 child: Text(
                      //                   'Help & Support',
                      //                   style: GoogleFonts.poppins(
                      //                     fontSize: 18.0,
                      //                     color: expandedHelp == false ? Colors.black : kMainColor,
                      //                   ),
                      //                 ),
                      //               ),
                      //               onPressed: () {
                      //                 EasyLoading.showError('Coming Soon');
                      //                 // setState(() {
                      //                 //   expandedHelp == false ? expandedHelp = true : expandedHelp = false;
                      //                 // });
                      //               },
                      //             ),
                      //           ],
                      //         );
                      //       },
                      //       body: Column(
                      //         children: [
                      //           Padding(
                      //             padding: const EdgeInsets.only(left: 55.0),
                      //             child: ListTile(
                      //               title: Text(
                      //                 'FAQs',
                      //                 style: GoogleFonts.poppins(
                      //                   color: Colors.black,
                      //                   fontSize: 16.0,
                      //                 ),
                      //               ),
                      //               trailing: const Icon(
                      //                 Icons.arrow_forward_ios,
                      //                 color: kGreyTextColor,
                      //                 size: 16.0,
                      //               ),
                      //             ),
                      //           ),
                      //           Padding(
                      //             padding: const EdgeInsets.only(left: 55.0),
                      //             child: ListTile(
                      //               onTap: () {
                      //                 const ContactUs().launch(context);
                      //               },
                      //               title: Text(
                      //                 'Contact Us',
                      //                 style: GoogleFonts.poppins(
                      //                   color: Colors.black,
                      //                   fontSize: 16.0,
                      //                 ),
                      //               ),
                      //               trailing: const Icon(
                      //                 Icons.arrow_forward_ios,
                      //                 color: kGreyTextColor,
                      //                 size: 16.0,
                      //               ),
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //       isExpanded: expandedHelp,
                      //     ),
                      //   ],
                      // ),
                      // ExpansionPanelList(
                      //   expandedHeaderPadding: EdgeInsets.zero,
                      //   expansionCallback: (int index, bool isExpanded) {},
                      //   animationDuration: const Duration(seconds: 1),
                      //   elevation: 0,
                      //   dividerColor: Colors.white,
                      //   children: [
                      //     ExpansionPanel(
                      //       headerBuilder: (BuildContext context, bool isExpanded) {
                      //         return Row(
                      //           children: [
                      //             const Padding(
                      //               padding: EdgeInsets.only(left: 16.0),
                      //               child: Icon(
                      //                 Icons.text_snippet_outlined,
                      //                 color: kMainColor,
                      //               ),
                      //             ),
                      //             TextButton(
                      //               child: Padding(
                      //                 padding: const EdgeInsets.only(left: 24.0),
                      //                 child: Text(
                      //                   'About Us',
                      //                   style: GoogleFonts.poppins(
                      //                     fontSize: 18.0,
                      //                     color: expandedAbout == false ? Colors.black : kMainColor,
                      //                   ),
                      //                 ),
                      //               ),
                      //               onPressed: () {
                      //                 EasyLoading.showError('Coming Soon');
                      //                 // setState(() {
                      //                 //   expandedAbout == false ? expandedAbout = true : expandedAbout = false;
                      //                 // });
                      //               },
                      //             ),
                      //           ],
                      //         );
                      //       },
                      //       body: Column(
                      //         children: [
                      //           Padding(
                      //             padding: const EdgeInsets.only(left: 55.0),
                      //             child: ListTile(
                      //               title: Text(
                      //                 'About Sales Pro',
                      //                 style: GoogleFonts.poppins(
                      //                   color: Colors.black,
                      //                   fontSize: 16.0,
                      //                 ),
                      //               ),
                      //               trailing: const Icon(
                      //                 Icons.arrow_forward_ios,
                      //                 color: kGreyTextColor,
                      //                 size: 16.0,
                      //               ),
                      //             ),
                      //           ),
                      //           Padding(
                      //             padding: const EdgeInsets.only(left: 55.0),
                      //             child: ListTile(
                      //               title: Text(
                      //                 'Privacy Policy',
                      //                 style: GoogleFonts.poppins(
                      //                   color: Colors.black,
                      //                   fontSize: 16.0,
                      //                 ),
                      //               ),
                      //               trailing: const Icon(
                      //                 Icons.arrow_forward_ios,
                      //                 color: kGreyTextColor,
                      //                 size: 16.0,
                      //               ),
                      //             ),
                      //           ),
                      //           Padding(
                      //             padding: const EdgeInsets.only(left: 55.0),
                      //             child: ListTile(
                      //               title: Text(
                      //                 'Terms & Conditions',
                      //                 style: GoogleFonts.poppins(
                      //                   color: Colors.black,
                      //                   fontSize: 16.0,
                      //                 ),
                      //               ),
                      //               trailing: const Icon(
                      //                 Icons.arrow_forward_ios,
                      //                 color: kGreyTextColor,
                      //                 size: 16.0,
                      //               ),
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //       isExpanded: expandedAbout,
                      //     ),
                      //   ],
                      // ),

                      // ListTile(
                      //   title: Text(
                      //     'Invoice Settings',
                      //     style: GoogleFonts.poppins(
                      //       color: Colors.black,
                      //       fontSize: 18.0,
                      //     ),
                      //   ),
                      //   onTap: () {
                      //     // const SubscriptionScreen().launch(context);
                      //     const InvoiceSettings().launch(context);
                      //   },
                      //   leading: const Icon(
                      //     Icons.print,
                      //     color: kMainColor,
                      //   ),
                      //   trailing: const Icon(
                      //     Icons.arrow_forward_ios,
                      //     color: kGreyTextColor,
                      //   ),
                      // ),
                      ListTile(
                        title: Text(
                          lang.S.of(context).feedBack,
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 18.0,
                          ),
                        ),
                        onTap: () {
                          // const SubscriptionScreen().launch(context);
                          const FeedbackScreen().launch(context);
                        },
                        leading: const Icon(
                          Icons.rate_review,
                          color: kMainColor,
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          color: kGreyTextColor,
                        ),
                      ),
                      // ListTile(
                      //   title: Text(
                      //     'Live Chat/Support',
                      //     style: GoogleFonts.poppins(
                      //       color: Colors.black,
                      //       fontSize: 18.0,
                      //     ),
                      //   ),
                      //   onTap: () {
                      //     // const SubscriptionScreen().launch(context);
                      //     const LiveChatSupport().launch(context);
                      //   },
                      //   leading: const Icon(
                      //     Icons.chat,
                      //     color: kMainColor,
                      //   ),
                      //   trailing: const Icon(
                      //     Icons.arrow_forward_ios,
                      //     color: kGreyTextColor,
                      //   ),
                      // ),
                      // ListTile(
                      //   title: Text(
                      //     'Invite/Share With Friends',
                      //     style: GoogleFonts.poppins(
                      //       color: Colors.black,
                      //       fontSize: 18.0,
                      //     ),
                      //   ),
                      //   onTap: () {
                      //     // Share.share('Using Maan POS to make business easier. Download Maan POS and grow your business - https://play.google.com/store/apps/details?id=com.maantechnology.mobipos', subject: 'Download Maan POS and Grow Your Business');
                      //   },
                      //   leading: const Icon(
                      //     Icons.share,
                      //     color: kMainColor,
                      //   ),
                      //   trailing: const Icon(
                      //     Icons.arrow_forward_ios,
                      //     color: kGreyTextColor,
                      //   ),
                      // ),
                      ListTile(
                        title: Text(
                          lang.S.of(context).subscription,
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 18.0,
                          ),
                        ),
                        onTap: () {
                          // const SubscriptionScreen().launch(context);
                          const PackageScreen().launch(context);
                        },
                        leading: const Icon(
                          Icons.account_balance_wallet_outlined,
                          color: kMainColor,
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          color: kGreyTextColor,
                        ),
                      ),
                      ListTile(
                        title: Text(
                          lang.S.of(context).currency,
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 18.0,
                          ),
                        ),
                        leading: const Icon(
                          Icons.currency_exchange,
                          color: kMainColor,
                        ),
                        trailing: DropdownButton(
                          underline: const SizedBox(),
                          value: dropdownValue,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: items.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),
                          onChanged: (newValue) async {
                            final prefs = await SharedPreferences.getInstance();
                            if (newValue == '\$ (US Dollar)') {
                              currency = '\$';
                              await prefs.setString('currency', currency);
                            } else {
                              currency = newValue.toString().substring(0, 1);
                              await prefs.setString('currency', currency);
                            }
                            setState(() {
                              dropdownValue = newValue.toString();
                            });
                          },
                        ),
                      ),
                       ListTile(
                         onTap: (){
                           Navigator.push(context, MaterialPageRoute(builder: (context)=>const LanguageScreen()));
                         },
                        title: Text(lang.S.of(context).language,style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 18.0,
                        ),),
                         leading: Image.asset('images/en.png'),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: kGreyTextColor,
                        ),
                      ),
                      ListTile(
                        title: Text(
                          lang.S.of(context).logOUt,
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 18.0,
                          ),
                        ),
                        onTap: () async {
                          EasyLoading.show(status: 'Log out');
                          await _signOut();
                          Future.delayed(const Duration(milliseconds: 1000), () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>const SplashScreen()));
                            // Restart.restartApp();
                            // const SignInScreen().launch(context);
                          });
                          // Phoenix.rebirth(context);
                        },
                        leading: const Icon(
                          Icons.logout,
                          color: kMainColor,
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          color: kGreyTextColor,
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              'Smart Biashara V-$appVersion',
                              style: GoogleFonts.poppins(
                                color: kGreyTextColor,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class NoticationSettings extends StatefulWidget {
  const NoticationSettings({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _NoticationSettingsState createState() => _NoticationSettingsState();
}

class _NoticationSettingsState extends State<NoticationSettings> {
  bool notify = false;
  String notificationText = 'Off';

  @override
  Widget build(BuildContext context) {
    // ignore: sized_box_for_whitespace
    return Container(
      height: 350.0,
      width: MediaQuery.of(context).size.width - 80,
      child: Column(
        children: [
          Row(
            children: [
              const Spacer(),
              IconButton(
                color: kGreyTextColor,
                icon: const Icon(Icons.cancel_outlined),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          Container(
            height: 100.0,
            width: 100.0,
            decoration: BoxDecoration(
              color: kDarkWhite,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: const Center(
              child: Icon(
                Icons.notifications_none_outlined,
                size: 50.0,
                color: kMainColor,
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Center(
            child: Text(
              lang.S.of(context).doNotDistrub,
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Lorem ipsum dolor sit amet, consectetur elit. Interdum cons.',
                maxLines: 2,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: kGreyTextColor,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                notificationText,
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 16.0,
                ),
              ),
              Switch(
                value: notify,
                onChanged: (val) {
                  setState(() {
                    notify = val;
                    val ? notificationText = 'On' : notificationText = 'Off';
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
