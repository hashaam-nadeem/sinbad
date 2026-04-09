import 'package:brqtrapp/screens/loginscreen.dart';
import 'package:brqtrapp/utils/app_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListingScreen extends StatefulWidget {
  @override
  _ListingScreenState createState() => _ListingScreenState();
}

class _ListingScreenState extends State<ListingScreen> {

  bool _isLoggedIn = false;
  var arLang = "Ar";

  @override
  void initState() {
    // TODO: implement initState
    //_getDepartmentData();
    super.initState();
    _checkIfLoggedIn();
  }


  void _checkIfLoggedIn() async {
    // check if token is there
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    if (token != null) {
      setState(() {
        _isLoggedIn = true;
        //_getCartItemCount();

        //print("User Is Logged In");
        // _gotoMainpage();
      });
    } else {
      print("User Is Not Logged In");
//      Navigator.pushReplacement(
//        context,
//        new MaterialPageRoute(builder: (context) => LoginPage()),
//      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.grey[100],
      //backgroundColor: Theme.of(context).accentColor,
      // appBar: AppBar(
      //   elevation: 0.0,
      //   // leading: new IconButton(
      //   //     icon: Platform.isIOS ? new Icon(Icons.arrow_back_ios) : new Icon(Icons.arrow_back),
      //   //     onPressed: (){
      //   //       Navigator.push(
      //   //         context,
      //   //         MaterialPageRoute(builder: (context) => MainScreen(0)),
      //   //       );
      //   //     }
      //   // ),
      //   title: Text(
      //     translator.translate("Listing"),
      //     style: TextStyle(
      //       color: Colors.white,
      //     ),
      //   ),
      //   backgroundColor:Theme.of(context).primaryColor,
      //   //elevation: 0.0,
      //   // centerTitle: true,
      // ),
      body: Container(
        //color: Theme.of(context).accentColor,
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(120.0),bottom: Radius.circular(55.0),),
            child: Image.asset("images/cm.png",
              fit: BoxFit.contain,
            ),
          ),
        ),
        // child: Center(child: Text("Coming Soon!",style: TextStyle(fontSize: 25.0,color: Colors.white,
        //   fontWeight: FontWeight.w600,),),),
      ),
      // drawer: Drawer(
      //   // Add a ListView to the drawer. This ensures the user can scroll
      //   // through the options in the drawer if there isn't enough vertical
      //   // space to fit everything.
      //   child: ListView(
      //     // Important: Remove any padding from the ListView.
      //     padding: EdgeInsets.zero,
      //     children: <Widget>[
      //       DrawerHeader(
      //         child: _isLoggedIn
      //             ? Text('Hello Shahid',
      //             style: TextStyle(color: Colors.white, fontSize: 22.0))
      //             : Text(
      //           'Hello Guest',
      //           style: TextStyle(color: Colors.white, fontSize: 25.0),
      //         ),
      //         decoration: BoxDecoration(
      //           color: Theme.of(context).primaryColor,
      //         ),
      //       ),
      //       ListTile(
      //         leading: Icon(Icons.account_box),
      //         title: Text('About Us'),
      //         // onTap: () {
      //         //   Navigator.pop(context);
      //         //   // Update the state of the app.
      //         //   // ...
      //         //   Navigator.of(context).push(new MaterialPageRoute(
      //         //       builder: (BuildContext context) => AboutUs()));
      //         // },
      //       ),
      //       ListTile(
      //         leading: Icon(Icons.lock),
      //         title: Text('Privacy Policy'),
      //         // onTap: () {
      //         //   Navigator.pop(context);
      //         //   // Update the state of the app.
      //         //   // ...
      //         //
      //         //   Navigator.of(context).push(new MaterialPageRoute(
      //         //       builder: (BuildContext context) => PrivacyPolicy()));
      //         // },
      //       ),
      //       ListTile(
      //         leading: Icon(Icons.loyalty),
      //         title: Text('Terms and Conditions'),
      //         // onTap: () {
      //         //   Navigator.pop(context);
      //         //
      //         //   Navigator.of(context).push(new MaterialPageRoute(
      //         //       builder: (BuildContext context) => TermConditions()));
      //         //   // Update the state of the app.
      //         //   // ...
      //         // },
      //       ),
      //       _isLoggedIn
      //           ? ListTile(
      //         leading: Icon(Icons.language_sharp),
      //         title: Text(translator.translate('buttonTitle')),
      //         onTap: () async {
      //           SharedPreferences localStorage = await SharedPreferences.getInstance();
      //           localStorage.setBool('isLangArabic', true);
      //           localStorage.setString('selectedLanguage', arLang );
      //           setState(() {
      //             translator.setNewLanguage(
      //               context,
      //               newLanguage: translator.currentLanguage == 'ar' ? 'en' : 'ar',
      //               remember: true,
      //               restart: true,
      //             );
      //           });
      //           //Navigator.pop(context);
      //           // _changeLanguage(Language language);
      //           print("Changed Language To Arabic");
      //           //
      //           //   Navigator.of(context).push(new MaterialPageRoute(
      //           //       builder: (BuildContext context) => ContactUs()));
      //           //   // Update the state of the app.
      //           //   // ...
      //         },
      //       ): Text(''),
      //       _isLoggedIn
      //           ? ListTile(
      //         leading: Icon(Icons.logout),
      //         title: Text('Log Out'),
      //         onTap: () {
      //           Navigator.pop(context);
      //           _logoutFromTheApp(context);
      //           // Navigator.of(context).push(new MaterialPageRoute(
      //           //     builder: (BuildContext context) => ContactUs()));
      //           // Update the state of the app.
      //           // ...
      //         },
      //       )
      //           : Text(''),
      //     ],
      //   ),
      // ),
    );
  }

  void _logoutFromTheApp(context) {
    AppSharedPreferences.clear();
    Navigator.pushReplacement(
      context,
      new MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
}
