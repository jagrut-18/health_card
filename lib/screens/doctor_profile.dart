import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:health_card/screens/details_doctor.dart';

class DoctorProfile extends StatefulWidget {
  final String uid;

  const DoctorProfile({Key key, @required this.uid}) : super(key: key);
  @override
  _DoctorProfileState createState() => _DoctorProfileState();
}

class _DoctorProfileState extends State<DoctorProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
            color: Colors.black,
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text(
          'Profile',
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      body: StreamBuilder(
          stream: Firestore.instance
              .collection('doctors')
              .document(widget.uid)
              .snapshots(),
          builder: (context, snapshot) {
            return snapshot.hasData
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 20),
                        child: Column(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  children: <Widget>[
                                    Text('Dr. ' + snapshot.data['doctorName'],
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline1
                                            .copyWith(
                                                fontSize:
                                                    30)), //snapshot.data['doctorName']
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.indigo.withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        child: Text(snapshot.data['speciality'],
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2
                                                .copyWith(
                                                    color: Colors.indigo)),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      snapshot.data['experience'] +
                                          ' Years of Experience',
                                      style:
                                          Theme.of(context).textTheme.headline1,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      height: 0.6,
                                      color: Colors.grey[350],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(snapshot.data['hospital'],
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      snapshot.data['address'],
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2
                                          .copyWith(fontSize: 16),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                RaisedButton(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 30),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    color: Colors.green[300],
                                    child: Text(
                                      'Edit Profile',
                                      style:
                                          Theme.of(context).textTheme.headline2,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DetailsDoctorPage()));
                                    })
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color(0xff1051BF),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30))),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 40),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Contact Us',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      .copyWith(color: Colors.white),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: <Widget>[
                                    Container(
                                      height: 40,
                                      width: 40,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(
                                          Icons.phone,
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.blue[200]),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(snapshot.data['phone'],
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline2),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: <Widget>[
                                    Container(
                                      height: 40,
                                      width: 40,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(
                                          Icons.email,
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.blue[200]),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(snapshot.data['email'],
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline2),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Center(child: CircularProgressIndicator());
          }),
    );
  }
}
