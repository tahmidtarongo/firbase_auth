import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../constant.dart';

class LiveChatSupport extends StatefulWidget {
  const LiveChatSupport({Key? key}) : super(key: key);

  @override
  State<LiveChatSupport> createState() => _LiveChatSupportState();
}

class _LiveChatSupportState extends State<LiveChatSupport> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kMainColor,
        body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Card(
                  elevation: 0.0,
                  color: kMainColor,
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'Feedback',
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                height: context.height(),
                decoration:
                    const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30))),
                child: Column(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              width: 150.0,
                              height: 200.0,
                              decoration: BoxDecoration(color: const Color(0xFF0165E1), borderRadius: BorderRadius.circular(10.0)),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    LineIcons.facebook_f,
                                    color: Colors.white,
                                    size: 40.0,
                                  ),
                                  SizedBox(
                                    height: 6.0,
                                  ),
                                  Text(
                                    'Follow Us On\nFacebook',
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              width: 150.0,
                              height: 200.0,
                              decoration: BoxDecoration(color: Colors.pinkAccent, borderRadius: BorderRadius.circular(10.0)),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    LineIcons.instagram,
                                    color: Colors.white,
                                    size: 50.0,
                                  ),
                                  SizedBox(
                                    height: 6.0,
                                  ),
                                  Text(
                                    'Follow Us On\nInstagram',
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Center(
                              child: Container(
                                width: 150.0,
                                height: 200.0,
                                decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10.0)),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.play_circle,
                                      color: Colors.white,
                                      size: 50.0,
                                    ),
                                    SizedBox(
                                      height: 6.0,
                                    ),
                                    Text(
                                      'Subscribe To Our\nYoutube',
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: const [
                            ListTile(
                              leading: CircleAvatar(radius: 30.0,child: Icon(Icons.whatsapp,color: Colors.white,),),
                              title: Text('Call For Emergency Support',style: TextStyle(color: Colors.grey,fontSize: 14.0),),
                              subtitle: Text('+8801712022529',style: TextStyle(color: Colors.black,fontSize: 18.0,fontWeight: FontWeight.bold),),
                            ),
                            SizedBox(height: 10.0,),
                            ListTile(
                              leading: CircleAvatar(radius: 30.0,child: Icon(Icons.messenger,color: Colors.white,),),
                              title: Text('Live Chat Support',style: TextStyle(color: Colors.black,fontSize: 18.0,fontWeight: FontWeight.bold),),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
