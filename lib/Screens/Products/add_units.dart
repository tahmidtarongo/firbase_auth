import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_popup/internet_popup.dart';
import 'package:mobile_pos/GlobalComponents/button_global.dart';
import 'package:mobile_pos/Screens/Products/Model/unit_model.dart';
import 'package:mobile_pos/constant.dart';
import 'package:nb_utils/nb_utils.dart';

class AddUnits extends StatefulWidget {
  const AddUnits({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AddUnitsState createState() => _AddUnitsState();
}

class _AddUnitsState extends State<AddUnits> {
  bool showProgress = false;
  late String unitsName;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    InternetPopup().initialize(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Image(
              image: AssetImage('images/x.png'),
            )),
        title: Text(
          'Add Unit',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 20.0,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Visibility(
              visible: showProgress,
              child: const CircularProgressIndicator(
                color: kMainColor,
                strokeWidth: 5.0,
              ),
            ),
            AppTextField(
              textFieldType: TextFieldType.NAME,
              onChanged: (value) {
                setState(() {
                  unitsName = value;
                });
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'kg',
                floatingLabelBehavior: FloatingLabelBehavior.always,
                labelText: 'Unit name',
              ),
            ),
            ButtonGlobalWithoutIcon(
              buttontext: 'Save',
              buttonDecoration: kButtonDecoration.copyWith(color: kMainColor),
              onPressed: () async {
                setState(() {
                  showProgress = true;
                });
                // ignore: no_leading_underscores_for_local_identifiers
                final DatabaseReference _unitInformationRef =
                    // ignore: deprecated_member_use
                    FirebaseDatabase.instance.reference().child(FirebaseAuth.instance.currentUser!.uid).child('Units');
                UnitModel unitModel = UnitModel(unitsName);
                await _unitInformationRef.push().set(unitModel.toJson());
                setState(() {
                  showProgress = false;
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Data Saved Successfully")));
                });

                // Navigator.pushNamed(context, '/otp');
              },
              buttonTextColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
