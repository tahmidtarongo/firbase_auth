import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../constant.dart';



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
  
  
  
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainColor,
      appBar: AppBar(
        backgroundColor: kMainColor,
        title: Text(
          'Add Document ID',
          style: GoogleFonts.poppins(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0.0,
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
                  margin: const EdgeInsets.only(left: 10.0,right: 10.0,top: 10.0,bottom: 20.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)
                  ),
                  child: imagePathFront == 'No Data'
                      ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 10.0,),
                      Image.asset('images/font_card.png',height: 60.0,width: 60.0,),
                      const Text('Front side',style: TextStyle(color: Colors.black,fontSize: 18.0,fontWeight: FontWeight.w600),),
                      const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text('Take an identity card to check your information',style: TextStyle(color: kGreyTextColor,),textAlign: TextAlign.center,),
                      ),
                      const SizedBox(height: 30.0,),
                    ],
                  ) : Image.file(imageFileFront,height: 150.0,width: double.infinity,),
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
                      const Icon(Icons.document_scanner_outlined,color: Colors.white,),
                      Text(imagePathFront == 'No Data' ? 'Scan Id' : 'Retake',style: const TextStyle(color: Colors.white),)
                    ],
                  ),
                ).onTap(() async{
                  pickedImage = await _picker.pickImage(source: ImageSource.camera);
                  setState(() {
                    imageFileFront = File(pickedImage!.path);
                    imagePathFront = pickedImage!.path;
                  });
                }),
              ],
            ),
            SizedBox(height: 50.0,),
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Card(
                  color: Colors.white,
                  margin: const EdgeInsets.only(left: 10.0,right: 10.0,top: 10.0,bottom: 20.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)
                  ),
                  child:  imagePathBack == 'No Data'
                      ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 10.0,),
                      Image.asset('images/back_card.png',height: 60.0,width: 60.0,),
                      const Text('Back side',style: TextStyle(color: Colors.black,fontSize: 18.0,fontWeight: FontWeight.w600),),
                      const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text('Take an identity card to check your information',style: TextStyle(color: kGreyTextColor,),textAlign: TextAlign.center,),
                      ),
                      const SizedBox(height: 30.0,),
                    ],
                  ) : Image.file(imageFileBack,height: 150.0,width: double.infinity,),
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
                      const Icon(Icons.document_scanner_outlined,color: Colors.white,),
                      Text(imagePathBack == 'No Data'
                          ? 'Scan Id' : 'Retake',style: const TextStyle(color: Colors.white),)
                    ],
                  ),
                ).onTap(() async{
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
    );
  }
}
