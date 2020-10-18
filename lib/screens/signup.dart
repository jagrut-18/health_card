import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_card/screens/details.dart';
import 'package:health_card/screens/details_doctor.dart';
import 'package:health_card/widgets/widgets.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final Firestore _firestore = Firestore.instance;

  final TextEditingController emailC = TextEditingController();

  final TextEditingController passC = TextEditingController();

  final TextEditingController cpassC = TextEditingController();

  String selectedMode = '';

  List<String> modes = ['Patient', 'Doctor'];

  final formKey = GlobalKey<FormState>();

  bool validate = false;

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
                'Health Card',
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
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: <Widget>[
                          TextInput(
                            controller: emailC,
                            hint: 'Email',
                            inputType: TextInputType.emailAddress,
                            errorText: 'Enter email address',
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextInput(
                            controller: passC,
                            hint: 'Password',
                            obscure: true,
                            errorText: 'Enter password',
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextInput(
                            controller: cpassC,
                            hint: 'Confirm Password',
                            obscure: true,
                            errorText: 'Enter password again',
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          validate && selectedMode == ''
                              ? Text(
                                  'Select any one option',
                                  style: Theme.of(context).textTheme.caption,
                                )
                              : Container(),
                          Text(
                            'Who are you?',
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                          Wrap(
                            children: _modes(modes),
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
                                setState(() {
                                  validate = true;
                                });
                                if (formKey.currentState.validate()) {
                                  if (passC.text == cpassC.text) {
                                    handleSignUp(
                                        context, emailC.text, passC.text);
                                  }
                                }
                              },
                              child: Text('Next',
                                  style:
                                      Theme.of(context).textTheme.headline2)),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('Already have account?',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      .copyWith(fontWeight: FontWeight.normal)),
                              SizedBox(
                                width: 3,
                              ),
                              GestureDetector(
                                child: Text('Click here',
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle2
                                        .copyWith(color: Colors.black54)),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              )
                            ],
                          )
                        ],
                      ),
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

  void handleSignUp(BuildContext context, String email, String password) async {
    await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (selectedMode == 'Patient') {
      _auth.currentUser().then((user) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => DetailsPage()));
        return _firestore.collection('users').document(user.uid).setData({
          'email': email,
          'uid': user.uid,
          'Medication': {},
          'Tests': {},
        });
      });
    } else {
      _auth.currentUser().then((user) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => DetailsDoctorPage()));
        return _firestore.collection('doctors').document(user.uid).setData({
          'email': email,
          'uid': user.uid,
        });
      });
    }
  }

  _modes(List<String> list) {
    List<Widget> choices = List();
    list.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(item),
          ),
          labelStyle: TextStyle(
              color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          backgroundColor: Color(0xffededed),
          selectedColor: Color(0xffffc107),
          selected: selectedMode == item,
          onSelected: (selected) {
            setState(() {
              selectedMode = item;
            });
          },
        ),
      ));
    });
    return choices;
  }
}
