import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:internet_popup/internet_popup.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../constant.dart';
import '../../model/subscription_model.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.initPackageValue == 0 ? selectedPackageValue = 2 : 0;
    InternetPopup().initialize(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Purchase Premium Plan',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: () {
                        widget.isCameBack ? Navigator.pop(context) : const Home().launch(context);
                      },
                      child: const Icon(Icons.cancel_outlined),
                    )
                  ],
                ),
                const SizedBox(height: 20),
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
                                      const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Natoque aliquet et, cur eget. Tellus sapien odio aliq.',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 16)),
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
                const Text(
                  'Buy premium Plan',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          Subscription.selectedItem = 'Month';
                          selectedPackageValue = 1;
                        });
                      },
                      child: Container(
                        height: (context.width() / 3) - 20,
                        width: (context.width() / 3) - 20,
                        decoration: BoxDecoration(
                          color: Subscription.selectedItem == 'Month' ? kPremiumPlanColor2.withOpacity(0.1) : Colors.white,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                          border: Border.all(width: 1, color: Subscription.selectedItem == 'Month' ? kPremiumPlanColor2 : kPremiumPlanColor),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Monthly',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              '\$${Subscription.subscriptionAmounts['Month']!['Amount']}',
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kPremiumPlanColor),
                            )
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          Subscription.selectedItem = 'Year';
                          selectedPackageValue = 2;
                        });
                      },
                      child: SizedBox(
                        height: (context.width() / 2.5) + 18,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Container(
                              height: (context.width() / 2.5),
                              width: (context.width() / 3) - 20,
                              decoration: BoxDecoration(
                                color: Subscription.selectedItem == 'Year' ? kPremiumPlanColor2.withOpacity(0.1) : Colors.white,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                border: Border.all(
                                  width: 1,
                                  color: Subscription.selectedItem == 'Year' ? kPremiumPlanColor2 : kPremiumPlanColor,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 15),
                                  const Text(
                                    'Mobile App +\nDesktop',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  const Text(
                                    'Yearly',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    '\$${Subscription.subscriptionAmounts['Year']!['Amount']}',
                                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kPremiumPlanColor2),
                                  ),
                                  const Text(
                                    '\$119.88',
                                    style: TextStyle(decoration: TextDecoration.lineThrough, fontSize: 14, color: Colors.grey),
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
                                child: const Center(
                                  child: Text(
                                    'Save 17%',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          Subscription.selectedItem = 'Lifetime';
                          selectedPackageValue = 3;
                        });
                      },
                      child: SizedBox(
                        height: (context.width() / 3) - 8,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Container(
                              height: (context.width() / 3) - 20,
                              width: (context.width() / 3) - 20,
                              decoration: BoxDecoration(
                                color: Subscription.selectedItem == 'Lifetime' ? kPremiumPlanColor2.withOpacity(0.1) : Colors.white,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                border: Border.all(width: 1, color: Subscription.selectedItem == 'Lifetime' ? kPremiumPlanColor2 : kPremiumPlanColor),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Lifetime\nPurchase',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '\$${Subscription.subscriptionAmounts['Lifetime']!['Amount']}',
                                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kPremiumPlanColor),
                                  ),
                                  const Text(
                                    '\$1500.00',
                                    style: TextStyle(decoration: TextDecoration.lineThrough, fontSize: 12, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: 0,
                              left: 0,
                              child: Container(
                                height: 25,
                                width: 70,
                                decoration: const BoxDecoration(
                                  color: kPremiumPlanColor,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Save 33%',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    UsePaypal(
                        sandboxMode: sandbox,
                        clientId: paypalClientId,
                        secretKey: paypalClientSecret,
                        returnURL: "https://samplesite.com/return",
                        cancelURL: "https://samplesite.com/cancel",
                        transactions: [
                          {
                            "amount": {
                              "total": (double.parse(Subscription.subscriptionAmounts[Subscription.selectedItem]!['Amount'].toString()) +
                                      ((Subscription.subscriptionAmounts[Subscription.selectedItem]!['Amount'])!.toDouble() *
                                          (double.parse(Subscription.taxAmountInPercent) / 100)))
                                  .toStringAsFixed(2),
                              "currency": Subscription.currency,
                              "details": {
                                "subtotal": Subscription.subscriptionAmounts[Subscription.selectedItem]!['Amount'],
                                "tax": (double.parse(Subscription.subscriptionAmounts[Subscription.selectedItem]!['Amount'].toString()) *
                                        (double.parse(Subscription.taxAmountInPercent) / 100))
                                    .toStringAsFixed(2),
                              }
                            },
                            "description": "SelesPro Mobile App Subscription Payment",
                            "item_list": {
                              "items": [
                                {
                                  "name": Subscription.selectedItem,
                                  "sku": "1",
                                  "price": Subscription.subscriptionAmounts[Subscription.selectedItem]!['Amount'],
                                  "quantity": "1"
                                }
                              ],
                            }
                          }
                        ],
                        note: "Payment From Salespro app",
                        onSuccess: (Map params) async {
                          try {
                            EasyLoading.show(status: 'Loading...', dismissOnTap: false);
                            final prefs = await SharedPreferences.getInstance();

                            await prefs.setBool('isFiveDayRemainderShown', true);

                            final DatabaseReference subscriptionRef =
                                FirebaseDatabase.instance.ref().child(FirebaseAuth.instance.currentUser!.uid).child('Subscription');

                            SubscriptionModel subscriptionModel = SubscriptionModel(
                              subscriptionName: Subscription.selectedItem,
                              subscriptionDate: DateTime.now().toString(),
                              saleNumber: Subscription.subscriptionPlansService[Subscription.selectedItem]!['Sales'].toInt(),
                              purchaseNumber: Subscription.subscriptionPlansService[Subscription.selectedItem]!['Purchase'].toInt(),
                              partiesNumber: Subscription.subscriptionPlansService[Subscription.selectedItem]!['Parties'].toInt(),
                              dueNumber: Subscription.subscriptionPlansService[Subscription.selectedItem]!['Due Collection'].toInt(),
                              duration: Subscription.subscriptionPlansService[Subscription.selectedItem]!['Duration'].toInt(),
                              products: Subscription.subscriptionPlansService[Subscription.selectedItem]!['Products'].toInt(),
                            );

                            await subscriptionRef.set(subscriptionModel.toJson());
                            EasyLoading.showSuccess('Added Successfully', duration: const Duration());
                          } catch (e) {
                            EasyLoading.dismiss();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                          }
                          if (mounted) {
                            await const Home().launch(context);
                          }
                        },
                        onError: (error) {
                          EasyLoading.showError('Error');
                        },
                        onCancel: (params) {
                          EasyLoading.showError('Cancel');
                        }).launch(context);
                    // showModalBottomSheet(
                    //     context: context,
                    //     builder: (BuildContext context) {
                    //       return StatefulBuilder(builder: (BuildContext context, setState) {
                    //         return Container(
                    //           decoration: const BoxDecoration(
                    //               borderRadius: BorderRadius.only(
                    //             topRight: Radius.circular(30),
                    //             topLeft: Radius.circular(30),
                    //           )),
                    //           child: Column(
                    //             mainAxisSize: MainAxisSize.min,
                    //             children: [
                    //               Padding(
                    //                 padding: const EdgeInsets.only(top: 50, bottom: 0, right: 20, left: 20),
                    //                 child: GestureDetector(
                    //                   onTap: () {
                    //                     setState(() {
                    //                       selectedPayButton = 'Stripe';
                    //                     });
                    //                   },
                    //                   child: Container(
                    //                     padding: const EdgeInsets.all(15),
                    //                     decoration: BoxDecoration(
                    //                       border: Border.all(width: 1, color: Colors.grey),
                    //                       borderRadius: const BorderRadius.all(Radius.circular(10)),
                    //                     ),
                    //                     child: Row(
                    //                       children: [
                    //                         selectedPayButton == 'Stripe'
                    //                             ? const Icon(
                    //                                 Icons.radio_button_checked,
                    //                                 color: kMainColor,
                    //                               )
                    //                             : const Icon(Icons.radio_button_off),
                    //                         const SizedBox(width: 8),
                    //                         const Text('Stripe'),
                    //                       ],
                    //                     ),
                    //                   ),
                    //                 ),
                    //               ),
                    //               Padding(
                    //                 padding: const EdgeInsets.all(20.0),
                    //                 child: GestureDetector(
                    //                   onTap: () {
                    //                     setState(() {
                    //                       selectedPayButton = 'Paypal';
                    //                     });
                    //                   },
                    //                   child: Container(
                    //                     padding: const EdgeInsets.all(15),
                    //                     decoration: BoxDecoration(
                    //                       border: Border.all(width: 1, color: Colors.grey),
                    //                       borderRadius: const BorderRadius.all(Radius.circular(10)),
                    //                     ),
                    //                     child: Row(
                    //                       children: [
                    //                         selectedPayButton == 'Paypal'
                    //                             ? const Icon(
                    //                                 Icons.radio_button_checked,
                    //                                 color: kMainColor,
                    //                               )
                    //                             : const Icon(Icons.radio_button_off),
                    //                         const SizedBox(width: 8),
                    //                         const Text('Paypal'),
                    //                       ],
                    //                     ),
                    //                   ),
                    //                 ),
                    //               ),
                    //               GestureDetector(
                    //                 onTap: () {
                    //                   selectedPayButton == 'Paypal'
                    //                       ? UsePaypal(
                    //                           sandboxMode: sandbox,
                    //                           clientId: paypalClientId,
                    //                           secretKey: paypalClientSecret,
                    //                           returnURL: "https://samplesite.com/return",
                    //                           cancelURL: "https://samplesite.com/cancel",
                    //                           transactions: [
                    //                             {
                    //                               "amount": {
                    //                                 "total": Subscription
                    //                                     .subscriptionAmounts[Subscription.selectedItem]!['Amount'],
                    //                                 "currency": currency,
                    //                                 // "details": {
                    //                                 //   "subtotal": Subscription.subscriptionAmounts[Subscription.selectedItem]!['Amount'],
                    //                                 // }
                    //                               },
                    //                               "description": "Payment From Salespro app",
                    //                             }
                    //                           ],
                    //                           note: "Payment From Salespro app",
                    //                           onSuccess: (Map params) async {
                    //                             try {
                    //                               EasyLoading.show(status: 'Loading...', dismissOnTap: false);
                    //
                    //                               final DatabaseReference subscriptionRef = FirebaseDatabase.instance
                    //                                   .ref()
                    //                                   .child(FirebaseAuth.instance.currentUser!.uid)
                    //                                   .child('Subscription');
                    //
                    //                               SubscriptionModel subscriptionModel = SubscriptionModel(
                    //                                 subscriptionName: Subscription.selectedItem,
                    //                                 subscriptionDate: DateTime.now().toString(),
                    //                                 saleNumber: Subscription
                    //                                     .subscriptionPlansService[Subscription.selectedItem]!['Sales']
                    //                                     .toInt(),
                    //                                 purchaseNumber: Subscription.subscriptionPlansService[
                    //                                         Subscription.selectedItem]!['Purchase']
                    //                                     .toInt(),
                    //                                 partiesNumber: Subscription
                    //                                     .subscriptionPlansService[Subscription.selectedItem]!['Parties']
                    //                                     .toInt(),
                    //                                 dueNumber: Subscription.subscriptionPlansService[
                    //                                         Subscription.selectedItem]!['Due Collection']
                    //                                     .toInt(),
                    //                                 duration: Subscription.subscriptionPlansService[
                    //                                         Subscription.selectedItem]!['Duration']
                    //                                     .toInt(),
                    //                                 products: Subscription.subscriptionPlansService[
                    //                                         Subscription.selectedItem]!['Products']
                    //                                     .toInt(),
                    //                               );
                    //
                    //                               await subscriptionRef.set(subscriptionModel.toJson());
                    //                               EasyLoading.showSuccess('Added Successfully',
                    //                                   duration: const Duration());
                    //                             } catch (e) {
                    //                               EasyLoading.dismiss();
                    //                               ScaffoldMessenger.of(context)
                    //                                   .showSnackBar(SnackBar(content: Text(e.toString())));
                    //                             }
                    //                             if (mounted) {
                    //                               await const Home().launch(context);
                    //                             }
                    //                           },
                    //                           onError: (error) {
                    //                             EasyLoading.showError('Error');
                    //                           },
                    //                           onCancel: (params) {
                    //                             EasyLoading.showError('Cancel');
                    //                           }).launch(context)
                    //                       : Container();
                    //                 },
                    //                 child: Padding(
                    //                   padding: const EdgeInsets.all(10.0),
                    //                   child: Container(
                    //                     height: 55,
                    //                     width: double.infinity,
                    //                     decoration: const BoxDecoration(
                    //                       color: kMainColor,
                    //                       borderRadius: BorderRadius.all(
                    //                         Radius.circular(10),
                    //                       ),
                    //                     ),
                    //                     child: const Center(
                    //                       child: Text(
                    //                         'Pay Now',
                    //                         style: TextStyle(color: Colors.white, fontSize: 20),
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         );
                    //       });
                    //     });
                  },
                  child: Container(
                    height: 60,
                    decoration: const BoxDecoration(
                      color: kMainColor,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: const Center(
                      child: Text(
                        'Pay With Paypal',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ).visible(selectedPackageValue > widget.initPackageValue),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
