import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_popup/internet_popup.dart';
import 'package:mobile_pos/GlobalComponents/button_global.dart';
import 'package:mobile_pos/Screens/Expense/expense_category_list.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../constant.dart';

// ignore: must_be_immutable
class AddExpense extends StatefulWidget {
  AddExpense({Key? key, @required this.catName}) : super(key: key);
  // ignore: prefer_typing_uninitialized_variables
  var catName;

  @override
  // ignore: library_private_types_in_public_api
  _AddExpenseState createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  String dropdownValue = '';
  final dateController = TextEditingController();

  @override
  void initState(){
    widget.catName == null ? dropdownValue = 'Fashion' : dropdownValue = widget.catName;
    super.initState();
    InternetPopup().initialize(context: context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Expense',
          style: GoogleFonts.poppins(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: AppTextField(
                  textFieldType: TextFieldType.NAME,
                  controller: TextEditingController(),
                  decoration: const InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'Customer Name',
                    hintText: 'Brandon',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  height: 60.0,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(color: kGreyTextColor),
                  ),
                  child: GestureDetector(
                    onTap: (){
                      const ExpenseCategoryList().launch(context);
                    },
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 10.0,
                        ),
                        Text(dropdownValue),
                        const Spacer(),
                        const Icon(Icons.keyboard_arrow_down),
                        const SizedBox(
                          width: 10.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: AppTextField(
                        textFieldType: TextFieldType.NAME,
                        readOnly: true,
                        onTap: () async {
                          var date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2100));
                          dateController.text =
                              date.toString().substring(0, 10);
                        },
                        controller: dateController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            floatingLabelBehavior:
                            FloatingLabelBehavior.always,
                            labelText: 'Start Date',
                            hintText: 'Pick Start Date'),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: AppTextField(
                        textFieldType: TextFieldType.OTHER,
                        readOnly: true,
                        onTap: () async {
                          var date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2100));
                          dateController.text =
                              date.toString().substring(0, 10);
                        },
                        controller: dateController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            floatingLabelBehavior:
                            FloatingLabelBehavior.always,
                            labelText: 'End Date',
                            hintText: 'Pick End Date'),
                      ),
                    ),
                  ),
                ],
              ),
              ButtonGlobal(
                buttontext: 'Continue',
                buttonDecoration: kButtonDecoration.copyWith(color: kMainColor),
                onPressed: () {
                  Navigator.pushNamed(context, '/Expense');
                },
                iconWidget: Icons.arrow_forward,
                iconColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
