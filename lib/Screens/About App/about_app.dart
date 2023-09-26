import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:mobile_pos/constant.dart';
import 'package:url_launcher/url_launcher_string.dart';
class AboutApp extends StatefulWidget {
  const AboutApp({Key? key}) : super(key: key);

  @override
  State<AboutApp> createState() => _AboutAppState();
}

class _AboutAppState extends State<AboutApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About App',style: TextStyle(color: Colors.white),),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: kTitleColor,
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 180,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(100),
                bottomRight: Radius.circular(100)
              ),
              color: kMainColor
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Text('About App',style: kTextStyle.copyWith(color: Colors.white,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 80,left: 15,right: 15),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 20),
                child:  Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Row(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     const Icon(Icons.mail_outline,color: Colors.red,size: 30,),
                    //     const SizedBox(width: 10,),
                    //     Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Text('Send Feedback',style: kTextStyle.copyWith(fontWeight: FontWeight.bold,color: kTitleColor),),
                    //         const SizedBox(height: 3,),
                    //         Text('Always welcome and appriciate your\nfeedback',style: kTextStyle.copyWith(color: kGreyTextColor,fontSize: 13),),
                    //         const SizedBox(height: 20,),
                    //         Container(
                    //           height: 1,
                    //           color: kBorderColorTextField,
                    //           width: MediaQuery.of(context).size.width/1.5,
                    //         ),
                    //         const SizedBox(height: 20,),
                    //       ],
                    //     )
                    //   ],
                    // ),
                    // Row(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     const Icon(Icons.share_outlined,color: Colors.blue,size: 30,),
                    //     const SizedBox(width: 10,),
                    //     Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Text('Share Application',style: kTextStyle.copyWith(fontWeight: FontWeight.bold,color: kTitleColor),),
                    //         const SizedBox(height: 3,),
                    //         Text('Share this app to your friends',style: kTextStyle.copyWith(color: kGreyTextColor,fontSize: 13),),
                    //         const SizedBox(height: 20,),
                    //         Container(
                    //           height: 1,
                    //           color: kBorderColorTextField,
                    //           width: MediaQuery.of(context).size.width/1.5,
                    //         ),
                    //         const SizedBox(height: 20,),
                    //       ],
                    //     )
                    //   ],
                    // ),
                    // Row(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     const Icon(FeatherIcons.users,color: kMainColor,size: 30,),
                    //     const SizedBox(width: 10,),
                    //     Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Text('Community',style: kTextStyle.copyWith(fontWeight: FontWeight.bold,color: kTitleColor),),
                    //         const SizedBox(height: 3,),
                    //         Text('Share us your questions or problems\nyou have',style: kTextStyle.copyWith(color: kGreyTextColor,fontSize: 13),),
                    //         const SizedBox(height: 20,),
                    //         Container(
                    //           height: 1,
                    //           color: kBorderColorTextField,
                    //           width: MediaQuery.of(context).size.width/1.5,
                    //         ),
                    //         const SizedBox(height: 20,),
                    //       ],
                    //     )
                    //   ],
                    // ),
                    // GestureDetector(
                    //   onTap: (){
                    //     EasyLoading.showInfo('Coming Soon');
                    //   },
                    //   child: Row(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       const Icon(Icons.update,color: Color(0xff07A499),size: 30,),
                    //       const SizedBox(width: 10,),
                    //       Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           Text('Check for updates',style: kTextStyle.copyWith(fontWeight: FontWeight.bold,color: kTitleColor),),
                    //           const SizedBox(height: 3,),
                    //           Text('Rate App or check for any updates',style: kTextStyle.copyWith(color: kGreyTextColor,fontSize: 13),),
                    //           const SizedBox(height: 20,),
                    //           Container(
                    //             height: 1,
                    //             color: kBorderColorTextField,
                    //             width: MediaQuery.of(context).size.width/1.5,
                    //           ),
                    //           const SizedBox(height: 20,),
                    //         ],
                    //       )
                    //     ],
                    //   ),
                    // ),
                    GestureDetector(
                      onTap: (){
                        launchUrlString('https://smartbiashara.com/terms-and-conditions/');
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(FeatherIcons.alertCircle,color: kGreyTextColor,size: 30,),
                          const SizedBox(width: 10,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 5,),
                              Text('Terms of use',style: kTextStyle.copyWith(fontWeight: FontWeight.bold,color: kTitleColor),),
                              const SizedBox(height: 20,),
                              Container(
                                height: 1,
                                color: kBorderColorTextField,
                                width: MediaQuery.of(context).size.width/1.5,
                              ),
                              const SizedBox(height: 20,),
                            ],
                          )
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        launchUrlString('https://smartbiashara.com/privacy-policy/');
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.warning_amber_rounded,color: kGreyTextColor,size: 30,),
                          const SizedBox(width: 10,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 5,),
                              Text('Privacy Policy',style: kTextStyle.copyWith(fontWeight: FontWeight.bold,color: kTitleColor),),
                              const SizedBox(height: 20,),
                              Container(
                                height: 1,
                                color: kBorderColorTextField,
                                width: MediaQuery.of(context).size.width/1.5,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
