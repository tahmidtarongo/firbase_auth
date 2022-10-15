import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/GlobalComponents/otp_form.dart';
import 'package:mobile_pos/constant.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'OTP',
                  style: GoogleFonts.poppins(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    "Put the OTP number below sent to your email rieadstore@gmail.com",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: kGreyTextColor,
                      fontSize: 20.0,
                    ),
                  ),
                ),
                OtpForm(pressed:  (){
                  Navigator.pushNamed(context, '/success');
                },),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Didn\'t get any code?',
                      style: GoogleFonts.poppins(
                        color: kGreyTextColor,
                        fontSize: 15.0,
                      ),
                    ),
                    TextButton(
                      onPressed: null,
                      child: Text(
                        'Resend Code',
                        style: GoogleFonts.poppins(
                          color: kMainColor,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
