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
import 'package:mobile_pos/Provider/profile_provider.dart';
import 'package:mobile_pos/Screens/SMS/send_sms_screen.dart';
import 'package:mobile_pos/model/nid_verification_model.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import '../../constant.dart';
import '../../currency.dart';

class UploadNid extends StatefulWidget {
  const UploadNid({Key? key}) : super(key: key);

  @override
  State<UploadNid> createState() => _UploadNidState();
}

class _UploadNidState extends State<UploadNid> {
  final ImagePicker _picker = ImagePicker();
  XFile? pickedImage;
  File imageFileFront = File('No File');
  String imagePathFront = 'No Data';
  File imageFileBack = File('No File');
  String imagePathBack = 'No Data';
  String frontNidUrl = '';
  String backNidUrl = '';

  Future<void> uploadFrontFile(String filePath) async {
    File file = File(filePath);
    try {
      EasyLoading.show(
        status: 'Uploading... ',
        dismissOnTap: false,
      );
      var snapshot = await FirebaseStorage.instance.ref('Customer NID Picture/${DateTime.now().millisecondsSinceEpoch}').putFile(file);
      var url = await snapshot.ref.getDownloadURL();

      setState(() {
        frontNidUrl = url.toString();
      });
    } on firebase_core.FirebaseException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.code.toString())));
    }
  }

  Future<void> uploadBackFile(String filePath) async {
    File file = File(filePath);
    try {
      var snapshot = await FirebaseStorage.instance.ref('Customer NID Picture/${DateTime.now().millisecondsSinceEpoch}').putFile(file);
      var url = await snapshot.ref.getDownloadURL();

      setState(() {
        backNidUrl = url.toString();
      });
    } on firebase_core.FirebaseException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.code.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
   return Consumer(builder: (_,ref,watch){
      final personalData = ref.watch(profileDetailsProvider);
      return personalData.when(data: (data){return Scaffold(
        backgroundColor: kMainColor,
        appBar: AppBar(
          backgroundColor: kMainColor,
          title: Text(
            lang.S.of(context).addDocumentId,
            style: GoogleFonts.poppins(
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          elevation: 0.0,
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(10.0),
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: ButtonGlobalWithoutIcon(
            buttontext: lang.S.of(context).submit,
            buttonDecoration: kButtonDecoration.copyWith(color: kMainColor, borderRadius: BorderRadius.circular(30.0)),
            onPressed: () async{
              if(imagePathFront != 'No Data' && imagePathBack != 'No Data' ){
                await uploadFrontFile(imagePathFront);
                await uploadBackFile(imagePathBack);
                NIDVerificationModel model = NIDVerificationModel(sellerName: data.companyName.toString(), sellerPhone: data.phoneNumber.toString(), sellerID: constUserId, shopName: data.companyName.toString(), nidBackPart: backNidUrl, nidFrontPart: frontNidUrl, verificationStatus: 'pending', verificationAttemptsDate: DateTime.now().toString());
                final dbRef = FirebaseDatabase.instance.ref().child('Admin Panel').child('NID Verification');
                await dbRef.push().set(model.toJson());
                EasyLoading.showSuccess('Upload Successful');
                SendSms().launch(context);
              }
            },
            buttonTextColor: Colors.white,
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Card(
                    color: Colors.white,
                    margin: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 20.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                    child: imagePathFront == 'No Data'
                        ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          height: 10.0,
                        ),
                        Image.asset(
                          'images/font_card.png',
                          height: 60.0,
                          width: 60.0,
                        ),
                         Text(
                           lang.S.of(context).fontSide,
                          style: const TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.w600),
                        ),
                         Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            lang.S.of(context).takeaNidCardToCheckYourInformation,
                            style: const TextStyle(
                              color: kGreyTextColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                      ],
                    )
                        : Image.file(
                      imageFileFront,
                      height: 150.0,
                      width: double.infinity,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: kMainColor,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.document_scanner_outlined,
                          color: Colors.white,
                        ),
                        Text(
                          imagePathFront == 'No Data' ? 'Scan Id' : 'Retake',
                          style: const TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ).onTap(() async {
                    pickedImage = await _picker.pickImage(source: ImageSource.camera);
                    setState(() {
                      imageFileFront = File(pickedImage!.path);
                      imagePathFront = pickedImage!.path;
                    });
                  }),
                ],
              ),
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Card(
                    color: Colors.white,
                    margin: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 20.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                    child: imagePathBack == 'No Data'
                        ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          height: 10.0,
                        ),
                        Image.asset(
                          'images/back_card.png',
                          height: 60.0,
                          width: 60.0,
                        ),
                         Text(
                          lang.S.of(context).backSide,
                          style: const TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.w600),
                        ),
                         Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            lang.S.of(context).takeaNidCardToCheckYourInformation,
                            style: const TextStyle(
                              color: kGreyTextColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                      ],
                    )
                        : Image.file(
                      imageFileBack,
                      height: 150.0,
                      width: double.infinity,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: kMainColor,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.document_scanner_outlined,
                          color: Colors.white,
                        ),
                        Text(
                          imagePathBack == 'No Data' ? 'Scan Id' : 'Retake',
                          style: const TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ).onTap(() async {
                    pickedImage = await _picker.pickImage(source: ImageSource.camera);
                    setState(() {
                      imageFileBack = File(pickedImage!.path);
                      imagePathBack = pickedImage!.path;
                    });
                  }),
                ],
              ),
            ],
          ),
        ),
      );}, error: (e,stack){
        return Scaffold(
          body: Center(child: Text(e.toString()),),
        );
      }, loading: (){
        return const Scaffold(
          body: Center(child: CircularProgressIndicator(),),
        );
      });
    });
  }
}
