import 'dart:async';
import 'dart:convert';
import 'dart:ui';
// import 'package:Salwa_garden/pages/forgot_password.dart';
// import 'package:Salwa_garden/pages/home_page.dart';
import 'package:brqtrapp/screens/department_screen.dart';
import 'package:brqtrapp/screens/forgot_password_screen.dart';
import 'package:brqtrapp/screens/main_screen.dart';
import 'package:brqtrapp/screens/mobile_registration_screen.dart';
import 'package:brqtrapp/screens/register_screen.dart';
import 'package:brqtrapp/utils/constant.dart';
import 'package:connectivity/connectivity.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
// import 'package:Salwa_garden/registerPage/registerScreen.dart';
// import 'package:Salwa_garden/screens/select_branch.dart';
// import 'package:Salwa_garden/utils/constant.dart';
//import 'package:Salwa_garden/userLocation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
//import 'package:wc_form_validators/wc_form_validators.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _token;
  String countryCodes;
  bool loginType = false;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;
  bool isOffline = false;
  bool showpassword = true;
  Country countries;
  List<bool> _selection = [true, false];
  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  @override
  void initState() {
    // TODO: implement initState
    networkChecked();
    countryCodes = "+962";

    super.initState();
  }

  countryPicker() {
    showCountryPicker(
      context: context,
      showPhoneCode:
          true, // optional. Shows phone code before the country name.
      onSelect: (Country country) {
        print("Country code: +${country.phoneCode}");
        print("Country code: +${country.countryCode}");
        setState(() {
          countries = country;
          countryCodes = "+${country.phoneCode}";
        });
        print('Select country: $countryCodes');
      },
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  showPassword() {
    if (showpassword == true) {
      setState(() {
        showpassword = false;
      });
    } else {
      setState(() {
        showpassword = true;
      });
    }
  }

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 18.0);

  SharedPreferences sharedPreferences;

  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //GlobalKey<FormState> _key = new GlobalKey();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  bool _validate = false;

  //LoginRequestData _loginData = LoginRequestData();
  bool _obscureText = true;

  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  final TextEditingController numberController = new TextEditingController();

  /// This one commented
  ///
  signIn(String email, password) async {
    setState(() {
      _isLoading = true;
    });
    final String apiURL = (APIConstants.API_BASE_URL_DEV + APIOperations.LOGIN);
    Map<String, dynamic> userData = {
      'UserName': email,
      'Password': password,
    };
    Map<String, String> requestHeaders = {
      'x-api-key': '987654',
      //'Content-type': 'application/json',
      //'Accept': 'application/json',
    };
    final response =
        await http.post(apiURL, body: userData, headers: requestHeaders);
    var jsonData = json.decode(response.body);
    print("Login Response $jsonData");

    if (jsonData['Status'] != false) {
      setState(() {
        _isLoading = false;
      });
      print("SUCCESSFULLY LOGGED IN Message ${jsonData["Message"]}");
      print("SUCCESSFULLY LOGGED IN Token ${jsonData["Response"]['Token']}");

      SharedPreferences localStorage = await SharedPreferences.getInstance();

      localStorage.setString('token', jsonData["Response"]['Token']);
      localStorage.setString('userID', json.encode(jsonData["Response"]['Id']));
      localStorage.setString(
          'userFN', json.encode(jsonData["Response"]['FirstName']));
      localStorage.setString(
          'userLN', json.encode(jsonData["Response"]['LastName']));
      localStorage.setString(
          'userPhone', json.encode(jsonData["Response"]['Mobile']));
      localStorage.setString(
          'userEmailId', json.encode(jsonData["Response"]['Email']));

      Navigator.pushReplacement(
        context,
        new MaterialPageRoute(builder: (context) => MainScreen(0)),
      );
      // print("This is the User Token -  ${localStorage.getString('token')}");

      // var url = APIConstants.API_BASE_URL_DEV + "api/user";
      // Map<String, String> requestHeaders = {
      //   'x-api-key': '987654',
      //   'Content-type': 'application/json',
      //   //'Accept': 'application/json',
      //   //'Authorization': 'Bearer ${jsonData['access_token']}'
      //   //'Authorization': 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjZmMjc2ZGU3YTI1YWE3MDlmOTdiYjcwZDllODY3ZGNjNzllNWRjMzJmOGZlZjNlNWQ1YzhlMzM5YTU5ZjMyNTU2YWNlZWM1YTdlZDc3MjY0In0.eyJhdWQiOiIyIiwianRpIjoiNmYyNzZkZTdhMjVhYTcwOWY5N2JiNzBkOWU4NjdkY2M3OWU1ZGMzMmY4ZmVmM2U1ZDVjOGUzMzlhNTlmMzI1NTZhY2VlYzVhN2VkNzcyNjQiLCJpYXQiOjE1ODA1NDM5ODUsIm5iZiI6MTU4MDU0Mzk4NSwiZXhwIjoxNjEyMTY2Mzg1LCJzdWIiOiIxMzIiLCJzY29wZXMiOltdfQ.h33_EIU37oXVwrBR3bU6Y7NzyoM4m1wue-09NkDOh4AEimZ9mjjoqxU2fvGEZ_Bo-o6sE5hNg_84bJ-WctedsnoEdwNSPt1O_1SWIrIFhyU5vvv1i9HyBIKx_l4uZLcC-C52TxxvO2awQrrDHPxcbAsyqqa7Z3jh02dAN91r-6Oe0XaH6OV-FabwSMdsWh028GxuIzJwATfHA_zPfDtIquG1TBLc7Q9cFOzlio7IOy3tOLCxVL4f_vt-aOwVF0C0M_eTgk8znI7nTpWk3TgKN_OjRegxbkSGXrS59SIMNZUhMBI1j1vmzSFmRlpEZ8vj5csFxnmTv9oT5tLviD06y8TIISHifpUMI4z2o4rg_qFQbHTAkf37pw2TCfsbzL5sIWMFwWNvbpeKmplurcsnqbzcXl7STqrHftWEwxz6a4Cjrt2fCcxWAkS3CzraANhMkDFuS9oaRqLGfGsZytOZVLTYzQi3HanEip_NqhtEDLhkiEZ6LSJg9CSkk9q9gjruM3zs-l_GijkwJZpdgHwb06SXQb1hF8sS-pcXMwKHU-nF9zKoYZYjodSLaawFtNleylQqZO1mg9gK0XEoMHqm1NXdJH54mqSjoIKmDtKPbmGINzERRB6Cls0pHjC5Z82JBZ9g7xwmOJbMGdN7i2rZhOzs4Mq-eT85nsP2-SNPiJE'
      // };
      // final response = await http.get(url,headers: requestHeaders);
      // var res =json.decode(response.body);
      // localStorage.setString('name', res["name"]);
      // Navigator.of(context).pushAndRemoveUntil(
      //     MaterialPageRoute(builder: (BuildContext context) => HomeScreen()),
      //         (Route<dynamic> route) => false);
    } else {
      setState(() {
        _isLoading = false;
        //print("UNSUCCESSFULLY LOGGED IN Message ${response.body}");
      });
      showLoginAlertDialog(context);
    }
    //showLoginAlertDialog(context);
  }

  Future<void> showLoginAlertDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Invalid Credentials!'),
          content: Text('Try Again With Valid Credentials!'),
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

  networkChecked() async {
    // countryPicker();
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

  Widget _logButton(context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * .85,
      height: MediaQuery.of(context).size.height * .09,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: BorderSide(color: Theme.of(context).accentColor)),
        onPressed: () {
          // setState(() {
          //   emailController.text="$countryCodes ${emailController.text}";
          // });
          String em = "$countryCodes${emailController.text}";
          print("updated email controller: $em");
          if (numberController.text.isEmpty) {
            signIn(em, passwordController.text);
          } else {
            print("my email: ${numberController.text}");
            signIn(numberController.text, passwordController.text);
          }
          // if (_key.currentState.validate()) {
          //
          //   //_isLoading = true;
          //
          // } else {
          //   //showLoginAlertDialog(context);
          //   setState(() {
          //     _validate = true;
          //   });
          //showLoginAlertDialog(context);
          // }
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
                translator.translate('Login'),
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

  Widget _loginButton() {
    return Material(
      // elevation: 5.0,
      borderRadius: BorderRadius.circular(UIsizes.INPUT_BUTTON_BORDER_RADIUS),
      color: Theme.of(context).primaryColor,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        height: 60.0,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          if (_key.currentState.validate()) {
            signIn(emailController.text, passwordController.text);
            //_isLoading = true;

          } else {
            //showLoginAlertDialog(context);
            setState(() {
              _validate = true;
            });
            //showLoginAlertDialog(context);
          }
        },
        child: _isLoading
            ? CircularProgressIndicator()
            : Text(translator.translate('Login'),
                textAlign: TextAlign.center,
                style: style.copyWith(
                    color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _guestButton() {
    return SizedBox(
      width: double.infinity,
      height: 60.0,
      child: Material(
        borderRadius: BorderRadius.circular(8),
        //color: Color(0xffea232d),
        child: OutlineButton(
          //highlightColor: Theme.of(context).primaryColor,
          //highlightedBorderColor: Theme.of(context).primaryColor,
          highlightElevation: 4.0,
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(
                  UIsizes.INPUT_BUTTON_BORDER_RADIUS)),

          //color: Theme.of(context).primaryColor,
          //borderSide: BorderSide(color: Theme.of(context).primaryColor),

          // minWidth: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          onPressed: () {
            // Navigator.of(context)
            //     .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
            //   return HomePage(); //MyHomePage();
            // }));
          },
          child: Text("GUEST USER",
              textAlign: TextAlign.center,
              style: style.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget buildForgotPasswordBtn() {
    return Container(
      alignment: Alignment.centerRight,
      child: FlatButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
              return ForgotPassword();
            }));
          },
          padding: EdgeInsets.only(right: 0.0),
          child: Text(translator.translate('Forgot Password?'),
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold))),
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

  Widget buildSignupBtn() {
    return GestureDetector(
      onTap: () => {
        Navigator.of(context)
            .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
          return MobileRegistration();
        })),
      }, //print('Sign Up Button Pressed'),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: translator.translate('Do not have an Account?'),
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: translator.translate('Sign Up'),
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).accentColor,
      // ),

      body: new Stack(fit: StackFit.expand, children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
              //padding: const EdgeInsets.all(30.0),
              child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Form(
                key: _key,
                autovalidate: _validate,
                //child: buildEmailTF(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    //SizedBox(height: 20.0),
                    // Text("Welcome Back! You’ve Been Missed", style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold,color: Theme.of(context).primaryColor,),),
                    // SizedBox(
                    //   height: 20.0,
                    // ),
                    logoImage(),
                    // Padding(
                    //   padding: const EdgeInsets.all(3.0),
                    //   child: Container(
                    //     //alignment: Alignment.topLeft,
                    //     child: Text(
                    //       translator.translate('Login'),
                    //       style: TextStyle(
                    //           color: Colors.white,
                    //           fontSize: 25.0,
                    //           fontWeight: FontWeight.bold),
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Text(
                      translator.translate('Login By'),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    _toggleButton(),
                    SizedBox(
                      height: 15.0,
                    ),

                    // Text(
                    //   "OR",
                    //   style: TextStyle(
                    //       color: bluecolor,
                    //       fontSize: 18,
                    //       fontWeight: FontWeight.bold),
                    // ),
                    // SizedBox(
                    //   height: 15.0,
                    // ),
                    _selection[1] == true ? mobileToggle() : emailToggle()
                    //  Container(
                    //   width: MediaQuery.of(context).size.width*.6,
                    //   height: MediaQuery.of(context).size.height*.08,
                    //   child: Column(
                    //     children: [
                    //       Row(
                    //         children: [
                    //           // GestureDetector(
                    //           //   onTap: ()
                    //           //   {
                    //           //
                    //           //   },
                    //           //   child: Text("Country",style: TextStyle(
                    //           //     color: bluecolor,
                    //           //     fontWeight: FontWeight.bold,
                    //           //     fontSize: 20
                    //           //   ),),
                    //           // ),
                    //           //
                    //
                    //         ],
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    //
                    ,
                    SizedBox(
                      height: 15.0,
                    ),

                    Container(
                      alignment: Alignment.centerLeft,
                      width: MediaQuery.of(context).size.width * .85,
                      height: MediaQuery.of(context).size.height * .09,
                      //height: 60.0,
                      child: TextFormField(
                        // autovalidate:true,
                        //key: _formKey,
                        //maxLength: 10,
                        controller: passwordController,
                        validator: (String value) {
                          String pattern =
                              r'(^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{6,}$)';
                          RegExp regExp = new RegExp(pattern);
                          if (value.isEmpty) {
                            return "Password is Required";
                          }
//                } else if (!regExp.hasMatch(value)) {
//                  return "Password at least one uppercase letter, one lowercase letter and one number";
//                }
                          return null;
                        },
                        obscureText: showpassword,
                        style: TextStyle(
                          color: Colors.black,
                          //fontFamily: 'OpenSans',
                        ),
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () => {showPassword()},
                              icon: Icon(
                                Icons.visibility,
                                color: showpassword
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey,
                              ),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(
                                    UIsizes.INPUT_BUTTON_BORDER_RADIUS))),
                            labelText: translator.translate('Password*'),
                            prefixIcon: Container(
                                width: MediaQuery.of(context).size.width * .2,
                                height:
                                    MediaQuery.of(context).size.height * .07,
                                padding: EdgeInsets.all(4),
                                // margin: EdgeInsets.only(left: 15),

                                child: Icon(Icons.lock_open)),
                            labelStyle:
                                TextStyle(fontSize: 15, color: Colors.black)),
                      ),
                    ),

                    //registerButton(),
//                    SizedBox(
//                      height: 15.0,
//                    ),
//                    buildSignupBtn(),
                    SizedBox(height: 20.0),
                    //_loginButton(),
                    _logButton(context),
                    SizedBox(height: 10.0),
                    //_guestButton(),
                    buildForgotPasswordBtn(),
                    //SizedBox(height: 10.0),
                    Center(child: buildSignupBtn()),
                  ],
                ),
              ),
            ),
          )),
        ),
      ]),
    );
  }

  Widget emailToggle() {
    return Container(
      width: MediaQuery.of(context).size.width * .85,
      height: MediaQuery.of(context).size.height * .09,
      child: TextFormField(
        controller: emailController,
        onTap: () {
          numberController.clear();
        },
        keyboardType: TextInputType.number,
        // maxLength: 9,
        style: TextStyle(color: Colors.black
            //   fontFamily: 'SFUIDisplay'
            ),
        // validator: (String value) {
        //   String pattern =
        //       r'^(([^&lt;&gt;()[\]\\.,;:\s@\"]+(\.[^&lt;&gt;()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
        //   RegExp regExp = new RegExp(pattern);
        //   if (value.isEmpty) {
        //     return "Mobile Number is Required";
        //   }
        //   return null;
        // },
        // keyboardType: TextInputType.visiblePassword,
        //obscureText: true,
        decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                    Radius.circular(UIsizes.INPUT_BUTTON_BORDER_RADIUS))),
            labelText: translator.translate('Mobile Number'),
            prefixIcon: GestureDetector(
                onTap: () {
                  countryPicker();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * .2,
                  height: MediaQuery.of(context).size.height * .07,
                  padding: EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          countryCodes == null
                              ? Icon(
                                  Icons.arrow_drop_down_circle_outlined,
                                  size: 30,
                                )
                              : Text("$countryCodes")
                        ],
                      ),
                    ],
                  ),
                )),
            counterText: "",
            labelStyle: TextStyle(fontSize: 15, color: Colors.black)),
      ),
    );
  }

  Widget mobileToggle() {
    return Container(
      child: TextFormField(
        controller: numberController,
        onTap: () {
          emailController.clear();
        },
        keyboardType: TextInputType.text,
        // maxLength: 9,
        style: TextStyle(
          color: Colors.black,
          //   fontFamily: 'SFUIDisplay'
        ),
        validator: (String value) {
          // String pattern =
          //     r'^(([^&lt;&gt;()[\]\\.,;:\s@\"]+(\.[^&lt;&gt;()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
          // RegExp regExp = new RegExp(pattern);
          // if (value.isEmpty) {
          //   return "Mobile Number is Required";
          // }
          // return null;
        },
        // keyboardType: TextInputType.visiblePassword,
        //obscureText: true,
        decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                    Radius.circular(UIsizes.INPUT_BUTTON_BORDER_RADIUS))),
            labelText: translator.translate('Email'),
            prefixIcon: Container(
                width: MediaQuery.of(context).size.width * .2,
                height: MediaQuery.of(context).size.height * .07,
                padding: EdgeInsets.all(4),
                // margin: EdgeInsets.only(left: 15),

                child: Icon(Icons.person)),
            //counterText: "",
            labelStyle: TextStyle(fontSize: 15, color: Colors.black)),
      ),
    );
  }

  Widget _toggleButton() {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      width: MediaQuery.of(context).size.width * .85,
      height: MediaQuery.of(context).size.height * .09,
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey, width: 1),
          borderRadius: BorderRadius.circular(30)),
      child: ToggleButtons(
        borderColor: Colors.grey,
        borderRadius: BorderRadius.circular(30),
        hoverColor: Colors.transparent,
        fillColor: Colors.transparent,
        isSelected: _selection,
        onPressed: (int index) {
          setState(() {
            for (int buttonIndex = 0;
                buttonIndex < _selection.length;
                buttonIndex++) {
              if (buttonIndex == index) {
                setState(() {
                  emailController.clear();
                  numberController.clear();
                  _selection[buttonIndex] = true;
                });
                print(_selection);
              } else {
                _selection[buttonIndex] = false;
              }
            }
          });
        },
        renderBorder: false,
        children: <Widget>[
          AnimatedContainer(
              width: MediaQuery.of(context).size.width * .36,
              duration: Duration(microseconds: 10),
              margin: EdgeInsets.all(2),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color:
                      _selection[0] == true ? bluecolor : Colors.transparent),
              child: Center(
                child: Text(
                  "${translator.translate('Mobile No')}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color:
                          _selection[0] == true ? Colors.white : Colors.black),
                ),
              )),
          AnimatedContainer(
            width: MediaQuery.of(context).size.width * .36,
            duration: Duration(microseconds: 10),
            margin: EdgeInsets.all(2),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: _selection[1] == true ? bluecolor : Colors.transparent),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                "${translator.translate('Email')}",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    color: _selection[1] == true ? Colors.white : Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
