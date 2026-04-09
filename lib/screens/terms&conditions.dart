import 'dart:io';

import 'package:brqtrapp/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import 'main_screen.dart';

class TermsCondition extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AboutUs();
  }
}

class _AboutUs extends State<TermsCondition> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          translator.translate('Terms and Conditions'),
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
            "Help protect your website and its users with clear and fair website terms and conditions. These terms and conditions for a website set out key issues such as acceptable use, privacy, cookies, registration and passwords, intellectual property, links to other sites, termination and disclaimers of responsibility. Terms and conditions are used and necessary to protect a website owner from liability of a user relying on the information or the goods provided from the site then suffering a loss. Making your own terms and conditions for your website is hard, not impossible, to do. It can take a few hours to few days for a person with no legal background to make. But worry no more; we are here to help you out. All you need to do is fill up the blank spaces and then you will receive an email with your personalized terms and conditions.",
            style: TextStyle(
                color: bluecolor, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
