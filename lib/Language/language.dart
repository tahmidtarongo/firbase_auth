import 'package:flag/flag_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constant.dart';
import '../invoice_constant.dart';
import 'language_provider.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;

class Language extends StatefulWidget {
  const Language({Key? key}) : super(key: key);

  @override
  State<Language> createState() => _LanguageState();
}

class _LanguageState extends State<Language> {
  List<String> baseFlagsCode = [
    'US',
    'CN',
  ];
  List<String> countryList = [
    'English',
    'Chinese',
  ];
  String selectedCountry = 'English';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        toolbarHeight: 90,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(30.0),
            bottomLeft: Radius.circular(30.0),
          ),
        ),
        elevation: 0.0,
        title: Text(
          lang.S.of(context).language,
          style: kTextStyle.copyWith(color: Colors.white),
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15, top: 15),
          child: ListView.builder(
              itemCount: countryList.length,
              itemBuilder: (_, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Container(
                    // decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(10),
                    //     color: Colors.white,
                    //     border: Border.all(color: kBorderColorTextField, width: 0.3),
                    //     boxShadow: const [BoxShadow(color: kDarkWhite, offset: Offset(5, 5), spreadRadius: 2.0, blurRadius: 10.0)]),
                    child: ListTile(
                      horizontalTitleGap: 5,
                      onTap: () {
                        setState(
                              () {
                            selectedCountry = countryList[index];
                            selectedCountry == 'English'
                                ? context.read<LanguageChangeProvider>().changeLocale("en")
                                : selectedCountry == "Chinese"
                                ? context.read<LanguageChangeProvider>().changeLocale("zh")
                                : context.read<LanguageChangeProvider>().changeLocale("en");
                          },
                        );
                      },
                      leading: Flag.fromString(
                        baseFlagsCode[index],
                        height: 25,
                        width: 30,
                      ),
                      title: Text(countryList[index]),
                      trailing: selectedCountry == countryList[index]
                          ? const Icon(Icons.radio_button_checked, color: Colors.black)
                          : const Icon(
                        Icons.radio_button_off,
                        color: Color(0xff9F9F9F),
                      ),
                    ),
                  ),
                );
              })),
    );
  }
}
