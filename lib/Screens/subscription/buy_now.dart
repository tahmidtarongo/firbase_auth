// ignore_for_file: use_build_context_synchronously
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_pos/constant.dart';
import 'dart:io';
import '../../Provider/profile_provider.dart';
import '../../currency.dart';
import '../../model/subscription_plan_model.dart';

class BuyNow extends StatefulWidget {
  const BuyNow({Key? key, required this.subscriptionPlanModel}) : super(key: key);

  final SubscriptionPlanModel subscriptionPlanModel;

  @override
  State<BuyNow> createState() => _BuyNowState();
}

class _BuyNowState extends State<BuyNow> {
  Future<File?> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      return File(result.files.single.path!);
    } else {
      // User canceled the picker
      return null;
    }
  }

  Future<void> uploadFile(String filePath) async {
    File file = File(filePath);
    try {
      EasyLoading.show(
        status: 'Uploading... ',
        dismissOnTap: false,
      );
      var snapshot = await FirebaseStorage.instance.ref('Subscription Attachment/${DateTime.now().millisecondsSinceEpoch}').putFile(file);
      var url = await snapshot.ref.getDownloadURL();

      data.attachment = url.toString();
    } catch (e) {
      EasyLoading.dismiss();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  // Future<void> uploadFile(File file) async {
  //   try {
  //     var request = http.MultipartRequest('POST', Uri.parse('YOUR_UPLOAD_URL'));
  //     request.files.add(await http.MultipartFile.fromPath('file', file.path));
  //
  //     var response = await request.send();
  //
  //     if (response.statusCode == 200) {
  //       // File upload successful
  //       print('File uploaded');
  //     } else {
  //       // Handle errors
  //       print('File upload failed with status code ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     // Handle exceptions
  //     print('Error uploading file: $e');
  //   }
  // }

  SubscriptionRequestModel data = SubscriptionRequestModel(
    subscriptionPlanModel: SubscriptionPlanModel(
        dueNumber: 0, duration: 0, offerPrice: 0, partiesNumber: 0, products: 0, purchaseNumber: 0, saleNumber: 0, subscriptionName: '', subscriptionPrice: 00),
    transactionNumber: '',
    note: '',
    attachment: '',
    userId: constUserId,
    businessCategory: '',
    companyName: '',
    countryName: '',
    language: '',
    phoneNumber: '',
    pictureUrl: '',
  );
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    data.subscriptionPlanModel = widget.subscriptionPlanModel;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, __) {
      final userProfileDetails = ref.watch(profileDetailsProvider);

      return Scaffold(
        backgroundColor: kMainColor,
        appBar: AppBar(
          backgroundColor: kMainColor,
          title: const Text(
            'Buy',
          ),
          elevation: 0.0,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: userProfileDetails.when(data: (details) {
          data.countryName = details.countryName ?? '';
          data.language = details.language ?? '';
          data.pictureUrl = details.pictureUrl ?? '';
          data.companyName = details.companyName ?? '';
          data.businessCategory = details.businessCategory ?? '';
          data.phoneNumber = details.phoneNumber ?? '';
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Container(
                height: MediaQuery.of(context).size.height - 120,
                decoration: const BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)), color: Colors.white),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bank Information',
                        style: kTextStyle.copyWith(fontWeight: FontWeight.bold, color: kTitleColor, fontSize: 18),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                              flex: 4,
                              child: Text(
                                'Bank Name',
                                style: kTextStyle.copyWith(color: kGreyTextColor),
                              )),
                          Expanded(
                              child: Text(
                            ':',
                            style: kTextStyle.copyWith(color: kGreyTextColor),
                          )),
                          Expanded(
                              flex: 5,
                              child: Text(
                                'Diamond Trust Bank',
                                style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                              )),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                              flex: 4,
                              child: Text(
                                'Branch Name',
                                style: kTextStyle.copyWith(color: kGreyTextColor),
                              )),
                          Expanded(
                              child: Text(
                            ':',
                            style: kTextStyle.copyWith(color: kGreyTextColor),
                          )),
                          Expanded(
                              flex: 5,
                              child: Text(
                                'Masaki Branch',
                                style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                              )),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              flex: 4,
                              child: Text(
                                'Account Name',
                                style: kTextStyle.copyWith(color: kGreyTextColor),
                              )),
                          Expanded(
                              child: Text(
                            ':',
                            style: kTextStyle.copyWith(color: kGreyTextColor),
                          )),
                          Expanded(
                              flex: 5,
                              child: Text(
                                'Primezone Business Solutions',
                                style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                              )),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                              flex: 4,
                              child: Text(
                                'Account Number',
                                style: kTextStyle.copyWith(color: kGreyTextColor),
                              )),
                          Expanded(
                              child: Text(
                            ':',
                            style: kTextStyle.copyWith(color: kGreyTextColor),
                          )),
                          Expanded(
                              flex: 5,
                              child: Text(
                                '0151635001',
                                style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                              )),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                              flex: 4,
                              child: Text(
                                'SWIFT Code',
                                style: kTextStyle.copyWith(color: kGreyTextColor),
                              )),
                          Expanded(
                              child: Text(
                            ':',
                            style: kTextStyle.copyWith(color: kGreyTextColor),
                          )),
                          Expanded(
                              flex: 5,
                              child: Text(
                                'DTKETZTZ',
                                style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                              )),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              flex: 4,
                              child: Text(
                                'Bank Account Currency',
                                style: kTextStyle.copyWith(color: kGreyTextColor),
                              )),
                          Expanded(
                              child: Text(
                            ':',
                            style: kTextStyle.copyWith(color: kGreyTextColor),
                          )),
                          Expanded(
                              flex: 5,
                              child: Text(
                                'TSH',
                                style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                              )),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        onChanged: (value) {
                          data.transactionNumber = value;
                        },
                        decoration: kInputDecoration.copyWith(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: 'Transaction ID',
                            hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                            labelStyle: kTextStyle.copyWith(fontWeight: FontWeight.bold, color: kTitleColor),
                            hintText: 'Enter transaction  id'),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        onChanged: (value) {
                          data.note = value;
                        },
                        decoration: kInputDecoration.copyWith(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                            labelText: 'Note',
                            labelStyle: kTextStyle.copyWith(fontWeight: FontWeight.bold, color: kTitleColor),
                            hintText: 'Enter Note'),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        onTap: () async {
                          File? selectedFile = await pickFile();
                          if (selectedFile != null) {
                            data.attachment = selectedFile.path;
                            // await uploadFile(selectedFile);
                          }
                        },
                        readOnly: true,
                        decoration: kInputDecoration.copyWith(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: 'Upload Document',
                            labelStyle: kTextStyle.copyWith(fontWeight: FontWeight.bold, color: kTitleColor),
                            hintText: 'upload file',
                            hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                            suffixIcon: const Icon(
                              FeatherIcons.upload,
                              color: kGreyTextColor,
                            )),
                      ),
                      const SizedBox(height: 100)
                    ],
                  ),
                ),
              ),
            ),
          );
        }, error: (e, stack) {
          return Text(e.toString());
        }, loading: () {
          return const CircularProgressIndicator();
        }),
        bottomNavigationBar: Container(
          height: 70,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                'images/success.png',
                                height: 85,
                                width: 85,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Thank You!',
                                style: kTextStyle.copyWith(fontWeight: FontWeight.bold, color: kTitleColor, fontSize: 20),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'We will review the payment & approve it within 1-2 hours.',
                                style: kTextStyle.copyWith(color: kGreyTextColor),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      });
                });
              },
              child: GestureDetector(
                onTap: () async {
                  if (data.transactionNumber == '') {
                    EasyLoading.showError('Please Enter Transaction Number');
                  } else {
                    data.attachment == '' ? null : await uploadFile(data.attachment);
                    final DatabaseReference ref = FirebaseDatabase.instance.ref().child('Admin Panel').child('Subscription Update Request');
                    ref.keepSynced(true);
                    ref.push().set(data.toJson());
                    EasyLoading.showSuccess('Request has been send');
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: kMainColor),
                  child: Text(
                    'Submit',
                    style: kTextStyle.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}

class SubscriptionRequestModel {
  SubscriptionPlanModel subscriptionPlanModel;
  late String transactionNumber, note, attachment, userId;
  String phoneNumber;
  String companyName;
  String pictureUrl;
  String businessCategory;
  String language;
  String countryName;

  SubscriptionRequestModel({
    required this.subscriptionPlanModel,
    required this.transactionNumber,
    required this.note,
    required this.attachment,
    required this.userId,
    required this.phoneNumber,
    required this.businessCategory,
    required this.companyName,
    required this.pictureUrl,
    required this.countryName,
    required this.language,
  });

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'id': DateTime.now().toString(),
        'userId': userId,
        'subscriptionName': subscriptionPlanModel.subscriptionName,
        'subscriptionDuration': subscriptionPlanModel.duration,
        'subscriptionPrice': subscriptionPlanModel.offerPrice > 0 ? subscriptionPlanModel.offerPrice : subscriptionPlanModel.subscriptionPrice,
        'transactionNumber': transactionNumber,
        'note': note,
        'status': 'pending',
        'approvedDate': '',
        'attachment': attachment,
        'phoneNumber': phoneNumber,
        'companyName': companyName,
        'pictureUrl': pictureUrl,
        'businessCategory': businessCategory,
        'language': language,
        'countryName': countryName,
      };
}
