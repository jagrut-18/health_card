import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_card/screens/doctor_profile.dart';
import 'package:health_card/screens/login.dart';
import 'package:health_card/screens/profile_page.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class DoctorHomePage extends StatefulWidget {
  final String uid;

  const DoctorHomePage({Key key, @required this.uid}) : super(key: key);
  @override
  _DoctorHomePageState createState() => _DoctorHomePageState();
}

class _DoctorHomePageState extends State<DoctorHomePage> {
  String doctorName = '';

  bool invalidQR = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text('Home',
              style:
                  Theme.of(context).textTheme.headline1.copyWith(fontSize: 20)),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.exit_to_app,
                  color: Colors.black,
                ),
                onPressed: () {
                  FirebaseAuth.instance.signOut().then((value) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                        (route) => false);
                  });
                })
          ],
        ),
        body: StreamBuilder(
            stream: Firestore.instance
                .collection('doctors')
                .document(widget.uid)
                .snapshots(),
            builder: (context, snapshot) {
              doctorName =
                  snapshot.hasData ? 'Dr. ' + snapshot.data['doctorName'] : '';
              return Center(
                child: snapshot.hasData
                    ? Column(
                        children: <Widget>[
                          Image.asset('assets/doctor_anim.gif'),
                          SizedBox(
                            height: 20,
                          ),
                          Text('Dr. ' + snapshot.data['doctorName'],
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1
                                  .copyWith(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 20,
                          ),
                          invalidQR
                              ? Text(
                                  'Invalid QR code',
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption
                                      .copyWith(fontSize: 16),
                                )
                              : Container(),
                          RaisedButton(
                              color: Color(0xff1051BF),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                child: Text(
                                  'Scan QR code',
                                  style: Theme.of(context).textTheme.headline2,
                                ),
                              ),
                              onPressed: () {
                                scanCode();
                              }),
                          RaisedButton(
                              color: Colors.green[200],
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                child: Text(
                                  'Your Profile',
                                  style: Theme.of(context).textTheme.headline2,
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DoctorProfile(
                                              uid: widget.uid,
                                            )));
                              }),
                        ],
                      )
                    : CircularProgressIndicator(),
              );
            }),
      ),
    );
  }

  void scanCode() async {
    scanner.scan().then((result) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProfilePage(
                    uid: result,
                    fromScan: true,
                    doctorName: doctorName,
                  )));
      // Firestore.instance.collection('users').getDocuments().then((snapshot) {
      //   if (snapshot.documents.contains(result)) {
      //     setState(() {
      //       invalidQR = false;
      //     });
      //     Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //             builder: (context) => ProfilePage(
      //                   uid: result,
      //                   fromScan: true,
      //                   doctorName: doctorName,
      //                 )));
      //   } else {
      //     setState(() {
      //       invalidQR = true;
      //     });
      //   }
      // });
    });
  }
}
