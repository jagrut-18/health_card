import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_card/screens/doctor_home_page.dart';
import 'package:health_card/screens/doctor_profile.dart';
import 'package:health_card/widgets/widgets.dart';

class HospitalDetails extends StatefulWidget {
  @override
  _HospitalDetailsState createState() => _HospitalDetailsState();
}

class _HospitalDetailsState extends State<HospitalDetails> {
  final Firestore _firestore = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController regC = TextEditingController();
  final TextEditingController clinicC = TextEditingController();
  final TextEditingController addressC = TextEditingController();
  final TextEditingController specialC = TextEditingController();

  @override
  void initState() {
    _auth.currentUser().then((user) => Firestore.instance
            .collection('doctors')
            .document(user.uid)
            .get()
            .then((snapshot) {
          regC.text = snapshot.data['registration'];
          clinicC.text = snapshot.data['hospital'];
          addressC.text = snapshot.data['address'];
          specialC.text = snapshot.data['speciality'];
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
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Text(
                'Hospital Details',
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
                        SizedBox(
                          height: 20,
                        ),
                        TextInput(
                            hint: 'Registration Number', controller: regC),
                        SizedBox(
                          height: 20,
                        ),
                        TextInput(
                          controller: specialC,
                          hint: 'Your Speciality',
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextInput(
                          controller: clinicC,
                          hint: 'Hospital/Clinic Name',
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextInput(
                          hint: 'Address',
                          controller: addressC,
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
                                  'registration': regC.text,
                                  'hospital': clinicC.text,
                                  'address': addressC.text,
                                  'speciality': specialC.text
                                }).then((value) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DoctorHomePage(
                                                uid: user.uid,
                                              )));
                                });
                              });
                            },
                            child: Text('Save',
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
