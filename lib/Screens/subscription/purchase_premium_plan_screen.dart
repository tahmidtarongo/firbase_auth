import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:mobile_pos/Screens/subscription/buy_now.dart';
import 'package:mobile_pos/Screens/subscription/payment_page.dart';
import 'package:mobile_pos/subscript.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../Provider/subscription_provider.dart';
import '../../constant.dart';
import '../../currency.dart';
import '../../model/subscription_model.dart';
import '../../model/subscription_plan_model.dart';
import '../../subscription.dart';
import '../Home/home.dart';

class PurchasePremiumPlanScreen extends StatefulWidget {
  const PurchasePremiumPlanScreen({Key? key, required this.initialSelectedPackage, required this.initPackageValue, required this.isCameBack}) : super(key: key);

  final String initialSelectedPackage;
  final int initPackageValue;
  final bool isCameBack;

  @override
  State<PurchasePremiumPlanScreen> createState() => _PurchasePremiumPlanScreenState();
}

class _PurchasePremiumPlanScreenState extends State<PurchasePremiumPlanScreen> {
  String selectedPayButton = 'Paypal';
  int selectedPackageValue = 0;

  CurrentSubscriptionPlanRepo currentSubscriptionPlanRepo = CurrentSubscriptionPlanRepo();

  SubscriptionModel currentSubscriptionPlan = SubscriptionModel(
    subscriptionName: 'Free',
    subscriptionDate: DateTime.now().toString(),
    saleNumber: 0,
    purchaseNumber: 0,
    partiesNumber: 0,
    dueNumber: 0,
    duration: 0,
    products: 0,
  );

  void getCurrentSubscriptionPlan() async {
    currentSubscriptionPlan = await currentSubscriptionPlanRepo.getCurrentSubscriptionPlans();
    setState(() {
      currentSubscriptionPlan;
    });
  }

  @override
  initState() {
    super.initState();
    getCurrentSubscriptionPlan();
    widget.initPackageValue == 0 ? selectedPackageValue = 2 : 0;
  }

  List<Color> colors = [
    const Color(0xFF06DE90),
    const Color(0xFFF5B400),
    const Color(0xFFFF7468),
  ];
  SubscriptionPlanModel selectedPlan =
      SubscriptionPlanModel(subscriptionName: '', saleNumber: 0, purchaseNumber: 0, partiesNumber: 0, dueNumber: 0, duration: 0, products: 0, subscriptionPrice: 0, offerPrice: 0);
  ScrollController mainScroll = ScrollController();

  List<String> imageList = [
    'images/sp1.png',
    'images/sp2.png',
    'images/sp3.png',
    'images/sp4.png',
    'images/sp5.png',
    'images/sp6.png',
  ];

  List<String> titleListData = [
    'Free Lifetime Update',
    'Android & iOS App Support',
    'Premium Customer Support',
    'Custom Invoice Branding',
    'Unlimited Usage',
    'Free Data Backup',
  ];

