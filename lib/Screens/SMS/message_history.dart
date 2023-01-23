import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/Provider/sms_history_provider.dart';
import 'package:mobile_pos/model/payment_verification_model.dart';
import 'package:mobile_pos/model/sms_model.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../constant.dart';

class MessageHistory extends StatefulWidget {
  const MessageHistory({Key? key}) : super(key: key);

  @override
  State<MessageHistory> createState() => _MessageHistoryState();
}

class _MessageHistoryState extends State<MessageHistory> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        backgroundColor: kMainColor,
        appBar: AppBar(
          backgroundColor: kMainColor,
          title: Text(
            'Message History',
            style: GoogleFonts.poppins(
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          elevation: 0.0,
        ),
        body: Container(
          alignment: Alignment.topCenter,
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30))),
          child: Consumer(builder: (_, ref, watch) {
            AsyncValue<List<SmsModel>> historyList = ref.watch(smsHistoryProvider);
            AsyncValue<List<PaymentVerificationModel>> transactionList = ref.watch(transactionHistoryProvider);
            return historyList.when(data: (history) {
              return Column(
                children: [
                  const TabBar(labelColor: Colors.black, unselectedLabelColor: kGreyTextColor, tabs: [
                    Tab(
                      text: 'Message',
                    ),
                    Tab(
                      text: 'Transaction',
                    ),
                  ]),
                  SizedBox(
                    height: context.height() / 1.2,
                    child: TabBarView(children: [
                      history.isEmpty
                          ? const Center(
                              child: Text(
                                'No History Found!',
                                style: TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.w700),
                              ),
                            )
                          : ListView.builder(
                              itemCount: history.length,
                              shrinkWrap: true,
                              padding: const EdgeInsets.all(20.0),
                              itemBuilder: (_, i) {
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 10.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(
                                      color: const Color(0xFFDCDBE5),
                                    ),
                                  ),
                                  child: ListTile(
                                    title: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          history[i].customerPhone ?? '',
                                          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 16.0),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(4.0),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(4.0),
                                            color: history[i].status! ? kMainColor.withOpacity(0.1) : const Color(0xFFFF8C34).withOpacity(0.1),
                                          ),
                                          child: Text(
                                            history[i].status! ? 'Sent' : 'Failed',
                                            style: TextStyle(color: history[i].status! ? kMainColor : const Color(0xFFFF8C34), fontSize: 12.0),
                                          ),
                                        )
                                      ],
                                    ),
                                    subtitle: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          history[i].sellerName ?? 'Date: 10 Jun 2022 - 10:30AM ',
                                          style: const TextStyle(color: kGreyTextColor),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(top: 10.0),
                                          child: Text(
                                            'View Details',
                                            style: TextStyle(color: kGreyTextColor, decoration: TextDecoration.underline),
                                          ),
                                        ).onTap(
                                          () => showDialog(
                                            context: context,
                                            builder: (context) {
                                              return Dialog(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(10.0),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text(
                                                            history[i].customerPhone ?? '',
                                                            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 16.0),
                                                          ),
                                                          Container(
                                                            padding: const EdgeInsets.all(4.0),
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(4.0),
                                                              color: history[i].status! ? kMainColor.withOpacity(0.1) : const Color(0xFFFF8C34).withOpacity(0.1),
                                                            ),
                                                            child: Text(
                                                              history[i].status! ? 'Sent' : 'Failed',
                                                              style: TextStyle(color: history[i].status! ? kMainColor : const Color(0xFFFF8C34), fontSize: 12.0),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 20.0,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(history[i].totalAmount ?? '',
                                                              style: const TextStyle(
                                                                color: kGreyTextColor,
                                                              ),
                                                              textAlign: TextAlign.start),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 20.0,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          const Expanded(
                                                            flex: 1,
                                                            child: Text(
                                                              'Date: 10 Jun 2022 - 10:30AM ',
                                                              style: TextStyle(color: kGreyTextColor),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 10.0,
                                                          ),
                                                          Expanded(
                                                            flex: 1,
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.end,
                                                              mainAxisAlignment: MainAxisAlignment.end,
                                                              children: [
                                                                Text(
                                                                  history[i].sellerName ?? '',
                                                                  style: const TextStyle(color: Colors.black),
                                                                ),
                                                                Text(
                                                                  history[i].sellerMobile ?? '',
                                                                  style: const TextStyle(color: kGreyTextColor, fontSize: 12.0),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                      transactionList.when(data: (transaction) {
                        return transaction.isEmpty
                            ? const Center(
                                child: Text(
                                  'No Transaction Found!',
                                  style: TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.w700),
                                ),
                              )
                            : ListView.builder(
                                itemCount: transaction.length,
                                shrinkWrap: true,
                                padding: const EdgeInsets.all(20.0),
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (_, i) {
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 10.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      border: Border.all(
                                        color: const Color(0xFFDCDBE5),
                                      ),
                                    ),
                                    child: ListTile(
                                      title: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            transaction[i].smsSubscriptionPlanModel.smsPackName,
                                            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 16.0),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(4.0),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(4.0),
                                              color: transaction[i].verificationStatus == 'verified' ? kMainColor.withOpacity(0.1) : const Color(0xFFFF8C34).withOpacity(0.1),
                                            ),
                                            child: Text(
                                              transaction[i].verificationStatus,
                                              style: TextStyle(color: transaction[i].verificationStatus == 'verified' ? kMainColor : const Color(0xFFFF8C34), fontSize: 12.0),
                                            ),
                                          )
                                        ],
                                      ),
                                      subtitle: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            DateTimeFormat.format(DateTime.parse(transaction[i].verificationAttemptsDate), format: DateTimeFormats.american),
                                            style: const TextStyle(color: kGreyTextColor),
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.only(top: 10.0),
                                            child: Text(
                                              'View Details',
                                              style: TextStyle(color: kGreyTextColor, decoration: TextDecoration.underline),
                                            ),
                                          ).onTap(() => showDialog(
                                              context: context,
                                              builder: (context) {
                                                return Dialog(
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(10.0),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Text(
                                                              transaction[i].smsSubscriptionPlanModel.smsPackName,
                                                              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 16.0),
                                                            ),
                                                            Container(
                                                              padding: const EdgeInsets.all(4.0),
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(4.0),
                                                                color: transaction[i].verificationStatus == 'verified' ? kMainColor.withOpacity(0.1) : const Color(0xFFFF8C34).withOpacity(0.1),
                                                              ),
                                                              child: Text(
                                                                transaction[i].verificationStatus,
                                                                style: TextStyle(color: transaction[i].verificationStatus == 'verified' ? kMainColor : const Color(0xFFFF8C34), fontSize: 12.0),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 10.0,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text('Transaction Id: ${transaction[i].transactionId}',
                                                                style: const TextStyle(
                                                                  color: kGreyTextColor,
                                                                ),
                                                                textAlign: TextAlign.start),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 10.0,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Expanded(
                                                              flex: 1,
                                                              child: Text(
                                                                DateTimeFormat.format(DateTime.parse(transaction[i].verificationAttemptsDate), format: DateTimeFormats.american),
                                                                style: const TextStyle(color: kGreyTextColor),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 10.0,
                                                            ),
                                                            Expanded(
                                                              flex: 1,
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                                mainAxisAlignment: MainAxisAlignment.end,
                                                                children: [
                                                                  Text(
                                                                    transaction[i].sellerName,
                                                                    style: const TextStyle(color: Colors.black),
                                                                  ),
                                                                  Text(
                                                                    transaction[i].paymentPhoneNumber,
                                                                    style: const TextStyle(color: kGreyTextColor, fontSize: 12.0),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }))
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                      }, error: (e, stack) {
                        return Text(e.toString());
                      }, loading: () {
                        return const CircularProgressIndicator();
                      }),
                    ]),
                  )
                ],
              );
            }, error: (e, stack) {
              return Center(
                child: Text(e.toString()),
              );
            }, loading: () {
              return const Center(
                child: CircularProgressIndicator(),
              );
            });
          }),
        ),
      ),
    );
  }
}
