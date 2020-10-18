import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:health_card/screens/add_history.dart';
import 'package:health_card/screens/details.dart';
import 'package:health_card/screens/show_image.dart';

class ProfilePage extends StatefulWidget {
  final String uid;
  final bool fromScan;
  final String doctorName;

  const ProfilePage(
      {Key key, @required this.uid, this.fromScan = false, this.doctorName})
      : super(key: key);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title:
            Text('Profile Page', style: Theme.of(context).textTheme.headline1),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.black,
        ),
      ),
      body: DefaultTabController(
        length: 2,
        child: StreamBuilder(
            stream: Firestore.instance
                .collection('users')
                .document(widget.uid)
                .snapshots(),
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(bottom: 15),
                          decoration: BoxDecoration(
                              color: Color(0xff1051BF),
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20))),
                          child: Column(
                            children: <Widget>[
                              Container(
                                  child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: ListTile(
                                      title: Text(
                                          snapshot.data['firstName'] +
                                              ' ' +
                                              snapshot.data['secondName'] +
                                              ' - ' +
                                              snapshot.data['gender'],
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline2),
                                      subtitle: Text(
                                        snapshot.data['email'],
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1,
                                      ),
                                      trailing: widget.fromScan
                                          ? IconButton(
                                              icon: Icon(Icons.add_circle),
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            AddHistory(
                                                              uid: widget.uid,
                                                              doctorName: widget
                                                                  .doctorName,
                                                            )));
                                              },
                                              color: Colors.white,
                                            )
                                          : IconButton(
                                              icon: Icon(Icons.edit),
                                              onPressed: () {
                                                Navigator.pushAndRemoveUntil(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            DetailsPage()),
                                                    (route) => false);
                                              },
                                              color: Colors.white,
                                            ),
                                    ),
                                  ),
                                ],
                              )),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 30),
                                child: GridView.builder(
                                    shrinkWrap: true,
                                    itemCount: 4,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 2.5,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                    ),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15),
                                        decoration: BoxDecoration(
                                            color: Colors.blue.withOpacity(0.4),
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                              height: 40,
                                              width: 40,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Image.asset(
                                                    'assets/details$index.png'),
                                              ),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Colors.blue[200]),
                                            ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                    snapshot
                                                        .data['details'].keys
                                                        .toList()[index],
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline2),
                                                Text(
                                                    snapshot
                                                        .data['details'].values
                                                        .toList()[index],
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .subtitle1)
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TabBar(
                            indicatorColor: Color(0xff1051BF),
                            unselectedLabelColor: Colors.grey,
                            labelColor: Colors.black,
                            labelStyle: Theme.of(context).textTheme.headline1,
                            tabs: [
                              Text(
                                'Medication',
                              ),
                              Text(
                                'Tests',
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: TabBarView(children: [
                            ListView.builder(
                              itemCount: snapshot.data['Medication'].length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return TabCard(
                                  title: snapshot.data['Medication']['$index']
                                      ['title'],
                                  description: snapshot.data['Medication']
                                      ['$index']['description'],
                                  imgUrls: snapshot.data['Medication']['$index']
                                      ['imageUrls'],
                                  doctor: snapshot.data['Medication']['$index']
                                      ['addedBy'],
                                  date: snapshot.data['Medication']['$index']
                                      ['date'],
                                );
                              },
                            ),
                            ListView.builder(
                              itemCount: snapshot.data['Tests'].length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return TabCard(
                                  title: snapshot.data['Tests']['$index']
                                      ['title'],
                                  description: snapshot.data['Tests']['$index']
                                      ['description'],
                                  imgUrls: snapshot.data['Tests']['$index']
                                      ['imageUrls'],
                                  doctor: snapshot.data['Tests']['$index']
                                      ['addedBy'],
                                  date: snapshot.data['Tests']['$index']
                                      ['date'],
                                );
                              },
                            ),
                          ]),
                        )
                      ],
                    )
                  : Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }
}

class TabCard extends StatefulWidget {
  final String title;
  final String description;
  final List imgUrls;
  final String doctor;
  final String date;

  const TabCard(
      {Key key,
      @required this.title,
      @required this.description,
      @required this.imgUrls,
      this.doctor = '',
      this.date = ''})
      : super(key: key);

  @override
  _TabCardState createState() => _TabCardState();
}

class _TabCardState extends State<TabCard> {
  List<Widget> documents(List imgUrls) {
    List<Widget> documents = [];
    for (var url in imgUrls) {
      documents.add(GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ShowImage(image: url, tag: 'show${imgUrls.length}'),
              ));
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            url,
            height: 50,
            width: 50,
            fit: BoxFit.cover,
          ),
        ),
      ));
    }
    return documents;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(widget.title, style: Theme.of(context).textTheme.headline3),
            SizedBox(
              height: 5,
            ),
            Text(
              widget.description,
            ),
            SizedBox(
              height: 5,
            ),
            Text('Documents',
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    .copyWith(color: Colors.indigo, fontSize: 14)),
            SizedBox(
              height: 5,
            ),
            Wrap(
              spacing: 5,
              children: documents(widget.imgUrls),
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text('Added by ' + widget.doctor,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2
                        .copyWith(fontWeight: FontWeight.normal, fontSize: 14)),
                Text(' · ' + widget.date,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2
                        .copyWith(fontWeight: FontWeight.normal, fontSize: 14)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
