import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constant.dart';

class MessageHistory extends StatefulWidget {
  const MessageHistory({Key? key}) : super(key: key);

  @override
  State<MessageHistory> createState() => _MessageHistoryState();
}

class _MessageHistoryState extends State<MessageHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: SingleChildScrollView(
          child: ListView.builder(
            itemCount: 10,
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
                child: const ListTile(
                  title: Text(
                    '01746238362',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 16.0),
                  ),
                  subtitle: Text(
                    'Date: 10 Jun 2022 - 10:30AM ',
                    style: TextStyle(color: kGreyTextColor),
                  ),
                  trailing: Text(
                    'Sent ',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
