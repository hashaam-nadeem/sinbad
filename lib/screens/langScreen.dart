import 'package:brqtrapp/screens/login_registration_screen.dart';
import 'package:brqtrapp/screens/loginscreen.dart';
import 'package:brqtrapp/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageScreen extends StatelessWidget {
  bool isLangArabic = false;
  var arLang = "Ar";
  var enLang = "En";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //  bottomNavigationBar: bottomBar(context),
        body: Container(
      //decoration: new BoxDecoration(color: Color(0xFF3c0000)),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          //shape: BoxShape.circle,
          color: bluecolor
          // image: DecorationImage(
          //   image: AssetImage('images/logo.jpeg'),
          //   //  colorFilter: new ColorFilter.mode(Colors.black38.withOpacity(0.6), BlendMode.dstIn),
          //   fit: BoxFit.contain,
          // ),
          ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * .15,
          ),
          _englishButton(context),
          SizedBox(
            height: 20.0,
          ),
          _arabicButton(context),
          SizedBox(
            height: 20.0,
          ),
        ],
      ),
    ));
  }

  Widget bottomBar(BuildContext context) {
    return Container(
      // padding: EdgeInsets,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * .2,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50), color: orangecolor),
      child: Image.asset(
        "images/logo.jpeg",
        fit: BoxFit.fitWidth,
      ),
    );
  }
  // Widget _loginButton(context){
  //   return FlatButton(
  //     onPressed: null,
  //     child: Text('Button', style: TextStyle(
  //         color:  Theme.of(context).primaryColor,
  //     )
  //     ),
  //     textColor: null,
  //     shape: RoundedRectangleBorder(side: BorderSide(
  //         color: Theme.of(context).primaryColor,
  //         width: 2.5,
  //         style: BorderStyle.solid
  //     ), borderRadius: BorderRadius.circular(50)),
  //   );
  // }

  // Widget _englishButton(context) {
  //   return Material(
  //     // elevation: 5.0,
  //     borderRadius: BorderRadius.circular(30.0),
  //     color: Theme.of(context).primaryColor,
  //     child: MaterialButton(
  //       minWidth: 375.0,
  //       height: 40.0,
  //       padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
  //       onPressed: () async {
  //         SharedPreferences localStorage = await SharedPreferences.getInstance();
  //         //localStorage.setBool('isLangArabic', true);
  //         localStorage.setString('selectedLanguage', enLang );
  //         translator.setNewLanguage(
  //           context,
  //           newLanguage: translator.currentLanguage != 'en' ? 'en' : 'en',
  //           remember: true,
  //           restart: false,
  //         );
  //        // Navigator.of(context).pushNamed('/settings')
  //         Navigator.pushReplacement(
  //           context,
  //           new MaterialPageRoute(builder: (context) => LoginRegistrationScreen()),
  //         );
  //       },
  //       child: Text("English",
  //         style: TextStyle(color: Colors.white,
  //           fontSize: 18.0,
  //           fontWeight: FontWeight.bold,),
  //         textAlign: TextAlign.center,
  //       ),
  //     ),
  //   );
  // }

  Widget _englishButton(context) {
    return SizedBox(
      height: 60,
      width: 350,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: BorderSide(color: Theme.of(context).accentColor)),
        onPressed: () async {
          SharedPreferences localStorage =
              await SharedPreferences.getInstance();
          //localStorage.setBool('isLangArabic', true);
          localStorage.setString('selectedLanguage', enLang);
          translator.setNewLanguage(
            context,
            newLanguage: translator.currentLanguage != 'en' ? 'en' : 'en',
            remember: true,
            restart: false,
          );
          // Navigator.of(context).pushNamed('/settings')
          // Navigator.pushReplacement(
          //   context,
          //   new MaterialPageRoute(builder: (context) => LoginRegistrationScreen()),
          // );
          Navigator.of(context)
              .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
            return LoginRegistrationScreen();
          }));
        },
        color: soilcolor,
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                translator.translate('English'),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              // Icon(
              //   Icons.arrow_forward_ios,
              //   color: Colors.white,
              // )
            ],
          ),
        ),
      ),
    );
  }

  // Widget _arabicButton(context) {
  //   return Material(
  //     // elevation: 5.0,
  //     borderRadius: BorderRadius.circular(30.0),
  //     color: Theme.of(context).primaryColor,
  //     child: MaterialButton(
  //       minWidth: 375.0,
  //       height: 30.0,
  //       padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
  //       onPressed: () async {
  //         SharedPreferences localStorage = await SharedPreferences.getInstance();
  //         localStorage.setBool('isLangArabic', true);
  //         localStorage.setString('selectedLanguage', arLang );
  //         //isLangArabic = ;
  //         translator.setNewLanguage(
  //           context,
  //           newLanguage:translator.currentLanguage == 'ar' ? 'ar' : 'ar',
  //           remember: true,
  //           restart: false,
  //         );
  //         print("Arabic button is pressed");
  //         Navigator.pushReplacement(
  //           context,
  //           new MaterialPageRoute(builder: (context) => LoginRegistrationScreen()),
  //         );
  //
  //       },
  //       child: Text("اعَرَبِيّ‎",
  //         style: TextStyle(color: Colors.white,
  //           fontSize: 18.0,
  //           fontWeight: FontWeight.bold,),
  //         textAlign: TextAlign.center,
  //       ),
  //     ),
  //   );
  // }

  Widget _arabicButton(context) {
    return SizedBox(
      height: 60,
      width: 350,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: BorderSide(color: Theme.of(context).accentColor)),
        onPressed: () async {
          SharedPreferences localStorage =
              await SharedPreferences.getInstance();
          localStorage.setBool('isLangArabic', true);
          localStorage.setString('selectedLanguage', arLang);
          //isLangArabic = ;
          translator.setNewLanguage(
            context,
            newLanguage: translator.currentLanguage == 'ar' ? 'ar' : 'ar',
            remember: true,
            restart: false,
          );
          print("Arabic button is pressed");
          // Navigator.pushReplacement(
          //   context,
          //   new MaterialPageRoute(builder: (context) => LoginRegistrationScreen()),
          // );
          Navigator.of(context)
              .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
            return LoginRegistrationScreen();
          }));
        },
        color: soilcolor,
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "العربية",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              // Icon(
              //   Icons.arrow_forward_ios,
              //   color: Colors.white,
              // )
            ],
          ),
        ),
      ),
    );
  }
}
