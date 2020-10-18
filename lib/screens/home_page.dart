import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_card/screens/login.dart';
import 'package:health_card/screens/profile_page.dart';
import 'package:qr_flutter/qr_flutter.dart';

class HomePage extends StatefulWidget {
  final String uid;

  const HomePage({Key key, @required this.uid}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
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
                .collection('users')
                .document(widget.uid)
                .snapshots(),
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          QrImage(
                            data: widget.uid,
                            version: QrVersions.auto,
                            size: 200,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Hi ' + snapshot.data['firstName'],
                            style: Theme.of(context)
                                .textTheme
                                .headline1
                                .copyWith(
                                    fontWeight: FontWeight.bold, fontSize: 25),
                          ),
                          SizedBox(
                            height: 20,
                          ),
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
                                        builder: (context) => ProfilePage(
                                              uid: widget.uid,
                                            )));
                              }),
                        ],
                      ),
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    );
            }),
      ),
    );
  }
}
