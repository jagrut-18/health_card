import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_card/screens/doctor_home_page.dart';
import 'package:health_card/screens/home_page.dart';
import 'package:health_card/screens/login.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  initState() {
    FirebaseAuth.instance.currentUser().then((user) {
      if (user == null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      } else {
        Firestore.instance.collection('users').getDocuments().then((snapshot) {
          snapshot.documents.contains(user.uid)
              ? Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomePage(
                            uid: user.uid,
                          )))
              : Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DoctorHomePage(
                            uid: user.uid,
                          )));
        });
      }
    }).catchError((err) => print(err));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1051BF),
      body: Center(
        child: Column(
          children: <Widget>[
            Image.asset('assets/health.gif'),
            Text(
              'Health Card',
              style:
                  Theme.of(context).textTheme.headline2.copyWith(fontSize: 30),
            ),
          ],
        ),
      ),
    );
  }
}
