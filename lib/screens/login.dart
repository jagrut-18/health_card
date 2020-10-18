import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_card/screens/details.dart';
import 'package:health_card/screens/details_doctor.dart';
import 'package:health_card/screens/doctor_home_page.dart';
import 'package:health_card/screens/home_page.dart';
import 'package:health_card/screens/signup.dart';
import 'package:health_card/widgets/widgets.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailC = TextEditingController();

  final TextEditingController passC = TextEditingController();

  String selectedMode = '';

  List<String> modes = ['Patient', 'Doctor'];

  bool validate = false;

  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

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
                          validate && selectedMode == ''
                              ? Text(
                                  'Select any one option',
                                  style: Theme.of(context).textTheme.caption,
                                )
                              : Container(),
                          Wrap(
                            children: _modes(modes),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          isLoading
                              ? CircularProgressIndicator()
                              : RaisedButton(
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
                                      isLoading = true;

                                      if (formKey.currentState.validate()) {
                                        if (selectedMode == 'Patient') {
                                          FirebaseAuth.instance
                                              .signInWithEmailAndPassword(
                                                  email: emailC.text,
                                                  password: passC.text)
                                              .then((authResult) {
                                            Firestore.instance
                                                .collection('users')
                                                .document(authResult.user.uid)
                                                .get()
                                                .then((snapshot) {
                                              if (snapshot.data.length > 2) {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            HomePage(
                                                              uid: authResult
                                                                  .user.uid,
                                                            )));
                                              } else {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            DetailsPage()));
                                              }
                                            });
                                          });
                                        } else {
                                          FirebaseAuth.instance
                                              .signInWithEmailAndPassword(
                                                  email: emailC.text,
                                                  password: passC.text)
                                              .then((authResult) {
                                            Firestore.instance
                                                .collection('doctors')
                                                .document(authResult.user.uid)
                                                .get()
                                                .then((snapshot) {
                                              if (snapshot.data.length > 2) {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            DoctorHomePage(
                                                              uid: authResult
                                                                  .user.uid,
                                                            )));
                                              } else {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            DetailsDoctorPage()));
                                              }
                                            });
                                          });
                                        }
                                      }
                                      isLoading = false;
                                    });
                                  },
                                  child: Text('Log In',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline2)),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('No account?',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      .copyWith(fontWeight: FontWeight.normal)),
                              SizedBox(
                                width: 3,
                              ),
                              GestureDetector(
                                child: Text('Create here',
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle2
                                        .copyWith(color: Colors.black54)),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SignUpPage()));
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
