// ignore_for_file: unused_result

import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/Provider/customer_provider.dart';
import 'package:mobile_pos/Provider/homepage_image_provider.dart';
import 'package:mobile_pos/Screens/Home/components/grid_items.dart';
import 'package:mobile_pos/Screens/Profile%20Screen/profile_details.dart';
import 'package:mobile_pos/constant.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import '../../Provider/due_transaction_provider.dart';
import '../../Provider/profile_provider.dart';
import '../../Provider/transactions_provider.dart';
import '../../currency.dart';
import '../../model/subscription_model.dart';
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
  bool checkPermission({required String item}) {
    if (item == 'Sales' && finalUserRoleModel.salePermission) {
      return true;
    } else if (item == 'Parties' && finalUserRoleModel.partiesPermission) {
      return true;
    } else if (item == 'Purchase' && finalUserRoleModel.purchasePermission) {
      return true;
    } else if (item == 'Products' && finalUserRoleModel.productPermission) {
      return true;
    } else if (item == 'Due List' && finalUserRoleModel.dueListPermission) {
      return true;
    } else if (item == 'Stock' && finalUserRoleModel.stockPermission) {
      return true;
    } else if (item == 'Reports' && finalUserRoleModel.reportsPermission) {
      return true;
    } else if (item == 'Sales List' && finalUserRoleModel.salesListPermission) {
      return true;
    } else if (item == 'Purchase List' && finalUserRoleModel.purchaseListPermission) {
      return true;
    } else if (item == 'Loss/Profit' && finalUserRoleModel.lossProfitPermission) {
      return true;
    } else if (item == 'Expense' && finalUserRoleModel.addExpensePermission) {
      return true;
    }
    return false;
  }
  List<Color> color = [
    const Color(0xffEDFAFF),
    const Color(0xffFFF6ED),
    const Color(0xffEAFFEA),
    const Color(0xffEAFFEA),
    const Color(0xffEDFAFF),
    const Color(0xffFFF6ED),
    const Color(0xffFFF3FB),
    const Color(0xffFFF4F4),
    const Color(0xffEDFAFF),
    const Color(0xffEDFAFF),
    const Color(0xffEAFFEA),
    const Color(0xffFFF6ED),
    // const Color(0xffFFF6ED),
  ];
  List<Map<String, dynamic>> sliderList = [
    {
      "icon": 'images/banner1.png',
    },
    {
      "icon": 'images/banner2.png',
    }
  ];
  PageController pageController = PageController(
    initialPage: 0,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    freeIcons=getFreeIcons(context: context);
    return SafeArea(
      child: Consumer(builder: (_, ref, __) {
        final userProfileDetails = ref.watch(profileDetailsProvider);
        final homePageImageProvider = ref.watch(homepageImageProvider);
        return Scaffold(
          backgroundColor: kMainColor,
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
                              isSubUser ? null : const ProfileDetails().launch(context);
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
                          const SizedBox(width: 15.0),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isSubUser ? '${details.companyName ?? ''} [$subUserTitle]' : details.companyName ?? '',
                                style: GoogleFonts.poppins(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '${Subscription.selectedItem} Plan',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
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
                          //       '$currency 450',
                          //       style: GoogleFonts.p(
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
                            ),
                            child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  EasyLoading.showInfo('Coming Soon');
                                },
                                child: const Icon(
                                  Icons.notifications_none_rounded,
                                  color: Colors.white,
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
                  alignment: Alignment.topCenter,
                  decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30))),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        child: GridView.count(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          childAspectRatio: 0.85,
                          crossAxisSpacing: 4,
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
                      const SizedBox(height: 20),
                      Container(
                        height: 1,
                        width: double.infinity,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 10),

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

                      homePageImageProvider.when(data: (images) {
                        if (images.isNotEmpty) {
                          return SizedBox(
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  lang.S.of(context).whatsNew,
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    GestureDetector(
                                      child: const Icon(Icons.keyboard_arrow_left),
                                      onTap: () {
                                        pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.linear);
                                      },
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      height: 180,
                                      width: 310,
                                      child: PageView.builder(
                                        pageSnapping: true,
                                        itemCount: images.length,
                                        controller: pageController,
                                        itemBuilder: (_, index) {
                                          if (images[index].imageUrl.contains('https://firebasestorage.googleapis.com')) {
                                            return GestureDetector(
                                              onTap: () {
                                                const PackageScreen().launch(context);
                                              },
                                              child: Image(
                                                image: NetworkImage(
                                                  images[index].imageUrl,
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                            );
                                          } else {
                                            YoutubePlayerController videoController = YoutubePlayerController(
                                              flags: const YoutubePlayerFlags(
                                                autoPlay: false,
                                                mute: false,
                                              ),
                                              initialVideoId: images[index].imageUrl,
                                            );
                                            return YoutubePlayer(
                                              controller: videoController,
                                              showVideoProgressIndicator: true,
                                              onReady: () {},
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                    GestureDetector(
                                      child: const Icon(Icons.keyboard_arrow_right),
                                      onTap: () {
                                        pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.linear);
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 30),
                              ],
                            ),
                          );
                        } else {
                          return Container(
                            padding: const EdgeInsets.all(10),
                            height: 180,
                            width: 320,
                            decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('image/banner1.png'))),
                          );
                        }
                      }, error: (e, stack) {
                        return Container(
                          padding: const EdgeInsets.all(10),
                          height: 180,
                          width: 320,
                          decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('image/banner1.png'))),
                        );
                      }, loading: () {
                        return const CircularProgressIndicator();
                      }),

                      // ignore: sized_box_for_whitespace

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
    final DatabaseReference subscriptionRef = FirebaseDatabase.instance.ref().child(constUserId).child('Subscription');
    DatabaseReference ref = FirebaseDatabase.instance.ref('$constUserId/Subscription');
    ref.keepSynced(true);
    subscriptionRef.keepSynced(true);

    bool boolValue = true;

    await ref.get().then((value) async {
      final dataModel = SubscriptionModel.fromJson(jsonDecode(jsonEncode(value.value)));
      final remainTime = DateTime.parse(dataModel.subscriptionDate).difference(DateTime.now());
      for (var element in Subscription.subscriptionPlan) {
        if (dataModel.subscriptionName == element.subscriptionName) {
          if (remainTime.inHours.abs() > element.duration * 24) {
            Subscription.freeSubscriptionModel.subscriptionDate = DateTime.now().toString();
            subscriptionRef.set(Subscription.freeSubscriptionModel.toJson());
            final prefs = await SharedPreferences.getInstance();
            await prefs.setBool('isFiveDayRemainderShown', true);
          } else if (item == 'Sales' && dataModel.saleNumber <= 0 && dataModel.saleNumber != -202) {
            boolValue = false;
          } else if (item == 'Parties' && dataModel.partiesNumber <= 0 && dataModel.partiesNumber != -202) {
            boolValue = false;
          } else if (item == 'Purchase' && dataModel.purchaseNumber <= 0 && dataModel.purchaseNumber != -202) {
            boolValue = false;
          } else if (item == 'Products' && dataModel.products <= 0 && dataModel.products != -202) {
            boolValue = false;
          } else if (item == 'Due List' && dataModel.dueNumber <= 0 && dataModel.dueNumber != -202) {
            boolValue = false;
          }
        }
      }
    });
    return boolValue;
  }
  bool checkPermission({required String item}) {
    if (item == 'Sales' && finalUserRoleModel.salePermission) {
      return true;
    } else if (item == 'Parties' && finalUserRoleModel.partiesPermission) {
      return true;
    } else if (item == 'Purchase' && finalUserRoleModel.purchasePermission) {
      return true;
    } else if (item == 'Products' && finalUserRoleModel.productPermission) {
      return true;
    } else if (item == 'Due List' && finalUserRoleModel.dueListPermission) {
      return true;
    } else if (item == 'Stock' && finalUserRoleModel.stockPermission) {
      return true;
    } else if (item == 'Reports' && finalUserRoleModel.reportsPermission) {
      return true;
    } else if (item == 'Sales List' && finalUserRoleModel.salesListPermission) {
      return true;
    } else if (item == 'Purchase List' && finalUserRoleModel.purchaseListPermission) {
      return true;
    } else if (item == 'Loss/Profit' && finalUserRoleModel.lossProfitPermission) {
      return true;
    } else if (item == 'Expense' && finalUserRoleModel.addExpensePermission) {
      return true;
    }
    return false;
  }
  @override
  Widget build(BuildContext context) {
    // ignore: avoid_unnecessary_containers
    return Consumer(builder: (context, ref, __) {
      return Card(
        elevation: 1,
        color: widget.color,
        child: Column(
          children: [
            TextButton(
              onPressed: () async {
                print(widget.gridItems.title);
                ref.refresh(customerProvider);
                ref.refresh(dueTransactionProvider);
                ref.refresh(purchaseTransitionProvider);
                ref.refresh(transitionProvider);
                isSubUser
                    ? checkPermission(item: widget.gridItems.title)
                    ? await subscriptionChecker(item: widget.gridItems.title)
                    ? Navigator.of(context).pushNamed('/${widget.gridItems.route}')
                    : EasyLoading.showError('Update your plan first,\nyour limit is over.')
                    : EasyLoading.showError('Sorry, you have no permission to access this service')
                    :await Subscription.subscriptionChecker(item: widget.gridItems.title)
                    ? Navigator.of(context).pushNamed('/${widget.gridItems.route}')
                    : EasyLoading.showError('Update your plan first,\nyour limit is over.');
              },
              child: Column(
                children: [
                  Image(
                    height: 70,
                    width: 70,
                    image: AssetImage(
                      widget.gridItems.icon.toString(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.gridItems.title.toString(),
                      style: const TextStyle(fontSize: 14, color: Colors.black),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
