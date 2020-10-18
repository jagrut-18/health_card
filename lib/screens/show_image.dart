import 'package:flutter/material.dart';

class ShowImage extends StatefulWidget {
  final String image;
  final String tag;
  const ShowImage({Key key, @required this.image, @required this.tag})
      : super(key: key);
  @override
  _ShowImageState createState() => _ShowImageState();
}

class _ShowImageState extends State<ShowImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.black,
        ),
      ),
      body: Center(
          child: Hero(tag: widget.tag, child: Image.network(widget.image))),
    );
  }
}
