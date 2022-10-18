import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_popup/internet_popup.dart';
import 'package:mobile_pos/Screens/Home/components/grid_items.dart';
import 'package:mobile_pos/Screens/Profile%20Screen/profile_details.dart';
import 'package:mobile_pos/constant.dart';
import 'package:mobile_pos/model/subscription_model.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Provider/profile_provider.dart';
import '../../subscription.dart';
import '../Shimmers/home_screen_appbar_shimmer.dart';
import '../subscription/package_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Color> color = [
    const Color(0xffEDFAFF),
    const Color(0xffFFF6ED),
    const Color(0xffEAFFEA),
    const Color(0xffEAFFEA),
    const Color(0xffEDFAFF),
    const Color(0xffFFF6ED),
    const Color(0xffFFF6ED),
  ];

  String customerPackage = '';
  List<Map<String, dynamic>> sliderList = [
    {
      "icon": 'images/banner1.png',
    },
    {
      "icon": 'images/banner2.png',
    }
  ];
  PageController pageController = PageController(initialPage: 0);

  void subscriptionRemainder() async {
    final prefs = await SharedPreferences.getInstance();

    final userId = FirebaseAuth.instance.currentUser!.uid;
    DatabaseReference ref = FirebaseDatabase.instance.ref('$userId/Subscription');

    final model = await ref.get();
    var data = jsonDecode(jsonEncode(model.value));
    final dataModel = SubscriptionModel.fromJson(data);
    setState(() {
      customerPackage = dataModel.subscriptionName;
    });

    final remainTime = DateTime.parse(dataModel.subscriptionDate).difference(DateTime.now());

    if (dataModel.subscriptionName != 'Lifetime') {
      if (remainTime.inHours.abs().isBetween((dataModel.duration * 24) - 24, dataModel.duration * 24)) {
        await prefs.setBool('isFiveDayRemainderShown', false);
        setState(() {
          isExpiringInOneDays = true;
          isExpiringInFiveDays = false;
        });
      } else if (remainTime.inHours.abs().isBetween((dataModel.duration * 24) - 120, dataModel.duration * 24)) {
        setState(() {
          isExpiringInFiveDays = true;
          isExpiringInOneDays = false;
        });
      }

      final bool? isFiveDayRemainderShown = prefs.getBool('isFiveDayRemainderShown');

      if (isExpiringInFiveDays && isFiveDayRemainderShown == false) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              child: SizedBox(
                height: 200,
                width: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Your Package Will Expire in 5 Day',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () async {
                        await prefs.setBool('isFiveDayRemainderShown', true);
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
      if (isExpiringInOneDays) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Your Package Will Expire Today\n\nPlease Purchase again',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Column(
                        children: [
                          TextButton(
                            onPressed: () {
                              const PackageScreen().launch(context);
                            },
                            child: const Text('Purchase'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Cancel',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    subscriptionRemainder();
    InternetPopup().initialize(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer(builder: (_, ref, __) {
        final userProfileDetails = ref.watch(profileDetailsProvider);

        return Scaffold(
          resizeToAvoidBottomInset: true,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: userProfileDetails.when(data: (details) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              const ProfileDetails().launch(context);
                            },
                            child: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                image: DecorationImage(image: NetworkImage(details.pictureUrl ?? ''), fit: BoxFit.cover),
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 15.0,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                details.companyName ?? '',
                                style: GoogleFonts.poppins(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                '$customerPackage Plan',
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          // Container(
                          //   height: 40.0,
                          //   width: 86.0,
                          //   decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(10.0),
                          //     color: Color(0xFFD9DDE3).withOpacity(0.5),
                          //   ),
                          //   child: Center(
                          //     child: Text(
                          //       '\$ 450',
                          //       style: GoogleFonts.poppins(
                          //         fontSize: 20.0,
                          //         color: Colors.black,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          // SizedBox(
                          //   width: 10.0,
                          // ),
                          Container(
                            height: 40.0,
                            width: 40.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: kDarkWhite,
                            ),
                            child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  EasyLoading.showInfo('Coming Soon');
                                },
                                child: const Icon(
                                  Icons.notifications_active,
                                  color: kMainColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }, error: (e, stack) {
                    return Text(e.toString());
                  }, loading: () {
                    return const HomeScreenAppBarShimmer();
                  }),
                ),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  child: GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    childAspectRatio: 0.9,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 10,
                    crossAxisCount: 3,
                    children: List.generate(
                      freeIcons.length,
                      (index) => HomeGridCards(
                        gridItems: freeIcons[index],
                        color: color[index],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20
                ),
                Container(
                  height: 1,
                  width: double.infinity,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(
                  height: 10
                ),

                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Row(
                //     children: [
                //       SizedBox(
                //         width: 10.0,
                //       ),
                //       Text(
                //         'Business',
                //         style: GoogleFonts.poppins(
                //           color: Colors.black,
                //           fontWeight: FontWeight.bold,
                //           fontSize: 20.0,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // Container(
                //   padding: EdgeInsets.all(10.0),
                //   child: GridView.count(
                //     physics: NeverScrollableScrollPhysics(),
                //     shrinkWrap: true,
                //     childAspectRatio: 1,
                //     crossAxisCount: 4,
                //     children: List.generate(
                //       businessIcons.length,
                //       (index) => HomeGridCards(
                //         gridItems: businessIcons[index],
                //       ),
                //     ),
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        'What\'s New',
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                    ],
                  ),
                ),
                // ignore: sized_box_for_whitespace
                Container(
                  height: 150,
                  width: 320,
                  child: PageView.builder(
                    pageSnapping: true,
                    itemCount: sliderList.length,
                    controller: pageController,
                    onPageChanged: (int index) {},
                    itemBuilder: (_, index) {
                      return GestureDetector(
                        onTap: () {
                          const PackageScreen().launch(context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              sliderList[index]['icon'],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 30),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Row(
                //     children: [
                //       SizedBox(
                //         width: 10.0,
                //       ),
                //       Text(
                //         'Enterprise',
                //         style: GoogleFonts.poppins(
                //           color: Colors.black,
                //           fontWeight: FontWeight.bold,
                //           fontSize: 20.0,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // Container(
                //   padding: EdgeInsets.all(10.0),
                //   child: GridView.count(
                //     physics: NeverScrollableScrollPhysics(),
                //     shrinkWrap: true,
                //     childAspectRatio: 1,
                //     crossAxisCount: 4,
                //     children: List.generate(
                //       enterpriseIcons.length,
                //       (index) => HomeGridCards(
                //         gridItems: enterpriseIcons[index],
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class HomeGridCards extends StatefulWidget {
  const HomeGridCards({Key? key, required this.gridItems, required this.color}) : super(key: key);
  final GridItems gridItems;
  final Color color;

  @override
  State<HomeGridCards> createState() => _HomeGridCardsState();
}

class _HomeGridCardsState extends State<HomeGridCards> {
  Future<bool> subscriptionChecker({
    required String item,
  }) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final DatabaseReference subscriptionRef = FirebaseDatabase.instance.ref().child(FirebaseAuth.instance.currentUser!.uid).child('Subscription');
    DatabaseReference ref = FirebaseDatabase.instance.ref('$userId/Subscription');
    final model = await ref.get();
    var data = jsonDecode(jsonEncode(model.value));
    Subscription.selectedItem = SubscriptionModel.fromJson(data).subscriptionName;
    final dataModel = SubscriptionModel.fromJson(data);
    final remainTime = DateTime.parse(dataModel.subscriptionDate).difference(DateTime.now());

    if (dataModel.subscriptionName == 'Free') {
      if (remainTime.inHours.abs() > 720) {
        SubscriptionModel subscriptionModel = SubscriptionModel(
          subscriptionName: 'Free',
          subscriptionDate: DateTime.now().toString(),
          saleNumber: Subscription.subscriptionPlansService['Free']!['Sales'].toInt(),
          purchaseNumber: Subscription.subscriptionPlansService['Free']!['Purchase'].toInt(),
          partiesNumber: Subscription.subscriptionPlansService['Free']!['Parties'].toInt(),
          dueNumber: Subscription.subscriptionPlansService['Free']!['Due Collection'].toInt(),
          duration: 30,
          products: Subscription.subscriptionPlansService['Free']!['Products'].toInt(),
        );
        await subscriptionRef.set(subscriptionModel.toJson());
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isFiveDayRemainderShown', true);
      } else if (item == 'Sales' && dataModel.saleNumber <= 0) {
        return false;
      } else if (item == 'Parties' && dataModel.partiesNumber <= 0) {
        return false;
      } else if (item == 'Purchase' && dataModel.purchaseNumber <= 0) {
        return false;
      } else if (item == 'Products' && dataModel.products <= 0) {
        return false;
      } else if (item == 'Due List' && dataModel.dueNumber <= 0) {
        return false;
      }
    } else if (dataModel.subscriptionName == 'Month') {
      if (remainTime.inHours.abs() > 720) {
        SubscriptionModel subscriptionModel = SubscriptionModel(
          subscriptionName: 'Free',
          subscriptionDate: DateTime.now().toString(),
          saleNumber: Subscription.subscriptionPlansService['Free']!['Sales'].toInt(),
          purchaseNumber: Subscription.subscriptionPlansService['Free']!['Purchase'].toInt(),
          partiesNumber: Subscription.subscriptionPlansService['Free']!['Parties'].toInt(),
          dueNumber: Subscription.subscriptionPlansService['Free']!['Due Collection'].toInt(),
          duration: 30,
          products: Subscription.subscriptionPlansService['Free']!['Products'].toInt(),
        );
        await subscriptionRef.set(subscriptionModel.toJson());
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isFiveDayRemainderShown', true);
      } else {
        return true;
      }
    } else if (dataModel.subscriptionName == 'Year') {
      if (remainTime.inHours.abs() > 8760) {
        SubscriptionModel subscriptionModel = SubscriptionModel(
          subscriptionName: 'Free',
          subscriptionDate: DateTime.now().toString(),
          saleNumber: Subscription.subscriptionPlansService['Free']!['Sales'].toInt(),
          purchaseNumber: Subscription.subscriptionPlansService['Free']!['Purchase'].toInt(),
          partiesNumber: Subscription.subscriptionPlansService['Free']!['Parties'].toInt(),
          dueNumber: Subscription.subscriptionPlansService['Free']!['Due Collection'].toInt(),
          duration: 30,
          products: Subscription.subscriptionPlansService['Free']!['Products'].toInt(),
        );
        await subscriptionRef.set(subscriptionModel.toJson());

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isFiveDayRemainderShown', true);
      } else {
        return true;
      }
      EasyLoading.dismiss();
    } else if (dataModel.subscriptionName == 'Lifetime') {
      return true;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_unnecessary_containers
    return Consumer(builder: (context, ref, __) {
      return Card(
        elevation: 2,
        color: widget.color,
        child: Column(
          children: [
            TextButton(
              onPressed: () async {
                setState(() {});

                await subscriptionChecker(item: widget.gridItems.title)
                    ? Navigator.of(context).pushNamed('/${widget.gridItems.title}')
                    : EasyLoading.showError('Update your plan first,\nyour limit is over.');
              },
              child: Image(
                height: 70,
                width: 70,
                image: AssetImage(
                  widget.gridItems.icon.toString(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.gridItems.title.toString(),
                style: const TextStyle(fontSize: 16),
                maxLines: 1,
              ),
            ),
          ],
        ),
      );
    });
  }
}