  List<String> planDetailsImages = [
    'images/plan_details_1.png',
    'images/plan_details_2.png',
    'images/plan_details_3.png',
    'images/plan_details_4.png',
    'images/plan_details_5.png',
    'images/plan_details_6.png',
  ];
  List<String> planDetailsText = [
    'Free Lifetime Update',
    'Android & iOS App Support',
    'Premium Customer Support',
    'Custom Invoice Branding',
    'Unlimited Usage',
    'Free Data Backup',
  ];
  List<String> desciption = [
    'Stay at the forefront of technological advancements without any extra costs. Our SmartBiashara POS Unlimited Upgrade ensures that you always have the latest tools and features at your fingertips, guaranteeing your business remains cutting-edge.',
    ' We understand the importance of seamless operations. That\'s why our round-the-clock support is available to assist you, whether it\'s a quick query or a comprehensive concern. Connect with us anytime, anywhere via call or WhatsApp to experience unrivaled customer service.',
    ' Unlock the full potential of SmartBiashara POS with personalized training sessions led by our expert team. From the basics to advanced techniques, we ensure you\'re well-versed in utilizing every facet of the system to optimize your business processes.',
    ' Make a lasting impression on your customers with branded invoices. Our Unlimited Upgrade offers the unique advantage of customizing your invoices, adding a professional touch that reinforces your brand identity and fosters customer loyalty.',
    ' The name says it all. With SmartBiashara POS Unlimited, there\'s no cap on your usage. Whether you\'re processing a handful of transactions or experiencing a rush of customers, you can operate with confidence, knowing you\'re not constrained by limits.',
    ' Safeguard your business data effortlessly. Our SmartBiashara POS Unlimited Upgrade includes free data backup, ensuring your valuable information is protected against any unforeseen events. Focus on what truly matters - your business growth.'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainColor,
      body: Consumer(
        builder: (context, ref, __) {
          final subscriptionData = ref.watch(subscriptionPlanProvider);
          return SingleChildScrollView(
            child: SafeArea(
              child: subscriptionData.when(data: (data) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            lang.S.of(context).purchasePremiumPlan,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              widget.isCameBack ? Navigator.pop(context) : const Home().launch(context);
                            },
                            child: const Icon(
                              Icons.cancel_outlined,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.topCenter,
                      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30))),
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          ListView.builder(
                              itemCount: imageList.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (_, i) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Dialog(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                const SizedBox(height: 20),
                                                Row(
                                                  mainAxisSize: MainAxisSize.max,
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    GestureDetector(
                                                      child: const Icon(Icons.cancel),
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                    const SizedBox(width: 20),
                                                  ],
                                                ),
                                                const SizedBox(height: 20),
                                                Image(
                                                  height: 200,
                                                  width: 200,
                                                  image: AssetImage(planDetailsImages[i]),
                                                ),
                                                const SizedBox(height: 20),
                                                Text(
                                                  planDetailsText[i],
                                                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                                ),
                                                const SizedBox(height: 15),
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text(desciption[i], textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
                                                ),
                                                const SizedBox(height: 20),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: Card(
                                      elevation: 1,
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: ListTile(
                                          leading: SizedBox(
                                            height: 40,
                                            width: 40,
                                            child: Image(
                                              image: AssetImage(imageList[i]),
                                            ),
                                          ),
                                          title: Text(
                                            titleListData[i],
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                          ),
                                          trailing: const Icon(FeatherIcons.alertCircle),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                          const SizedBox(height: 10),
                          Text(
                            lang.S.of(context).buyPremiumPlan,
                            textAlign: TextAlign.start,
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20),
                          // SizedBox(
                          //   height: 210,
                          //   child: ListView.builder(
                          //     physics: const ClampingScrollPhysics(),
                          //     shrinkWrap: true,
                          //     scrollDirection: Axis.horizontal,
                          //     itemCount: data.length,
                          //     itemBuilder: (BuildContext context, int index) {
                          //       return Padding(
                          //         padding: const EdgeInsets.only(right: 10),
                          //         child: Column(
                          //           children: [
                          //             SizedBox(
                          //               width: 150,
                          //               child: Stack(
                          //                 alignment: Alignment.bottomCenter,
                          //                 children: [
                          //                   GestureDetector(
                          //                     onTap:(){
                          //                       setState(() {
                          //                       });
                          //                     },
                          //                     child: Container(
                          //                       height: 210,
                          //                       width: 150,
                          //                       decoration: BoxDecoration(
                          //                         color: currentSubscriptionPlan.subscriptionName == data[index].subscriptionName ? kPremiumPlanColor2.withOpacity(0.1) : Colors.white,
                          //                         borderRadius: const BorderRadius.all(
                          //                           Radius.circular(10),
                          //                         ),
                          //                         border: Border.all(width: 1, color: currentSubscriptionPlan.subscriptionName == data[index].subscriptionName ? kPremiumPlanColor2 : kPremiumPlanColor),
                          //                       ),
                          //                       child: Column(
                          //                         mainAxisAlignment: MainAxisAlignment.center,
                          //                         children: [
                          //                           const SizedBox(height: 15),
                          //                           const Text(
                          //                             'Mobile App \n+\nDesktop',
                          //                             textAlign: TextAlign.center,
                          //                             style: TextStyle(
                          //                               fontSize: 16,
                          //                             ),
                          //                           ),
                          //                           const SizedBox(height: 15),
                          //                           Text(
                          //                             data[index].subscriptionName,
                          //                             style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
                          //                           ),
                          //                           const SizedBox(height: 5),
                          //                           Text(
                          //                             '$currency${data[index].offerPrice > 0 ? data[index].offerPrice : data[index].subscriptionPrice}',
                          //                             style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                          //                           ),
                          //                           Text(
                          //                             '$currency${data[index].subscriptionPrice}',
                          //                             style: const TextStyle(decoration: TextDecoration.lineThrough, fontSize: 14, color: Colors.grey),
                          //                           ).visible(data[index].offerPrice > 0),
                          //                           const SizedBox(height: 5),
                          //                           Text(
                          //                             'Duration ${data[index].duration} Day',
                          //                             style: const TextStyle(color: kGreyTextColor),
                          //                           ),
                          //                         ],
                          //                       ),
                          //                     ),
                          //                   ),
                          //                   Positioned(
                          //                     top: 0,
                          //                     left: 0,
                          //                     child: Container(
                          //                       height: 25,
                          //                       width: 70,
                          //                       decoration: const BoxDecoration(
                          //                         color: Colors.blue,
                          //                         borderRadius: BorderRadius.only(
                          //                           topLeft: Radius.circular(10),
                          //                           bottomRight: Radius.circular(10),
                          //                         ),
                          //                       ),
                          //                       child: Center(
                          //                         child: Text(
                          //                           data[index].offerPrice == data[index].subscriptionPrice
                          //                               ? ""
                          //                               : 'Save ${(100 - ((data[index].offerPrice * 100) / data[index].subscriptionPrice)).toInt().toString()}%',
                          //                           style: const TextStyle(color: Colors.white),
                          //                         ),
                          //                       ),
                          //                     ),
                          //                   ).visible(data[index].offerPrice > 0),
                          //                 ],
                          //               ),
                          //             ),
                          //
                          //           ],
                          //         ),
                          //       );
                          //     },
                          //   ),
                          // ),
                          SizedBox(
                            height: (context.width() / 2) + 18,
                            child: ListView.builder(
                              physics: const ClampingScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: data.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedPlan = data[index];
                                    });
                                  },
                                  child: data[index].offerPrice >= 1
                                      ? Padding(
                                          padding: const EdgeInsets.only(right: 10),
                                          child: SizedBox(
                                            height: (context.width() / 2.5) + 18,
                                            child: Stack(
                                              alignment: Alignment.bottomCenter,
                                              children: [
                                                Container(
                                                  height: (context.width() / 2.0),
                                                  width: (context.width() / 2.5) - 20,
                                                  decoration: BoxDecoration(
                                                    color: data[index].subscriptionName == selectedPlan.subscriptionName ? kPremiumPlanColor2.withOpacity(0.1) : Colors.white,
                                                    borderRadius: const BorderRadius.all(
                                                      Radius.circular(10),
                                                    ),
                                                    border: Border.all(
                                                      width: 1,
                                                      color: data[index].subscriptionName == selectedPlan.subscriptionName ? kPremiumPlanColor2 : kPremiumPlanColor,
                                                    ),
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      const SizedBox(height: 15),
                                                      const Text(
                                                        'Mobile App\n+\nDesktop',
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 15),
                                                      Text(
                                                        data[index].subscriptionName,
                                                        style: const TextStyle(fontSize: 16),
                                                      ),
                                                      const SizedBox(height: 5),
                                                      Text(
                                                        '$currency${data[index].offerPrice}',
                                                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kPremiumPlanColor2),
                                                      ),
                                                      Text(
                                                        '$currency${data[index].subscriptionPrice}',
                                                        style: const TextStyle(decoration: TextDecoration.lineThrough, fontSize: 14, color: Colors.grey),
                                                      ),
                                                      const SizedBox(height: 5),
                                                      Text(
                                                        'Duration ${data[index].duration} Day',
                                                        style: const TextStyle(color: kGreyTextColor),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 8,
                                                  left: 0,
                                                  child: Container(
                                                    height: 25,
                                                    width: 70,
                                                    decoration: const BoxDecoration(
                                                      color: kPremiumPlanColor2,
                                                      borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(10),
                                                        bottomRight: Radius.circular(10),
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        'Save ${(100 - ((data[index].offerPrice * 100) / data[index].subscriptionPrice)).toInt().toString()}%',
                                                        style: const TextStyle(color: Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.only(bottom: 20, top: 20, right: 10),
                                          child: Container(
                                            height: (context.width() / 2.0),
                                            width: (context.width() / 2.5) - 20,
                                            decoration: BoxDecoration(
                                              color: data[index].subscriptionName == selectedPlan.subscriptionName ? kPremiumPlanColor2.withOpacity(0.1) : Colors.white,
                                              borderRadius: const BorderRadius.all(
                                                Radius.circular(10),
                                              ),
                                              border: Border.all(
                                                  width: 1, color: data[index].subscriptionName == selectedPlan.subscriptionName ? kPremiumPlanColor2 : kPremiumPlanColor),
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                const Text(
                                                  'Mobile App\n+\nDesktop',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                const SizedBox(height: 15),
                                                Text(
                                                  data[index].subscriptionName,
                                                  style: const TextStyle(fontSize: 16),
                                                ),
                                                const SizedBox(height: 5),
                                                Text(
                                                  '$currency${data[index].subscriptionPrice.toString()}',
                                                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kPremiumPlanColor),
                                                ),
                                                const SizedBox(height: 5),
                                                Text(
                                                  'Duration ${data[index].duration} Day',
                                                  style: const TextStyle(color: kGreyTextColor),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          // SingleChildScrollView(
                          //   scrollDirection: Axis.horizontal,
                          //   child: Container(
                          //     height: 202,
                          //     child: Row(
                          //       children: [
                          //         ListView.builder(
                          //           physics: const ClampingScrollPhysics(),
                          //           shrinkWrap: true,
                          //           scrollDirection: Axis.horizontal,
                          //           itemCount: data.length,
                          //           itemBuilder: (BuildContext context, int index) {
                          //             return Padding(
                          //               padding: const EdgeInsets.all(8.0),
                          //               child: Container(
                          //                 width: 130,
                          //                 decoration: BoxDecoration(
                          //                   color: currentSubscriptionPlan.subscriptionName == data[index].subscriptionName ? kPremiumPlanColor2.withOpacity(0.1) : Colors.white,
                          //                   borderRadius: const BorderRadius.all(
                          //                     Radius.circular(10),
                          //                   ),
                          //                   border: Border.all(width: 1, color: currentSubscriptionPlan.subscriptionName == data[index].subscriptionName ? kPremiumPlanColor2 : kPremiumPlanColor),
                          //                 ),
                          //                 child: Stack(
                          //                   children: [
                          //                     Column(
                          //                       crossAxisAlignment: CrossAxisAlignment.start,
                          //                       children: [
                          //                         Image.asset(
                          //                           'images/free.png',
                          //                           height: 60.0,
                          //                           width: 60.0,
                          //                         ),
                          //                         Padding(
                          //                           padding: const EdgeInsets.all(10.0),
                          //                           child: Column(
                          //                             crossAxisAlignment: CrossAxisAlignment.start,
                          //                             children: [
                          //                               Text(
                          //                                 data[index].subscriptionName,
                          //                                 style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                          //                               ),
                          //                               const SizedBox(height: 6.0),
                          //                               Text(
                          //                                 '${data[index].duration} Day',
                          //                                 style: kTextStyle.copyWith(color: kTitleColor),
                          //                               ),
                          //                               const SizedBox(height: 6.0),
                          //                               Column(
                          //                                 crossAxisAlignment: CrossAxisAlignment.start,
                          //                                 mainAxisSize: MainAxisSize.min,
                          //                                 children: [
                          //                                   data[index].offerPrice > 0 ?  Text(
                          //                                     data[index].offerPrice > 0 ? '$currency ${data[index].subscriptionPrice}' : '',
                          //                                     style: const TextStyle(
                          //                                       decoration: TextDecoration.lineThrough,
                          //                                       color: Colors.grey,
                          //                                     ),
                          //                                   ): const SizedBox(height: 0,),
                          //                                   Row(
                          //                                     children: [
                          //                                       Text(
                          //                                         data[index].offerPrice > 0 ? '$currency${data[index].offerPrice}' : '$currency${data[index].subscriptionPrice}',
                          //                                         style: kTextStyle.copyWith(color: colors[index % 3], fontSize: 18.0, fontWeight: FontWeight.bold),
                          //                                       ),
                          //                                     ],
                          //                                   )
                          //                                 ],
                          //                               ),
                          //                               const SizedBox(
                          //                                 height: 6.0,
                          //                               ),
                          //                             ],
                          //                           ),
                          //                         ),
                          //                       ],
                          //                     ),
                          //
                          //                     ///__________Current Plan__________________________________________________________________________________
                          //                     Positioned(
                          //                       top: 0,
                          //                       right: 0,
                          //                       child: Container(
                          //                         decoration: const BoxDecoration(
                          //                             color: Colors.blue, borderRadius: BorderRadius.only(topLeft: Radius.circular(15), bottomRight: Radius.circular(15))),
                          //                         child: Center(
                          //                           child: Padding(
                          //                             padding: const EdgeInsets.all(8.0),
                          //                             child: Column(
                          //                               crossAxisAlignment: CrossAxisAlignment.start,
                          //                               mainAxisSize: MainAxisSize.min,
                          //                               children: [
                          //                                 const Text(
                          //                                   'Current Plan',
                          //                                   style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          //                                 ),
                          //                                 Text(
                          //                                   'Expires in ${(DateTime.parse(currentSubscriptionPlan.subscriptionDate).difference(DateTime.now()).inDays.abs() - currentSubscriptionPlan.duration).abs()} Days',
                          //                                   style: kTextStyle.copyWith(color: Colors.white,fontSize: 12),
                          //                                   maxLines: 3,
                          //                                 )
                          //                               ],
                          //                             ),
                          //                           ),
                          //                         ),
                          //                       ),
                          //                     ).visible(currentSubscriptionPlan.subscriptionName == data[index].subscriptionName)
                          //                   ],
                          //                 ),
                          //               ),
                          //             );
                          //           },
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   crossAxisAlignment: CrossAxisAlignment.center,
                          //   children: [
                          //     GestureDetector(
                          //       onTap: () {
                          //         setState(() {
                          //           Subscription.selectedItem = 'Month';
                          //           selectedPackageValue = 1;
                          //         });
                          //       },
                          //       child: Container(
                          //         height: (context.width() / 3) - 20,
                          //         width: (context.width() / 3) - 20,
                          //         decoration: BoxDecoration(
                          //           color: Subscription.selectedItem == 'Month' ? kPremiumPlanColor2.withOpacity(0.1) : Colors.white,
                          //           borderRadius: const BorderRadius.all(
                          //             Radius.circular(10),
                          //           ),
                          //           border: Border.all(width: 1, color: Subscription.selectedItem == 'Month' ? kPremiumPlanColor2 : kPremiumPlanColor),
                          //         ),
                          //         child: Column(
                          //           mainAxisAlignment: MainAxisAlignment.center,
                          //           children: [
                          //             Text(
                          //               lang.S.of(context).monthly,
                          //               style: const TextStyle(
                          //                 fontSize: 16,
                          //               ),
                          //             ),
                          //             const SizedBox(height: 20),
                          //             Text(
                          //               '$currency${Subscription.subscriptionAmounts['Month']!['Amount']}',
                          //               style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kPremiumPlanColor),
                          //             )
                          //           ],
                          //         ),
                          //       ),
                          //     ),
                          //     GestureDetector(
                          //       onTap: () {
                          //         setState(() {
                          //           Subscription.selectedItem = 'Year';
                          //           selectedPackageValue = 2;
                          //         });
                          //       },
                          //       child: SizedBox(
                          //         height: (context.width() / 2.5) + 18,
                          //         child: Stack(
                          //           alignment: Alignment.bottomCenter,
                          //           children: [
                          //             Container(
                          //               height: (context.width() / 2.5),
                          //               width: (context.width() / 3) - 20,
                          //               decoration: BoxDecoration(
                          //                 color: Subscription.selectedItem == 'Year' ? kPremiumPlanColor2.withOpacity(0.1) : Colors.white,
                          //                 borderRadius: const BorderRadius.all(
                          //                   Radius.circular(10),
                          //                 ),
                          //                 border: Border.all(
                          //                   width: 1,
                          //                   color: Subscription.selectedItem == 'Year' ? kPremiumPlanColor2 : kPremiumPlanColor,
                          //                 ),
                          //               ),
                          //               child: Column(
                          //                 mainAxisAlignment: MainAxisAlignment.center,
                          //                 children: [
                          //                   const SizedBox(height: 15),
                          //                   const Text(
                          //                     'Mobile App +\nDesktop',
                          //                     textAlign: TextAlign.center,
                          //                     style: TextStyle(
                          //                       fontSize: 16,
                          //                     ),
                          //                   ),
                          //                   const SizedBox(height: 15),
                          //                   Text(
                          //                     lang.S.of(context).yearly,
                          //                     style: TextStyle(
                          //                       fontSize: 16,
                          //                     ),
                          //                   ),
                          //                   const SizedBox(height: 5),
                          //                   Text(
                          //                     '$currency${Subscription.subscriptionAmounts['Year']!['Amount']}',
                          //                     style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kPremiumPlanColor2),
                          //                   ),
                          //                   Text(
                          //                     '$currency 119.88',
                          //                     style: const TextStyle(decoration: TextDecoration.lineThrough, fontSize: 14, color: Colors.grey),
                          //                   ),
                          //                 ],
                          //               ),
                          //             ),
                          //             Positioned(
                          //               top: 8,
                          //               left: 0,
                          //               child: Container(
                          //                 height: 25,
                          //                 width: 70,
                          //                 decoration: const BoxDecoration(
                          //                   color: kPremiumPlanColor2,
                          //                   borderRadius: BorderRadius.only(
                          //                     topLeft: Radius.circular(10),
                          //                     bottomRight: Radius.circular(10),
                          //                   ),
                          //                 ),
                          //                 child: const Center(
                          //                   child: Text(
                          //                     'Save 17%',
                          //                     style: TextStyle(color: Colors.white),
                          //                   ),
                          //                 ),
                          //               ),
                          //             ),
                          //           ],
                          //         ),
                          //       ),
                          //     ),
                          //     GestureDetector(
                          //       onTap: () {
                          //         setState(() {
                          //           Subscription.selectedItem = 'Lifetime';
                          //           selectedPackageValue = 3;
                          //         });
                          //       },
                          //       child: SizedBox(
                          //         height: (context.width() / 3) - 8,
                          //         child: Stack(
                          //           alignment: Alignment.bottomCenter,
                          //           children: [
                          //             Container(
                          //               height: (context.width() / 3) - 20,
                          //               width: (context.width() / 3) - 20,
                          //               decoration: BoxDecoration(
                          //                 color: Subscription.selectedItem == 'Lifetime' ? kPremiumPlanColor2.withOpacity(0.1) : Colors.white,
                          //                 borderRadius: const BorderRadius.all(
                          //                   Radius.circular(10),
                          //                 ),
                          //                 border: Border.all(width: 1, color: Subscription.selectedItem == 'Lifetime' ? kPremiumPlanColor2 : kPremiumPlanColor),
                          //               ),
                          //               child: Column(
                          //                 mainAxisAlignment: MainAxisAlignment.center,
                          //                 children: [
                          //                   Text(
                          //                     lang.S.of(context).lifeTimePurchase,
                          //                     textAlign: TextAlign.center,
                          //                     style: const TextStyle(
                          //                       fontSize: 16,
                          //                     ),
                          //                   ),
                          //                   const SizedBox(height: 8),
                          //                   Text(
                          //                     '$currency${Subscription.subscriptionAmounts['Lifetime']!['Amount']}',
                          //                     style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kPremiumPlanColor),
                          //                   ),
                          //                   Text(
                          //                     '$currency 1500.00',
                          //                     style: const TextStyle(decoration: TextDecoration.lineThrough, fontSize: 12, color: Colors.grey),
                          //                   ),
                          //                 ],
                          //               ),
                          //             ),
                          //             Positioned(
                          //               top: 0,
                          //               left: 0,
                          //               child: Container(
                          //                 height: 25,
                          //                 width: 70,
                          //                 decoration: const BoxDecoration(
                          //                   color: kPremiumPlanColor,
                          //                   borderRadius: BorderRadius.only(
                          //                     topLeft: Radius.circular(10),
                          //                     bottomRight: Radius.circular(10),
                          //                   ),
                          //                 ),
                          //                 child: const Center(
                          //                   child: Text(
                          //                     'Save 33%',
                          //                     style: TextStyle(color: Colors.white),
                          //                   ),
                          //                 ),
                          //               ),
                          //             ),
                          //           ],
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          // SizedBox(
                          //   height: (context.width() / 2) + 18,
                          //   child: ListView.builder(
                          //     physics: const ClampingScrollPhysics(),
                          //     shrinkWrap: true,
                          //     scrollDirection: Axis.horizontal,
                          //     itemCount: data.length,
                          //     itemBuilder: (BuildContext context, int index) {
                          //       return GestureDetector(
                          //         onTap: () {
                          //           setState(() {
                          //             selectedPlan = data[index];
                          //           });
                          //         },
                          //         child: data[index].offerPrice >= 1
                          //             ? Padding(
                          //           padding: const EdgeInsets.only(right: 10),
                          //           child: SizedBox(
                          //             height: (context.width() / 2.5) + 18,
                          //             child: Stack(
                          //               alignment: Alignment.bottomCenter,
                          //               children: [
                          //                 Container(
                          //                   height: (context.width() / 2.0),
                          //                   width: (context.width() / 2.5) - 20,
                          //                   decoration: BoxDecoration(
                          //                     color: data[index].subscriptionName == selectedPlan.subscriptionName ? kPremiumPlanColor2.withOpacity(0.1) : Colors.white,
                          //                     borderRadius: const BorderRadius.all(
                          //                       Radius.circular(10),
                          //                     ),
                          //                     border: Border.all(
                          //                       width: 1,
                          //                       color: data[index].subscriptionName == selectedPlan.subscriptionName ? kPremiumPlanColor2 : kPremiumPlanColor,
                          //                     ),
                          //                   ),
                          //                   child: Column(
                          //                     mainAxisAlignment: MainAxisAlignment.center,
                          //                     children: [
                          //                       const SizedBox(height: 15),
                          //                       const Text(
                          //                         'Mobile App\n+\nDesktop',
                          //                         textAlign: TextAlign.center,
                          //                         style: TextStyle(
                          //                           fontSize: 16,
                          //                         ),
                          //                       ),
                          //                       const SizedBox(height: 15),
                          //                       Text(
                          //                         data[index].subscriptionName,
                          //                         style: const TextStyle(fontSize: 16),
                          //                       ),
                          //                       const SizedBox(height: 5),
                          //                       Text(
                          //                         '$currency${data[index].offerPrice}',
                          //                         style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kPremiumPlanColor2),
                          //                       ),
                          //                       Text(
                          //                         '$currency${data[index].subscriptionPrice}',
                          //                         style: const TextStyle(decoration: TextDecoration.lineThrough, fontSize: 14, color: Colors.grey),
                          //                       ),
                          //                       const SizedBox(height: 5),
                          //                       Text(
                          //                         'Duration ${data[index].duration} Day',
                          //                         style: const TextStyle(color: kGreyTextColor),
                          //                       ),
                          //                     ],
                          //                   ),
                          //                 ),
                          //                 Positioned(
                          //                   top: 8,
                          //                   left: 0,
                          //                   child: Container(
                          //                     height: 25,
                          //                     width: 70,
                          //                     decoration: const BoxDecoration(
                          //                       color: kPremiumPlanColor2,
                          //                       borderRadius: BorderRadius.only(
                          //                         topLeft: Radius.circular(10),
                          //                         bottomRight: Radius.circular(10),
                          //                       ),
                          //                     ),
                          //                     child: Center(
                          //                       child: Text(
                          //                         'Save ${(100 - ((data[index].offerPrice * 100) / data[index].subscriptionPrice)).toInt().toString()}%',
                          //                         style: const TextStyle(color: Colors.white),
                          //                       ),
                          //                     ),
                          //                   ),
                          //                 ),
                          //               ],
                          //             ),
                          //           ),
                          //         )
                          //             : Padding(
                          //           padding: const EdgeInsets.only(bottom: 20, top: 20, right: 10),
                          //           child: Container(
                          //             height: (context.width() / 2.0),
                          //             width: (context.width() / 2.5) - 20,
                          //             decoration: BoxDecoration(
                          //               color: data[index].subscriptionName == selectedPlan.subscriptionName ? kPremiumPlanColor2.withOpacity(0.1) : Colors.white,
                          //               borderRadius: const BorderRadius.all(
                          //                 Radius.circular(10),
                          //               ),
                          //               border: Border.all(width: 1, color: data[index].subscriptionName == selectedPlan.subscriptionName ? kPremiumPlanColor2 : kPremiumPlanColor),
                          //             ),
                          //             child: Column(
                          //               mainAxisAlignment: MainAxisAlignment.center,
                          //               children: [
                          //                 const Text(
                          //                   'Mobile App\n+\nDesktop',
                          //                   textAlign: TextAlign.center,
                          //                   style: TextStyle(
                          //                     fontSize: 16,
                          //                   ),
                          //                 ),
                          //                 const SizedBox(height: 15),
                          //                 Text(
                          //                   data[index].subscriptionName,
                          //                   style: const TextStyle(fontSize: 16),
                          //                 ),
                          //                 const SizedBox(height: 5),
                          //                 Text(
                          //                   '$currency${data[index].subscriptionPrice.toString()}',
                          //                   style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kPremiumPlanColor),
                          //                 ),
                          //                 const SizedBox(height: 5),
                          //                 Text(
                          //                   'Duration ${data[index].duration} Day',
                          //                   style: const TextStyle(color: kGreyTextColor),
                          //                 ),
                          //               ],
                          //             ),
                          //           ),
                          //         ),
                          //       );
                          //     },
                          //   ),
                          // ),
                          GestureDetector(
                            onTap: () {
                              if (selectedPlan.subscriptionName == '') {
                                EasyLoading.showError('Please Select a Plan');
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => BuyNow(
                                              subscriptionPlanModel: selectedPlan,
                                            )));
                              }
                              // UsePaypal(
                              //     sandboxMode: sandbox,
                              //     clientId: paypalClientId,
                              //     secretKey: paypalClientSecret,
                              //     returnURL: "https://samplesite.com/return",
                              //     cancelURL: "https://samplesite.com/cancel",
                              //     transactions: [
                              //       {
                              //         "amount": {
                              //           // "total": Subscription.subscriptionAmounts[Subscription.selectedItem]!['Amount'].toString(),
                              //           "total": selectedPlan.subscriptionPrice.toString(),
                              //           "currency": Subscription.currency.toString(),
                              //           "details": {
                              //             // "subtotal": Subscription.subscriptionAmounts[Subscription.selectedItem]!['Amount'].toString(),
                              //             "subtotal": selectedPlan.subscriptionPrice.toString(),
                              //             "shipping": '0',
                              //             "shipping_discount": 0
                              //           }
                              //         },
                              //         "description": "The payment transaction description.",
                              //         "item_list": {
                              //           "items": [
                              //             {
                              //               "name": "${selectedPlan.subscriptionName} Package",
                              //               "quantity": 1,
                              //               // "price": Subscription.subscriptionAmounts[Subscription.selectedItem]!['Amount'].toString(),
                              //               "price": selectedPlan.subscriptionPrice.toString(),
                              //               "currency": Subscription.currency.toString(),
                              //             }
                              //           ],
                              //         }
                              //       }
                              //     ],
                              //     note: "Payment From MaanPos app",
                              //     onSuccess: (Map params) async {
                              //
                              //     },
                              //     onError: (error) {
                              //       EasyLoading.showError('Error');
                              //     },
                              //     onCancel: (params) {
                              //       EasyLoading.showError('Cancel');
                              //     }).launch(context);
                              // PaymentPage(selectedPlan: selectedPlan, onError: (){
                              //   EasyLoading.showError("Payment error");
                              // }, totalAmount: selectedPlan.subscriptionPrice.toString()).launch(context);
                            },
                            child: Container(
                              height: 50,
                              decoration: const BoxDecoration(
                                color: kMainColor,
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                              child: const Center(
                                child: Text(
                                  'Pay Cash',
                                  style: TextStyle(fontSize: 18, color: Colors.white),
                                ),
                              ),
                            ),
                          ).visible(Subscript.customersActivePlan.subscriptionName != selectedPlan.subscriptionName),
                          // GestureDetector(
                          //   onTap: () {
                          //     // UsePaypal(
                          //     //     sandboxMode: sandbox,
                          //     //     clientId: paypalClientId,
                          //     //     secretKey: paypalClientSecret,
                          //     //     returnURL: "https://samplesite.com/return",
                          //     //     cancelURL: "https://samplesite.com/cancel",
                          //     //     transactions: [
                          //     //       {
                          //     //         "amount": {
                          //     //           // "total": Subscription.subscriptionAmounts[Subscription.selectedItem]!['Amount'].toString(),
                          //     //           "total": selectedPlan.subscriptionPrice.toString(),
                          //     //           "currency": Subscription.currency.toString(),
                          //     //           "details": {
                          //     //             // "subtotal": Subscription.subscriptionAmounts[Subscription.selectedItem]!['Amount'].toString(),
                          //     //             "subtotal": selectedPlan.subscriptionPrice.toString(),
                          //     //             "shipping": '0',
                          //     //             "shipping_discount": 0
                          //     //           }
                          //     //         },
                          //     //         "description": "The payment transaction description.",
                          //     //         "item_list": {
                          //     //           "items": [
                          //     //             {
                          //     //               "name": "${selectedPlan.subscriptionName} Package",
                          //     //               "quantity": 1,
                          //     //               // "price": Subscription.subscriptionAmounts[Subscription.selectedItem]!['Amount'].toString(),
                          //     //               "price": selectedPlan.subscriptionPrice.toString(),
                          //     //               "currency": Subscription.currency.toString(),
                          //     //             }
                          //     //           ],
                          //     //         }
                          //     //       }
                          //     //     ],
                          //     //     note: "Payment From MaanPos app",
                          //     //     onSuccess: (Map params) async {
                          //     //
                          //     //     },
                          //     //     onError: (error) {
                          //     //       EasyLoading.showError('Error');
                          //     //     },
                          //     //     onCancel: (params) {
                          //     //       EasyLoading.showError('Cancel');
                          //     //     }).launch(context);
                          //     PaymentPage(selectedPlan: selectedPlan, onError: (){
                          //       EasyLoading.showError("Payment error");
                          //     }, totalAmount: selectedPlan.subscriptionPrice.toString()).launch(context);
                          //   },
                          //   child: Container(
                          //     height: 50,
                          //     decoration: const BoxDecoration(
                          //       color: kMainColor,
                          //       borderRadius: BorderRadius.all(Radius.circular(10)),
                          //     ),
                          //     child: Center(
                          //       child: Text(
                          //         lang.S.of(context).payWithPaypal,
                          //         style: const TextStyle(fontSize: 18, color: Colors.white),
                          //       ),
                          //     ),
                          //   ),
                          // ).visible(Subscript.customersActivePlan.subscriptionName != selectedPlan.subscriptionName),
                          // GestureDetector(
                          //   onTap: () {
                          //     UsePaypal(
                          //         sandboxMode: sandbox,
                          //         clientId: paypalClientId,
                          //         secretKey: paypalClientSecret,
                          //         returnURL: "https://samplesite.com/return",
                          //         cancelURL: "https://samplesite.com/cancel",
                          //         transactions: [
                          //           {
                          //             "amount": {
                          //               "total": Subscription.subscriptionAmounts[Subscription.selectedItem]!['Amount'].toString(),
                          //               "currency": currency,
                          //               "details": {
                          //                 "subtotal": Subscription.subscriptionAmounts[Subscription.selectedItem]!['Amount'].toString(),
                          //                 "shipping": '0',
                          //                 "shipping_discount": 0
                          //               }
                          //             },
                          //             "description": "The payment transaction description.",
                          //             "item_list": {
                          //               "items": [
                          //                 {
                          //                   "name": "${Subscription.selectedItem} Package",
                          //                   "quantity": 1,
                          //                   "price": Subscription.subscriptionAmounts[Subscription.selectedItem]!['Amount'].toString(),
                          //                   "currency": currency,
                          //                 }
                          //               ],
                          //             }
                          //           }
                          //         ],
                          //         note: "Payment From Smart Biashara app",
                          //         onSuccess: (Map params) async {
                          //           try {
                          //             EasyLoading.show(status: 'Loading...', dismissOnTap: false);
                          //             final prefs = await SharedPreferences.getInstance();
                          //
                          //             await prefs.setBool('isFiveDayRemainderShown', true);
                          //
                          //             final DatabaseReference subscriptionRef =
                          //             FirebaseDatabase.instance.ref().child(constUserId).child('Subscription');
                          //
                          //             SubscriptionModel subscriptionModel = SubscriptionModel(
                          //               subscriptionName: Subscription.selectedItem,
                          //               subscriptionDate: DateTime.now().toString(),
                          //               saleNumber: Subscription.subscriptionPlansService[Subscription.selectedItem]!['Sales'].toInt(),
                          //               purchaseNumber: Subscription.subscriptionPlansService[Subscription.selectedItem]!['Purchase'].toInt(),
                          //               partiesNumber: Subscription.subscriptionPlansService[Subscription.selectedItem]!['Parties'].toInt(),
                          //               dueNumber: Subscription.subscriptionPlansService[Subscription.selectedItem]!['Due Collection'].toInt(),
                          //               duration: Subscription.subscriptionPlansService[Subscription.selectedItem]!['Duration'].toInt(),
                          //               products: Subscription.subscriptionPlansService[Subscription.selectedItem]!['Products'].toInt(),
                          //             );
                          //
                          //             await subscriptionRef.set(subscriptionModel.toJson());
                          //             EasyLoading.showSuccess('Added Successfully', duration: const Duration());
                          //           } catch (e) {
                          //             EasyLoading.dismiss();
                          //             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                          //           }
                          //           if (mounted) {
                          //             await const Home().launch(context);
                          //           }
                          //         },
                          //         onError: (error) {
                          //           EasyLoading.showError('Error');
                          //         },
                          //         onCancel: (params) {
                          //           EasyLoading.showError('Cancel');
                          //         }).launch(context);
                          //   },
                          //   child: Container(
                          //     height: 50,
                          //     decoration: const BoxDecoration(
                          //       color: kMainColor,
                          //       borderRadius: BorderRadius.all(Radius.circular(30)),
                          //     ),
                          //     child:  Center(
                          //       child: Text(
                          //         lang.S.of(context).payWithPaypal,
                          //         style: const TextStyle(fontSize: 18, color: Colors.white),
                          //       ),
                          //     ),
                          //   ),
                          // ).visible(selectedPackageValue > widget.initPackageValue),
                        ],
                      ),
                    ),
                  ],
                );
              }, error: (Object error, StackTrace? stackTrace) {
                return Text(error.toString());
              }, loading: () {
                return const Center(child: CircularProgressIndicator());
              }),
            ),
          );
        },
      ),
    );
  }
}
