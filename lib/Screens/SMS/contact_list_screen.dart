import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:mobile_pos/Screens/SMS/send_sms_screen.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../GlobalComponents/button_global.dart';
import '../../constant.dart';

class ContactListScreen extends StatefulWidget {
  const ContactListScreen({Key? key}) : super(key: key);

  @override
  State<ContactListScreen> createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  List<Contact> _contacts = [];

  @override
  void initState() {
    super.initState();
    _fetchContacts();
  }

  Future _fetchContacts() async {
    await Permission.contacts.request();
    final contacts = await ContactsService.getContacts(withThumbnails: false);
    setState(() => _contacts = contacts);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        color: Colors.white,
        child: ButtonGlobal(
          iconWidget: Icons.add,
          buttontext: 'Continue',
          iconColor: Colors.white,
          buttonDecoration: kButtonDecoration.copyWith(color: kMainColor, borderRadius: const BorderRadius.all(Radius.circular(30))),
          onPressed: () {
            const SendSms().launch(context);
          },
        ),
      ).visible(selectedNumbers.isNotEmpty),
      appBar: AppBar(
        title: const Text('Select Contacts',style: TextStyle(color: Colors.white),),
        iconTheme: const IconThemeData(color: Colors.white),
        automaticallyImplyLeading: false,
        backgroundColor: kMainColor,
        elevation: 0.0,
        actions: [
          const Icon(Icons.close,size: 30.0,color: Colors.white,).onTap(() => const SendSms().launch(context)),
          const SizedBox(width: 20.0,)
        ],
      ),
      body: _body(),
    );
  }

  Widget _body() {
    if (_contacts.isEmpty) return const Center(child: CircularProgressIndicator());
    if (_contacts.isEmpty) return const Center(child: CircularProgressIndicator());
    return ListView.builder(
      itemCount: _contacts.length,
      itemBuilder: (_, i) {
        return CheckboxListTile(
          value: selectedNumbers.contains(_contacts[i].phones?.first.value),
          onChanged: (val) {
            setState(() {
              selectedNumbers.contains(_contacts[i].phones!.first.value) ? selectedNumbers.remove(_contacts[i].phones![0].value) : selectedNumbers.add(_contacts[i].phones![0].value!);
            });
          },
          controlAffinity: ListTileControlAffinity.trailing,
          secondary: CircleAvatar(
            backgroundColor: kMainColor,
            child: Text(
              _contacts[i].displayName!.substring(0, 1),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
          ),
          title: Text(
            _contacts[i].displayName!,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16.0,
            ),
          ),
          subtitle: Text(
            _contacts[i].phones!.isNotEmpty ? _contacts[i].phones!.first.value! : '',
            style: const TextStyle(color: kGreyTextColor),
          ),
        );
      },
    );
  }
}
