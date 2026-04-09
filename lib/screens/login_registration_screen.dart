import 'package:brqtrapp/screens/loginscreen.dart';
import 'package:brqtrapp/screens/main_screen.dart';
import 'package:brqtrapp/screens/mobile_registration_screen.dart';
import 'package:brqtrapp/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class LoginRegistrationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).accentColor,
      ),
      body: new Container(
        color: Colors.white,
        // decoration: BoxDecoration(
        //   //shape: BoxShape.circle,
        //   image: DecorationImage(
        //     image: AssetImage('images/bg.jpeg'),
        //     fit: BoxFit.cover,
        //   ),
        // ),
        child: Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                logoImage(),
                SizedBox(
                  height: 40.0,
                ),
                _loginButton(context),
                SizedBox(
                  height: 20.0,
                ),
                Divider(
                  height: 2,
                  thickness: 2,
                  indent: 60,
                  endIndent: 60,
                ),
                SizedBox(
                  height: 20.0,
                ),
                _registrationButton(context),
                SizedBox(
                  height: 40.0,
                ),
                _guestButton(context),
                SizedBox(
                  height: 8.0,
                ),
                //_arabicButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginButton(context) {
    return SizedBox(
      height: 60,
      width: 300,
      child: FlatButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
            return LoginPage();
          }));
          // Navigator.pushReplacement(
          //   context,
          //   new MaterialPageRoute(builder: (context) => LoginPage()),
          // );
        },
        child: Text(translator.translate('Login'),
            style:
                TextStyle(color: Theme.of(context).primaryColor, fontSize: 22)),
        textColor: null,
        shape: RoundedRectangleBorder(
            side: BorderSide(
                color: Theme.of(context).accentColor,
                width: 2.5,
                style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(50)),
      ),
    );
  }

  Widget logoImage() {
    return Container(
      width: 240,
      height: 240,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(70.0),
        image: DecorationImage(
          image: AssetImage('images/logo.jpeg'),
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _registrationButton(context) {
    return SizedBox(
      height: 60,
      width: 300,
      child: FlatButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
            return MobileRegistration();
          }));
        },
        child: Text(translator.translate('Register'),
            style:
                TextStyle(color: Theme.of(context).primaryColor, fontSize: 22)),
        textColor: null,
        shape: RoundedRectangleBorder(
            side: BorderSide(
                color: Theme.of(context).accentColor,
                width: 2.5,
                style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(50)),
      ),
    );
  }

  Widget _guestButton(context) {
    return SizedBox(
      height: 60,
      width: 300,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: BorderSide(color: Theme.of(context).accentColor)),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            new MaterialPageRoute(builder: (context) => MainScreen(0)),
          );
        },
        color: Theme.of(context).primaryColor,
        child: Padding(
          padding: EdgeInsets.all(15.0),
          // padding: EdgeInsets.fromLTRB(
          //     SizeConfig.safeBlockHorizontal * 5,
          //     0,
          //     SizeConfig.safeBlockHorizontal * 5,
          //     0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                translator.translate('Continue As Guest'),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _englishButton(context) {
    return Material(
      // elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Theme.of(context).primaryColor,
      child: MaterialButton(
        minWidth: 300.0,
        height: 60.0,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          // Navigator.of(context).pushNamed('/settings')
          Navigator.pushReplacement(
            context,
            new MaterialPageRoute(builder: (context) => LoginPage()),
          );
          // if (_key.currentState.validate()) {
          //   signIn(emailController.text, passwordController.text);
          //   //_isLoading = true;
          //
          // } else {
          //   //showLoginAlertDialog(context);
          //   setState(() {
          //     _validate = true;
          //   });
          //   //showLoginAlertDialog(context);
          // }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "As Guest",
              style: TextStyle(
                color: Theme.of(context).accentColor,
              ),
              textAlign: TextAlign.center,
            ),
            Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }

  Widget _arabicButton(context) {
    return Material(
      // elevation: 5.0,
      borderRadius: BorderRadius.circular(22.0),
      color: Color(0xFFffce82),
      child: MaterialButton(
        minWidth: 375.0,
        height: 30.0,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          print("Arabic button is pressed");
          Navigator.pushReplacement(
            context,
            new MaterialPageRoute(builder: (context) => LoginPage()),
          );
          // if (_key.currentState.validate()) {
          //   signIn(emailController.text, passwordController.text);
          //   //_isLoading = true;
          //
          // } else {
          //   //showLoginAlertDialog(context);
          //   setState(() {
          //     _validate = true;
          //   });
          //   //showLoginAlertDialog(context);
          // }
        },
        child: Text(
          "اعَرَبِيّ‎",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
