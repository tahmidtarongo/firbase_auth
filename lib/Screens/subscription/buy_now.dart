import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:mobile_pos/constant.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class BuyNow extends StatefulWidget {
  const BuyNow({Key? key}) : super(key: key);

  @override
  State<BuyNow> createState() => _BuyNowState();
}

class _BuyNowState extends State<BuyNow> {

  List<String> bankList=[
    'Bank',
    'Card',
  ];
  String selectedAccount='Bank';
  Future<File?> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      return File(result.files.single.path!);
    } else {
      // User canceled the picker
      return null;
    }
  }
  Future<void> uploadFile(File file) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('YOUR_UPLOAD_URL'));
      request.files.add(await http.MultipartFile.fromPath('file', file.path));

      var response = await request.send();

      if (response.statusCode == 200) {
        // File upload successful
        print('File uploaded');
      } else {
        // Handle errors
        print('File upload failed with status code ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions
      print('Error uploading file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainColor,
      appBar: AppBar(
        backgroundColor: kMainColor,
        title: const Text('Buy',),
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30)
              ),
              color: Colors.white
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                  height: 60,
                  child: FormField(
                      builder: (FormFieldState<dynamic>state){
                        return InputDecorator(
                            decoration: kInputDecoration.copyWith(
                              labelText: 'Payment Method',
                              labelStyle: kTextStyle.copyWith(color: kTitleColor,fontWeight: FontWeight.bold)
                            ),
                        child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                               value: selectedAccount,
                                items: bankList.map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e))).toList(),
                                onChanged: (String?newValue){
                                 setState(() {
                                   selectedAccount=newValue!;
                                 });
                                })),);
                      }),
              ),
                  const SizedBox(height: 20,),
                  Text('Bank Information',style: kTextStyle.copyWith(fontWeight: FontWeight.bold,color: kTitleColor,fontSize: 18),),
                  const SizedBox(height: 20,),
                  Row(
                    children: [
                      Expanded(
                          flex: 4,
                          child: Text('Bank Name',style: kTextStyle.copyWith(color: kGreyTextColor),)),
                      Expanded(

                          child: Text(':',style: kTextStyle.copyWith(color: kGreyTextColor),)),
                      Expanded(
                        flex: 5,
                          child: Text('Diamond Trust Bank',style: kTextStyle.copyWith(color: kTitleColor,fontWeight: FontWeight.bold),)),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    children: [
                      Expanded(
                          flex: 4,
                          child: Text('Branch Name',style: kTextStyle.copyWith(color: kGreyTextColor),)),
                      Expanded(

                          child: Text(':',style: kTextStyle.copyWith(color: kGreyTextColor),)),
                      Expanded(
                          flex: 5,
                          child: Text('Masaki Branch',style: kTextStyle.copyWith(color: kTitleColor,fontWeight: FontWeight.bold),)),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          flex: 4,
                          child: Text('Account Name',style: kTextStyle.copyWith(color: kGreyTextColor),)),
                      Expanded(

                          child: Text(':',style: kTextStyle.copyWith(color: kGreyTextColor),)),
                      Expanded(
                          flex: 5,
                          child: Text('Primezone Business Solutions',style: kTextStyle.copyWith(color: kTitleColor,fontWeight: FontWeight.bold),)),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    children: [
                      Expanded(
                          flex: 4,
                          child: Text('Account Number',style: kTextStyle.copyWith(color: kGreyTextColor),)),
                      Expanded(

                          child: Text(':',style: kTextStyle.copyWith(color: kGreyTextColor),)),
                      Expanded(
                          flex: 5,
                          child: Text('0151635001',style: kTextStyle.copyWith(color: kTitleColor,fontWeight: FontWeight.bold),)),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    children: [
                      Expanded(
                          flex: 4,
                          child: Text('SWIFT Code',style: kTextStyle.copyWith(color: kGreyTextColor),)),
                      Expanded(

                          child: Text(':',style: kTextStyle.copyWith(color: kGreyTextColor),)),
                      Expanded(
                          flex: 5,
                          child: Text('DTKETZTZ',style: kTextStyle.copyWith(color: kTitleColor,fontWeight: FontWeight.bold),)),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          flex: 4,
                          child: Text('Bank Account Currency',style: kTextStyle.copyWith(color: kGreyTextColor),)),
                      Expanded(

                          child: Text(':',style: kTextStyle.copyWith(color: kGreyTextColor),)),
                      Expanded(
                          flex: 5,
                          child: Text('TSH',style: kTextStyle.copyWith(color: kTitleColor,fontWeight: FontWeight.bold),)),
                    ],
                  ),
                  const SizedBox(height: 30,),
                  TextFormField(
                    decoration: kInputDecoration.copyWith(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: 'Transaction ID',
                        hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                      labelStyle: kTextStyle.copyWith(fontWeight: FontWeight.bold,color: kTitleColor),
                      hintText: 'Enter transaction  id'
                    ),
                  ),
                  const SizedBox(height: 20,),
                  TextFormField(
                    decoration: kInputDecoration.copyWith(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                        labelText: 'Note',
                        labelStyle: kTextStyle.copyWith(fontWeight: FontWeight.bold,color: kTitleColor),
                        hintText: 'Enter Note'
                    ),
                  ),
                  const SizedBox(height: 20,),
                  TextFormField(
                    onTap: ()async{
                      File? selectedFile = await pickFile();
                      if (selectedFile != null) {
                        await uploadFile(selectedFile);
                      }
                    },
                    readOnly: true,
                    decoration: kInputDecoration.copyWith(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: 'Upload Document',
                        labelStyle: kTextStyle.copyWith(fontWeight: FontWeight.bold,color: kTitleColor),
                        hintText: 'upload file',
                        hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
                        suffixIcon: const Icon(FeatherIcons.upload,color: kGreyTextColor,)
                    ),
                  ),
                  const SizedBox(height:100,)
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 70,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: GestureDetector(
            onTap: (){
              setState(() {
                showDialog(
                    context: context,
                    builder: (BuildContext context){
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset('images/success.png',height: 85,width: 85,),
                            const SizedBox(height: 10,),
                            Text('Thank You!',style: kTextStyle.copyWith(fontWeight: FontWeight.bold,color: kTitleColor,fontSize: 20),),
                            const SizedBox(height: 5,),
                            Text('We will review the payment & approve it within 1-2 hours.',style: kTextStyle.copyWith(color: kGreyTextColor),textAlign: TextAlign.center,),
                          ],
                        ),
                      );
                    });
              });
            },
            child: Container(
              alignment: Alignment.center,
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: kMainColor
              ),
              child: Text('Submit',style: kTextStyle.copyWith(fontWeight: FontWeight.bold),),
            ),
          ),
        ),
      ),
    );
  }
}
