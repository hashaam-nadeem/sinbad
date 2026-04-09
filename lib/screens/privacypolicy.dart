import 'dart:io';

import 'package:brqtrapp/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import 'main_screen.dart';

class PrivacyPolicy extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AboutUs();
  }
}

class _AboutUs extends State<PrivacyPolicy> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          translator.translate('Privacy Policy'),
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
            "A privacy policy outlines how your website collects, uses, shares, and sells the personal information of your visitors. If you collect personal information from users, you need a privacy policy in most jurisdictions. Even if you aren’t subject to privacy policy laws, being transparent with users about how you collect and handle their data is a best business practice in today’s digital world. Our simple privacy policy template will help you comply with strict privacy laws, and build trust with your users.  Download the free privacy policy template below, or copy and paste the full text onto your site. If you’d rather let us help you customize a document that’s tailored specifically to your business, our privacy policy generator will create one for you in minutes.",
            style: TextStyle(
                color: bluecolor, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
