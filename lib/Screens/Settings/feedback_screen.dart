import 'dart:io';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mobile_pos/GlobalComponents/button_global.dart';
import 'package:mobile_pos/Screens/Home/home.dart';
import 'package:mobile_pos/model/feedback_model.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../constant.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({Key? key}) : super(key: key);

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  XFile? pickedImage;
  String productPicture =
      'https://firebasestorage.googleapis.com/v0/b/maanpos.appspot.com/o/Customer%20Picture%2FNo_Image_Available.jpeg?alt=media&token=3de0d45e-0e4a-4a7b-b115-9d6722d5031f';
  File imageFile = File('No File');
  String imagePath = 'No Data';
  TextEditingController feedbackTitleController = TextEditingController();
  TextEditingController feedbackDescriptionController = TextEditingController();

  Future<void> uploadFile(String filePath) async {
    File file = File(filePath);
    try {
      EasyLoading.show(
        status: 'Uploading... ',
        dismissOnTap: false,
      );
      var snapshot = await FirebaseStorage.instance.ref('Product Picture/${DateTime.now().millisecondsSinceEpoch}').putFile(file);
      var url = await snapshot.ref.getDownloadURL();

      setState(() {
        productPicture = url.toString();
      });
    } on firebase_core.FirebaseException catch (e) {
      EasyLoading.dismiss();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.code.toString())));
    }
  }
  bool validateAndSave() {
    final form = globalKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kMainColor,
        body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Card(
                  elevation: 0.0,
                  color: kMainColor,
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'Feedback',
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                height: context.height(),
                decoration:
                    const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30))),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20.0,
                      ),
                      Form(
                        key: globalKey,
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            TextFormField(
                              keyboardType: TextInputType.text,
                              controller: feedbackTitleController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                labelText: 'Title',
                                hintText: 'Enter your feedback title',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Title can\'n be empty';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              keyboardType: TextInputType.text,
                              maxLines: 10,
                              controller: feedbackDescriptionController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Description',
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                hintText: 'Enter your description here',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Description can\'n be empty';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          const SizedBox(height: 10),
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
                                            image: NetworkImage(productPicture),
                                            fit: BoxFit.cover,
                                          )
                                        : DecorationImage(
                                            image: FileImage(imageFile),
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                                Container(
                                  height: 120,
                                  width: 120,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black54, width: 1),
                                    borderRadius: const BorderRadius.all(Radius.circular(120)),
                                    image: DecorationImage(
                                      image: FileImage(imageFile),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  // child: imageFile.path == 'No File' ? null : Image.file(imageFile),
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
                          const SizedBox(height: 10),
                          ButtonGlobalWithoutIcon(
                              buttontext: 'Submit',
                              buttonDecoration: kButtonDecoration.copyWith(color: kMainColor),
                              onPressed: () async{
                               if(validateAndSave()){
                                 EasyLoading.show(status: 'Loading...', dismissOnTap: false);

                                 bool result = await InternetConnectionChecker().hasConnection;

                                 result ? imagePath == 'No Data' ? null : await uploadFile(imagePath) : null;
                                 var ref = FirebaseDatabase.instance.ref().child('Admin Panel').child('Feedback List');
                                 ref.keepSynced(true);
                                 FeedbackModel feedbackModel = FeedbackModel(
                                   feedbackTitle: feedbackTitleController.text,
                                   feedbackDescription: feedbackDescriptionController.text,
                                   pictureUrl: productPicture
                                 );
                                 ref.push().set(feedbackModel.toJson());
                                 EasyLoading.showSuccess('Added Successfully', duration: const Duration(milliseconds: 1000));
                                 Home().launch(context,isNewTask: true);
                               }


                              },
                              buttonTextColor: Colors.white)
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
