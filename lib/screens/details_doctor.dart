import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_card/screens/hospital_details.dart';
import 'package:health_card/widgets/widgets.dart';

class DetailsDoctorPage extends StatefulWidget {
  const DetailsDoctorPage({Key key}) : super(key: key);
  @override
  _DetailsDoctorPageState createState() => _DetailsDoctorPageState();
}

class _DetailsDoctorPageState extends State<DetailsDoctorPage> {
  final Firestore _firestore = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController nameC = TextEditingController();
  final TextEditingController phoneC = TextEditingController();
  final TextEditingController expC = TextEditingController();

  @override
  void initState() {
    _auth.currentUser().then((user) => Firestore.instance
            .collection('doctors')
            .document(user.uid)
            .get()
            .then((snapshot) {
          nameC.text = snapshot.data['doctorName'];
          phoneC.text = snapshot.data['phone'];
          expC.text = snapshot.data['experience'];
        }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Color(0xff1051BF),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Text(
                'Personal Details',
                style: Theme.of(context)
                    .textTheme
                    .headline2
                    .copyWith(fontSize: 30),
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              'Dr.',
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                            SizedBox(
                              width: 7,
                            ),
                            Expanded(
                              child: TextInput(
                                controller: nameC,
                                hint: 'Full Name',
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextInput(
                          hint: 'Phone Number',
                          controller: phoneC,
                          inputType: TextInputType.phone,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextInput(
                          controller: expC,
                          hint: 'Experience in years',
                          inputType: TextInputType.number,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        RaisedButton(
                            elevation: 5,
                            padding: EdgeInsets.symmetric(
                              horizontal: 60,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            color: Colors.green[300],
                            onPressed: () {
                              _auth.currentUser().then((user) {
                                return _firestore
                                    .collection('doctors')
                                    .document(user.uid)
                                    .updateData({
                                  'doctorName': nameC.text,
                                  'phone': phoneC.text,
                                  'experience': expC.text,
                                });
                              });
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HospitalDetails()));
                            },
                            child: Text('Next',
                                style: Theme.of(context).textTheme.headline2)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
