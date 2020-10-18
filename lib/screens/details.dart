import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_card/screens/home_page.dart';
import 'package:health_card/screens/profile_page.dart';
import 'package:health_card/widgets/widgets.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({Key key}) : super(key: key);
  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  final Firestore _firestore = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController firstC = TextEditingController();

  final TextEditingController secondC = TextEditingController();

  final TextEditingController weightC = TextEditingController();

  final TextEditingController heightC = TextEditingController();

  String selectedBlood = '';

  bool blood = false;

  List<String> bloodGroups = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];

  List<String> gender = ['Male', 'Female', 'Other'];

  String selectedGender = '';

  DateTime dob = DateTime.now();

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _auth.currentUser().then((user) => Firestore.instance
            .collection('users')
            .document(user.uid)
            .get()
            .then((snapshot) {
          setState(() {
            firstC.text = snapshot.data['firstName'];
            secondC.text = snapshot.data['secondName'];
            weightC.text =
                snapshot.data['details']['Weight'].replaceAll(' kg', '');
            heightC.text =
                snapshot.data['details']['Height'].replaceAll(' cm', '');
            selectedBlood = snapshot.data['details']['Blood'];
            selectedGender = snapshot.data['gender'];
            dob = DateTime.parse(snapshot.data['dob']);
          });
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
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: <Widget>[
                          TextInput(
                            controller: firstC,
                            hint: 'First Name',
                            errorText: 'Enter First Name',
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextInput(
                            controller: secondC,
                            hint: 'Second Name',
                            errorText: 'Enter Second Name',
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Wrap(
                            children: _genderList(gender),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: TextInput(
                                  controller: weightC,
                                  hint: 'Weight(kg)',
                                  inputType: TextInputType.number,
                                  errorText: 'Enter Weight',
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: TextInput(
                                  controller: heightC,
                                  hint: 'Height(cm)',
                                  inputType: TextInputType.number,
                                  errorText: 'Enter Height',
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: <Widget>[
                              FlatButton(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 14),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  color: Colors.grey[200],
                                  onPressed: () {
                                    showDatePicker(
                                            context: context,
                                            initialDate: dob,
                                            firstDate: DateTime(1900, 1, 1),
                                            lastDate: DateTime.now())
                                        .then((value) {
                                      setState(() {
                                        dob = value;
                                        print(value);
                                      });
                                    });
                                  },
                                  child: Text(
                                    'Date of Birth',
                                    style:
                                        Theme.of(context).textTheme.subtitle2,
                                  )),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Day',
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2,
                                        ),
                                        Text(
                                          dob.day.toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline1
                                              .copyWith(
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Month',
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2,
                                        ),
                                        Text(
                                          dob.month.toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline1
                                              .copyWith(
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Year',
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2,
                                        ),
                                        Text(
                                          dob.year.toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline1
                                              .copyWith(
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'BloodGroup',
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                          Wrap(
                            children: _buildChoiceList(bloodGroups),
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
                                if (formKey.currentState.validate() &&
                                    selectedBlood != '' &&
                                    selectedGender != '') {
                                  _auth.currentUser().then((user) {
                                    return _firestore
                                        .collection('users')
                                        .document(user.uid)
                                        .updateData({
                                      'firstName': firstC.text,
                                      'secondName': secondC.text,
                                      'gender': selectedGender,
                                      'dob': dob.toString(),
                                      'details': {
                                        'Weight': weightC.text + ' kg',
                                        'Age': (DateTime.now().year - dob.year)
                                                .toString() +
                                            ' years',
                                        'Blood': selectedBlood,
                                        'Height': heightC.text + ' cm',
                                      }
                                    }).then((value) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => HomePage(
                                                    uid: user.uid,
                                                  )));
                                    });
                                  });
                                }
                              },
                              child: Text('Save',
                                  style:
                                      Theme.of(context).textTheme.headline2)),
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

  _buildChoiceList(List<String> list) {
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
          selected: selectedBlood == item,
          onSelected: (selected) {
            setState(() {
              selectedBlood = item;
            });
          },
        ),
      ));
    });
    return choices;
  }

  _genderList(List<String> list) {
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
          selected: selectedGender == item,
          onSelected: (selected) {
            setState(() {
              selectedGender = item;
            });
          },
        ),
      ));
    });
    return choices;
  }
}
