import 'dart:io';

import 'package:brqtrapp/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import 'main_screen.dart';

class AboutUs extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AboutUs();
  }
}

class _AboutUs extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          translator.translate('About Us'),
        ),

        ///leading: Container(),
        leading: new IconButton(
            icon: Platform.isIOS
                ? new Icon(Icons.arrow_back_ios)
                : new Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MainScreen(0)),
              );
            }),
        actions: <Widget>[
          // Stack(
          //   children: <Widget>[
          //     IconButton(
          //       icon: Icon(Icons.shopping_basket),
          //       onPressed: () {
          //         // Navigator.of(context)
          //         //     .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
          //         //   return CartPage();
          //         // }));
          //       },
          //     ),

          //     totalCount == '' || totalCount ==null
          //         ? new Container()
          //         :
          //     Stack(
          //       children: <Widget>[
          //         Container(
          //           height:20.0,
          //           width: 20.0,
          //           child:       Align(
          //             alignment: Alignment.center,
          //             child: new Center(
          //                 child:
          //                 new Text(
          //                   "$totalCount",
          //                   style: new TextStyle(
          //                       color: Colors
          //                           .white,
          //                       fontSize:
          //                       11.0,
          //                       fontWeight:
          //                       FontWeight
          //                           .w500),
          //                 )
          //             ),
          //           ),
          //           decoration: BoxDecoration(

          //               borderRadius: BorderRadius.all(Radius.circular(100.0)),
          //               color: Colors.red
          //           ) ,
          //         ),
          //       ],
          //     )
          //   ],

          // )
        ],
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          // decoration: BoxDecoration(
          //     image: DecorationImage(
          //   image: AssetImage("images/applogo.png"),
          //   fit: BoxFit.contain,
          //   colorFilter: new ColorFilter.mode(
          //       Colors.black.withOpacity(0.2), BlendMode.dstATop),
          // )),
          padding: EdgeInsets.all(12),
          child: Text(
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
            style: TextStyle(
                color: bluecolor, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
