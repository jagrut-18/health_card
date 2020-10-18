import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:health_card/screens/profile_page.dart';
import 'package:health_card/widgets/widgets.dart';
import 'package:image_picker/image_picker.dart';

class AddHistory extends StatefulWidget {
  final String uid;
  final String doctorName;

  const AddHistory({Key key, @required this.uid, @required this.doctorName})
      : super(key: key);
  @override
  _AddHistoryState createState() => _AddHistoryState();
}

class _AddHistoryState extends State<AddHistory> {
  FirebaseStorage _storage = FirebaseStorage.instance;
  final formKey = GlobalKey<FormState>();

  final TextEditingController titleC = TextEditingController();

  final TextEditingController descC = TextEditingController();

  bool validate = false;

  bool isLoading = false;

  Map history = {};

  List<Widget> imageWidget = [];

  List images = [];

  final picker = ImagePicker();

  String selectedMode = '';

  List<String> modes = ['Medication', 'Tests'];

  Future getImageCamera() async {
    var file = await picker.getImage(source: ImageSource.camera);
    setState(() {
      var image = File(file.path);
      imageWidget.add(Image.file(
        image,
        height: 100,
        width: 100,
      ));
      images.add(image);
    });
  }

  Future selectImageGallery() async {
    var file = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      var image = File(file.path);
      imageWidget.add(Image.file(
        image,
        height: 100,
        width: 100,
      ));
      images.add(image);
    });
  }

  Future<List> uploadImage(List files) async {
    List<String> downloadUrls = [];
    for (int i = 0; i < files.length; i++) {
      StorageReference reference = _storage.ref().child(
          '${widget.uid}/$selectedMode/${history.length}_${titleC.text}/$i');
      StorageUploadTask uploadTask = reference.putFile(files[i]);
      await uploadTask.onComplete;
      reference.getDownloadURL().then((url) {
        downloadUrls.add(url.toString());
        history['${history.length}'] = {
          'title': titleC.text,
          'description': descC.text,
          'imageUrls': downloadUrls,
          'addedBy': widget.doctorName,
          'date': DateTime.now().day.toString() +
              '-' +
              DateTime.now().month.toString() +
              '-' +
              DateTime.now().year.toString(),
        };
        Firestore.instance
            .collection('users')
            .document(widget.uid)
            .updateData({selectedMode: history});
      });
    }
    return downloadUrls;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1051BF),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Text(
              'Add History',
              style:
                  Theme.of(context).textTheme.headline2.copyWith(fontSize: 30),
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
                          controller: titleC,
                          hint: 'Title',
                          errorText: 'Enter title',
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextInput(
                          controller: descC,
                          hint: 'Description',
                          errorText: 'Enter description',
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
                        images.length > 0
                            ? Column(
                                children: <Widget>[
                                  Text(
                                    'Added Images : ${images.length}',
                                    style:
                                        Theme.of(context).textTheme.headline1,
                                  ),
                                  Wrap(
                                    children: imageWidget,
                                  )
                                ],
                              )
                            : Container(),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          imageText(),
                          style: Theme.of(context).textTheme.headline1,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            RaisedButton(
                                elevation: 0,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                color: Colors.blue[100],
                                onPressed: getImageCamera,
                                child: Text('Camera')),
                            RaisedButton(
                                elevation: 0,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                color: Colors.blue[100],
                                onPressed: selectImageGallery,
                                child: Text('Gallery')),
                          ],
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
                                    if (formKey.currentState.validate() &&
                                        selectedMode != '') {
                                      Firestore.instance
                                          .collection('users')
                                          .document(widget.uid)
                                          .get()
                                          .then((snapshot) {
                                        history = snapshot.data[selectedMode];
                                      }).then((value) {
                                        uploadImage(images).then((value) =>
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ProfilePage(
                                                          uid: widget.uid,
                                                          fromScan: true,
                                                          doctorName:
                                                              widget.doctorName,
                                                        ))));
                                      });

                                      isLoading = false;
                                    }
                                  });
                                },
                                child: Text('Save Details',
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

  String imageText() {
    if (selectedMode == 'Medication') {
      return 'Add prescription images from';
    } else if (selectedMode == 'Tests') {
      return 'Add test images from';
    } else {
      return 'Add images from';
    }
  }
}
