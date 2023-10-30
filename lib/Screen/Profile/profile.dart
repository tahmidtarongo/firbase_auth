import 'package:flutter/material.dart';
import 'package:mobile_pos/Providers/student_provider.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Provider.of<ProfileProvider>(context, listen: false).getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, value, child) {
          return value.isLoading
              ? const CircularProgressIndicator()
              : Column(
                  children: [
                    Text(value.profile.name ?? ''),
                    Text(value.profile.address ?? ''),
                    Text(value.profile.phoneNumber ?? ''),
                    Text(value.profile.landMark ?? ''),
                  ],
                );
        },
      ),
      // body: Builder(
      //   builder: (context,) {
      //     return Column(
      //       children: [],
      //     );
      //   }
      // ),
    );
  }
}
