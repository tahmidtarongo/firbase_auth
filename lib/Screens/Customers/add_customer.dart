// ignore: import_of_legacy_library_into_null_safe
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_pos/GlobalComponents/button_global.dart';
import 'package:mobile_pos/Screens/Customers/Model/customer_model.dart';
import 'package:mobile_pos/constant.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Provider/customer_provider.dart';

class AddCustomer extends StatefulWidget {
  const AddCustomer({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AddCustomerState createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {
  String radioItem = 'Retailer';
  String groupValue = '';
  // ignore: prefer_typing_uninitialized_variables
  var dialogContext;
  bool expanded = false;
  String customerName = 'Guest';
  String phoneNumber = '000';
  String customerAddress = 'Not Provided';
  String emailAddress = 'Not Provided';
  String dueAmount = '0';
  String profilePicture =
      'https://firebasestorage.googleapis.com/v0/b/maanpos.appspot.com/o/Profile%20Picture%2Fblank-profile-picture-973460_1280.webp?alt=media&token=3578c1e0-7278-4c03-8b56-dd007a9befd3';
  final ImagePicker _picker = ImagePicker();
  bool showProgress = false;
  double progress = 0.0;
  bool isPhoneAlready = false;
  XFile? pickedImage;
  TextEditingController phoneText = TextEditingController();
  File imageFile = File('No File');
  String imagePath = 'No Data';
  Future<void> uploadFile(String filePath) async {
    File file = File(filePath);
    try {
      EasyLoading.show(
        status: 'Uploading... ',
        dismissOnTap: false,
      );
      var snapshot = await FirebaseStorage.instance.ref('Customer Picture/${DateTime.now().millisecondsSinceEpoch}').putFile(file);
      var url = await snapshot.ref.getDownloadURL();

      setState(() {
        profilePicture = url.toString();
      });
    } on firebase_core.FirebaseException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.code.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainColor,
      appBar: AppBar(
        backgroundColor: kMainColor,
        title: Text(
          'Add Contact',
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
        child: Consumer(builder: (context, ref, __) {
          final customerData = ref.watch(customerProvider);

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: AppTextField(
                      controller: phoneText,
                      textFieldType: TextFieldType.PHONE,
                      onChanged: (value) {
                        setState(() {
                          phoneNumber = value;
                        });
                      },
                      decoration: const InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: 'Phone Number',
                        hintText: '01767 432556',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: AppTextField(
                      textFieldType: TextFieldType.NAME,
                      onChanged: (value) {
                        setState(() {
                          customerName = value;
                        });
                      },
                      decoration: const InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: 'Name',
                        hintText: 'John Doe',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile(
                          contentPadding: EdgeInsets.zero,
                          groupValue: groupValue,
                          title: Text(
                            'Retailer',
                            maxLines: 1,
                            style: GoogleFonts.poppins(
                              fontSize: 12.0,
                            ),
                          ),
                          value: 'Retailer',
                          onChanged: (value) {
                            setState(() {
                              groupValue = value.toString();
                              radioItem = value.toString();
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile(
                          contentPadding: EdgeInsets.zero,
                          groupValue: groupValue,
                          title: Text(
                            'Dealer',
                            maxLines: 1,
                            style: GoogleFonts.poppins(
                              fontSize: 12.0,
                            ),
                          ),
                          value: 'Dealer',
                          onChanged: (value) {
                            setState(() {
                              groupValue = value.toString();
                              radioItem = value.toString();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile(
                          contentPadding: EdgeInsets.zero,
                          activeColor: kMainColor,
                          groupValue: groupValue,
                          title: Text(
                            'Wholesaler',
                            maxLines: 1,
                            style: GoogleFonts.poppins(
                              fontSize: 12.0,
                            ),
                          ),
                          value: 'Wholesaler',
                          onChanged: (value) {
                            setState(() {
                              groupValue = value.toString();
                              radioItem = value.toString();
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile(
                          contentPadding: EdgeInsets.zero,
                          activeColor: kMainColor,
                          groupValue: groupValue,
                          title: Text(
                            'Supplier',
                            maxLines: 1,
                            style: GoogleFonts.poppins(
                              fontSize: 12.0,
                            ),
                          ),
                          value: 'Supplier',
                          onChanged: (value) {
                            setState(() {
                              groupValue = value.toString();
                              radioItem = value.toString();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Visibility(
                    visible: showProgress,
                    child: const CircularProgressIndicator(
                      color: kMainColor,
                      strokeWidth: 5.0,
                    ),
                  ),
                  ExpansionPanelList(
                    expansionCallback: (int index, bool isExpanded) {
                      setState(() {
                        expanded == false ? expanded = true : expanded = false;
                      });
                    },
                    animationDuration: const Duration(milliseconds: 500),
                    elevation: 0,
                    dividerColor: Colors.white,
                    children: [
                      ExpansionPanel(
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextButton(
                                child: Text(
                                  'More Info',
                                  style: GoogleFonts.poppins(
                                    fontSize: 20.0,
                                    color: kMainColor,
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    expanded == false ? expanded = true : expanded = false;
                                  });
                                },
                              ),
                            ],
                          );
                        },
                        body: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12.0),
                                        ),
                                        // ignore: sized_box_for_whitespace
                                        child: Container(
                                          height: 200.0,
                                          width: MediaQuery.of(context).size.width - 80,
                                          child: Center(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                GestureDetector(
                                                  onTap: () async {
                                                    pickedImage = await _picker.pickImage(source: ImageSource.gallery);
                                                    setState(() {
                                                      imageFile = File(pickedImage!.path);
                                                      imagePath = pickedImage!.path;
                                                    });
                                                    Future.delayed(const Duration(milliseconds: 100), () {
                                                      Navigator.pop(context);
                                                    });
                                                  },
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      const Icon(
                                                        Icons.photo_library_rounded,
                                                        size: 60.0,
                                                        color: kMainColor,
                                                      ),
                                                      Text(
                                                        'Gallery',
                                                        style: GoogleFonts.poppins(
                                                          fontSize: 20.0,
                                                          color: kMainColor,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 40.0,
                                                ),
                                                GestureDetector(
                                                  onTap: () async {
                                                    pickedImage = await _picker.pickImage(source: ImageSource.camera);
                                                    setState(() {
                                                      imageFile = File(pickedImage!.path);
                                                      imagePath = pickedImage!.path;
                                                    });
                                                    Future.delayed(const Duration(milliseconds: 100), () {
                                                      Navigator.pop(context);
                                                    });
                                                  },
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      const Icon(
                                                        Icons.camera,
                                                        size: 60.0,
                                                        color: kGreyTextColor,
                                                      ),
                                                      Text(
                                                        'Camera',
                                                        style: GoogleFonts.poppins(
                                                          fontSize: 20.0,
                                                          color: kGreyTextColor,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    height: 120,
                                    width: 120,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black54, width: 1),
                                      borderRadius: const BorderRadius.all(Radius.circular(120)),
                                      image: imagePath == 'No Data'
                                          ? DecorationImage(
                                              image: NetworkImage(profilePicture),
                                              fit: BoxFit.cover,
                                            )
                                          : DecorationImage(
                                              image: FileImage(imageFile),
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      height: 35,
                                      width: 35,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.white, width: 2),
                                        borderRadius: const BorderRadius.all(Radius.circular(120)),
                                        color: kMainColor,
                                      ),
                                      child: const Icon(
                                        Icons.camera_alt_outlined,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 15),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: AppTextField(
                                textFieldType: TextFieldType.EMAIL,
                                onChanged: (value) {
                                  setState(() {
                                    emailAddress = value;
                                  });
                                },
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                  labelText: 'Email Address',
                                  hintText: 'example@example.com',
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: AppTextField(
                                textFieldType: TextFieldType.NAME,
                                maxLines: 2,
                                onChanged: (value) {
                                  setState(() {
                                    customerAddress = value;
                                  });
                                },
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    labelText: 'Address',
                                    hintText: 'Placentia, California(CA), 92870'),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: AppTextField(
                                textFieldType: TextFieldType.PHONE,
                                onChanged: (value) {
                                  setState(() {
                                    dueAmount = value;
                                  });
                                },
                                maxLines: 2,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    labelText: 'Opening Balance',
                                    hintText: 'Amount'),
                              ),
                            ),
                          ],
                        ),
                        isExpanded: expanded,
                      ),
                    ],
                  ),
                  ButtonGlobalWithoutIcon(
                      buttontext: 'Save',
                      buttonDecoration: kButtonDecoration.copyWith(color: kMainColor, borderRadius: const BorderRadius.all(Radius.circular(30))),
                      onPressed: () async {
                        for (var element in customerData.value!) {
                          if (element.phoneNumber == phoneNumber) {
                            EasyLoading.showError('Phone number already exist');
                            isPhoneAlready = true;
                            phoneText.clear();
                          }
                        }
                        Future.delayed(const Duration(milliseconds: 500), () async {
                          if (isPhoneAlready) {
                          } else {
                            try {
                              EasyLoading.show(status: 'Loading...', dismissOnTap: false);
                              imagePath == 'No Data' ? null : await uploadFile(imagePath);
                              // ignore: no_leading_underscores_for_local_identifiers
                              final DatabaseReference _customerInformationRef = FirebaseDatabase.instance
                                  // ignore: deprecated_member_use
                                  .reference()
                                  .child(FirebaseAuth.instance.currentUser!.uid)
                                  .child('Customers');
                              CustomerModel customerModel = CustomerModel(
                                customerName,
                                phoneNumber,
                                radioItem,
                                profilePicture,
                                emailAddress,
                                customerAddress,
                                dueAmount,
                              );
                              await _customerInformationRef.push().set(customerModel.toJson());

                              ///________Subscription_____________________________________________________
                              decreaseSubscriptionSale();

                              EasyLoading.showSuccess('Added Successfully!');
                              ref.refresh(customerProvider);
                              Future.delayed(const Duration(milliseconds: 100), () {
                                Navigator.pop(context);
                              });
                            } catch (e) {
                              EasyLoading.dismiss();
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                            }
                          }
                        });
                      },
                      buttonTextColor: Colors.white),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  void decreaseSubscriptionSale() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final ref = FirebaseDatabase.instance.ref('$userId/Subscription/partiesNumber');
    var data = await ref.once();
    int beforeSale = int.parse(data.snapshot.value.toString());
    int afterSale = beforeSale - 1;
    FirebaseDatabase.instance.ref('$userId/Subscription').update({'partiesNumber': afterSale});
  }
}
