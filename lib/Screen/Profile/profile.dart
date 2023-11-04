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

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.blue,
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, value, child) {
          return value.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Visibility(
                          visible: value.profile.isAdmin ?? false,
                          child: const Icon(
                            Icons.shield,
                            size: 30,
                          )),
                      const SizedBox(height: 20),
                      TextFormField(
                        initialValue: value.profile.name,
                        decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Name'),
                        readOnly: true,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        initialValue: value.profile.address,
                        decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Address'),
                        readOnly: true,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        initialValue: value.profile.phoneNumber,
                        decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Phone Number'),
                        readOnly: true,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        initialValue: value.profile.landMark,
                        decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'landMark'),
                        readOnly: true,
                      ),
                    ],
                  ),
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
