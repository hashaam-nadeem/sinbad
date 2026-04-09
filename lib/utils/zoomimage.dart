import 'package:flutter/material.dart';
import 'package:gesture_zoom_box/gesture_zoom_box.dart';

class ZoomImage extends StatefulWidget {
  String image;
  ZoomImage({this.image});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _zoom();
  }
}

class _zoom extends State<ZoomImage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        color: Colors.transparent,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: GestureZoomBox(
          maxScale: 5.0,
          doubleTapScale: 2.0,
          duration: Duration(milliseconds: 400),
          onPressed: () => Navigator.pop(context),
          child: Image.network(
            widget.image,
            fit: BoxFit.fitHeight,
          ),
        ));
  }
}
