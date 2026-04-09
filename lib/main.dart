// import 'package:Salwa_garden/app_settings.dart';
// import 'package:Salwa_garden/pages/add_new_shipping_address.dart';
// import 'package:Salwa_garden/pages/edit_shipping_address.dart';
// import 'package:Salwa_garden/pages/home_page.dart';
// import 'package:Salwa_garden/screens/select_branch.dart';

import 'package:brqtrapp/localization/demo_localization.dart';
import 'package:brqtrapp/screens/department_screen.dart';
import 'package:brqtrapp/screens/langScreen.dart';
import 'package:brqtrapp/screens/loginscreen.dart';
import 'package:brqtrapp/screens/main_screen.dart';
import 'package:brqtrapp/utils/constant.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
// import 'package:Salwa_garden/login_page.dart';
// import 'package:Salwa_garden/screens/main_screen.dart';
// import 'package:Salwa_garden/firebase_notification_handler.dart';
// import 'package:Salwa_garden/screens/tour/getting_started_tour.dart';
import 'package:dio/dio.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  // if your flutter > 1.7.8 :  ensure flutter activated
  WidgetsFlutterBinding.ensureInitialized();

  await translator.init(
    localeDefault: LocalizationDefaultType.device,
    languagesList: <String>['ar', 'en'],
    assetsDirectory: 'lib/lang',
    apiKeyGoogle: '<Key>', // NOT YET TESTED
  );
  //runApp(MyApp());
  runApp(LocalizedApp(child: MyApp()));
}

class MyApp extends StatefulWidget {
  // static void setLocale(BuildContext context, Locale locale){
  //   _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
  //   state.setLocale(locale);
  // }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //Locale _locale;

  // void setLocale(Locale locale){
  //   setState(() {
  //     _locale = locale;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'DIN Next',
        //primarySwatch: Colors.green,
        primaryColor: bluecolor,
        accentColor: redcolor,
        accentTextTheme: TextTheme(
          bodyText1: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      localizationsDelegates: translator.delegates,
      locale: translator.locale,
      supportedLocales: translator.locals(),
      // locale: _locale,
      // supportedLocales: [
      //   const Locale('en', 'US'), // English, no country code
      //   const Locale('ar', 'QA'), // Hebrew, no country code
      //   //const Locale.fromSubtags(languageCode: 'zh'), // Chinese *See Advanced Locales below*
      //   // ... other locales the app supports
      // ],
      // localizationsDelegates: [
      //   DemoLocalization.delegate,
      //   // ... app-specific localization delegate[s] here
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      //   GlobalCupertinoLocalizations.delegate,
      // ],
      // localeResolutionCallback: (deviceLocale,supportedLocale){
      //   for(var locale in supportedLocale){
      //     if(locale.languageCode == deviceLocale.languageCode && locale.countryCode == deviceLocale.countryCode){
      //       return deviceLocale;
      //     }
      //   }
      //   return supportedLocale.first;
      // },
      home: SplashScreen(), //SelectBranch(0),SplashScreen(),

      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/LoginPage': (BuildContext context) => LoginPage(),

        ///Uncomment it
        '/LanguageScreen': (BuildContext context) => LanguageScreen(),

        ///Uncomment it
        '/MainScreen': (BuildContext context) => MainScreen(0),
        // '/homePage': (BuildContext context) => HomePage(),
        // '/newshipping': (BuildContext context) => AddNewAddress(),
        // '/editshipping': (BuildContext context) => EditNewAddress(),

        // '/selectBranch': (BuildContext context) => SelectBranch(),
      },
    );
  }
}

//
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  StreamSubscription _connectionChangeStream;
  bool _isLoggedIn = false;

  bool isOffline = false;

  //SharedPreferences sharedPreferences; ///Uncomment it

  get subscription => null;

  startTime() async {
    var _duration = new Duration(seconds: 1);
    return new Timer(_duration, _checkIfLoggedIn);

    ///_checkIfLoggedIn
  }

  @override
  void initState() {
    networkChecked();
    var subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      print("Connection Status has Changed");
    });
    //_checkIfLoggedIn();
    super.initState();
    startTime();
    //checkLoginStatus();
    // FirebaseNotifications().setUpFirebase();   ///Uncomment it
  }

  // dispose() {
  //   subscription.cancel();
  // }

  void _checkIfLoggedIn() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    //var branchID = localStorage.getString('branchId');
    if (token != null) {
      setState(() {
        _isLoggedIn = true;
        print("User Is Logged In");
        _gotoMainpage();
      });
    } else {
      print("User Is Not Logged In");
      Navigator.pushReplacement(
        context,
        new MaterialPageRoute(builder: (context) => LanguageScreen()),
      );
    }
  }

  // void _checkIfLoggedIn() async{    ///Uncomment it
  //
  //
  //   var url = "${APIConstants.API_BASE_URL_DEV}/api/setting";
  //   Dio dio = new Dio();
  //   var response = await dio.get(url);
  //   SharedPreferences localStorage = await SharedPreferences.getInstance();
  //   localStorage.setInt("order_status",response.data["order_status"] );
  //   localStorage.setInt("branch_status",response.data["branch_status"] );
  //   if(response.data["status"] != 0) {
  //     // check if token is there
  //     var token = localStorage.getString('token');
  //     var branchID = localStorage.getString('branchId');
  //     if (token != null && branchID != null) {
  //       setState(() {
  //         _isLoggedIn = true;
  //         print("User Is Logged In");
  //         _gotoMainpage();
  //       });
  //     } else {
  //       print("User Is Not Logged In");
  //       Navigator.pushReplacement(
  //         context,
  //         new MaterialPageRoute(builder: (context) => GettingStartedScreen()),
  //       );
  //     }
  //   }
  //   else{
  //     Navigator.pushReplacement(
  //       context,
  //       new MaterialPageRoute(builder: (context) => AppSettings()),
  //     );
  //   }
  // }               ///Uncomment it

  // if (!prefs.containsKey('userData')) async => false;

//  checkLoginStatus() async {
//    final prefs = await SharedPreferences.getInstance();
//    if (prefs.getString('access_token') == null) {
//      Navigator.pushReplacement(
//        context,
//        new MaterialPageRoute(builder: (context) => LoginPage()),
//      );
//    }
//    final extractedUserData =
//    json.decode(prefs.getString('userData')) as Map<String, Object>;
//    final expiryDate = DateTime.parse(extractedUserData['expires_in']);
//
//    if (expiryDate.isBefore(DateTime.now())) {
//      return false;
//    }
//  }

  networkChecked() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return 'No Network Connection! Connected to Mobile Network';
      print("Connected to Mobile Network");
    } else if (connectivityResult == ConnectivityResult.wifi) {
      print("Connected to WiFi");
      return 'No WiFi Connection! Please Connected to WiFi';
    } else {
      isOffline = false;
      showNoNetworkAlertDialog(context);
      print("Unable to connect. Please Check Internet Connection");
    }
  }

  Future<void> showNoNetworkAlertDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Connection Alert!'),
          content: Text('Unable to connect. Please Check Internet Connection'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
//                Navigator.pushReplacement(
//                  context,
//                  new MaterialPageRoute(builder: (context) => MainScreen()),
//                );
              },
            ),
          ],
        );
      },
    );
  }

  void connectionChanged(dynamic hasConnection) {
    setState(() {
      isOffline = !hasConnection;
    });
  }

  void _gotoMainpage() {
    Navigator.pushReplacement(
      context,
      new MaterialPageRoute(builder: (context) => MainScreen(0)),
    );
  }

  // void _gotoLoginPage(){
  //   Navigator.pushReplacement(
  //     context,
  //     new MaterialPageRoute(builder: (context) => LoginPage()),
  //   );
  //
  // }

  //------------------------------------------------------------------------------
//  void _handleTapEvent() async {
//    bool isLoggedIn = await AppSharedPreferences.isUserLoggedIn();
//    if (this.mounted) {
//      setState(() {
//        if (isLoggedIn != null && isLoggedIn) {
//          Navigator.pushReplacement(
//            context,
//            new MaterialPageRoute(builder: (context) => LocationPage()),
//          );
//        } else {
//          Navigator.pushReplacement(
//            context,
//            new MaterialPageRoute(builder: (context) => LoginPage()),
//          );
//        }
//      });
//    }
//  }
//------------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Container(
//          width: 250,
//          height: 250,
      decoration: BoxDecoration(
          //shape: BoxShape.circle,
          image: DecorationImage(
            image: AssetImage('images/logo.jpeg'),
            // colorFilter: new ColorFilter.mode(
            //     Colors.black.withOpacity(0.2), BlendMode.darken),
            fit: BoxFit.contain,
          ),
          color: Colors.white),
      // child: Center(
      //   child: Image.asset(
      //     "images/logo.jpeg",
      //     height: MediaQuery.of(context).size.height * .3,
      //   ),
      // ),
    );
  }
}
