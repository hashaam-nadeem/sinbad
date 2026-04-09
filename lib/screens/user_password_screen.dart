import 'package:brqtrapp/screens/loginscreen.dart';
import 'package:brqtrapp/screens/main_screen.dart';
import 'package:brqtrapp/screens/otp_screen.dart';
import 'package:brqtrapp/screens/register_screen.dart';
import 'package:brqtrapp/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:ui';

class UserPassword extends StatefulWidget {
  final userId;

  const UserPassword({Key key, this.userId}) : super(key: key);
  @override
  _UserPasswordState createState() => _UserPasswordState(userId);
}

class _UserPasswordState extends State<UserPassword> {
  final userId;

  //final TextEditingController passwordController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  final TextEditingController confirmpasswordController =
      new TextEditingController();

  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  bool _validate = false;
  bool _isLoading = false;
  var pinCode;
  var mobileNumber;
  bool showpassword = true;
  bool confirmShowPassword = true;

  _UserPasswordState(this.userId);

  @override
  void initState() {
    print('User id in Update password is ===>>>$userId');
    // TODO: implement initState
    //networkChecked();
    super.initState();
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

  confirmedShowPassword() {
    if (confirmShowPassword == true) {
      setState(() {
        confirmShowPassword = false;
      });
    } else {
      setState(() {
        confirmShowPassword = true;
      });
    }
  }

  _sendPasswordNumber() async {
    // setState(() {
    //   _isLoading = true;
    // });
    final String apiURL =
        (APIConstants.API_BASE_URL_DEV + "updateCustomerPassword");
    Map<String, dynamic> userData = {
      'UserId': userId,
      'Password': passwordController.text,
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

    if (jsonData['Status'] == true) {
      //pinCode = jsonData["Data"]['Pin'];
      //mobileNumber = jsonData["Data"]['Mobile'];
      // setState(() {
      //   _isLoading = false;
      // });
      print("SUCCESSFULLY LOGGED IN Message ${jsonData["Message"]}");
      //print("Registered Mobile Number is =====>>>>  ${jsonData["Data"]['Mobile']}");
      //print("Pin sent to Register number is ========>>>> ${pinCode}");

      // SharedPreferences localStorage = await SharedPreferences.getInstance();
      //
      // localStorage.setString('token', jsonData["Response"]['Token']);
      // localStorage.setString('userID', json.encode(jsonData["Response"]['Id']));
      // localStorage.setString('userFN', json.encode(jsonData["Response"]['FirstName']));
      // localStorage.setString('userLN', json.encode(jsonData["Response"]['LastName']));
      // localStorage.setString('userPhone', json.encode(jsonData["Response"]['Mobile']));
      // localStorage.setString('userEmailId', json.encode(jsonData["Response"]['Email']));
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
      //showLoginAlertDialog(context);
    }
    //showLoginAlertDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Theme.of(context).bottomAppBarColor,
      // decoration: BoxDecoration(
      //   //shape: BoxShape.circle,
      //   image: DecorationImage(
      //     image: AssetImage('images/bg.jpeg'),
      //     fit: BoxFit.cover,
      //   ),
      // ),
      body: Center(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                logoImage(),
                SizedBox(
                  height: 80.0,
                ),
                _loginButton(context),
                SizedBox(
                  height: 20.0,
                ),
                // Divider(height: 2,thickness: 2, indent: 60,endIndent: 60,),
                // SizedBox(height: 20.0,),
                // _registrationButton(context),
                // SizedBox(height: 40.0,),
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
    return Material(
      //borderRadius: BorderRadius.circular(30.0),
      child: Form(
        key: _key,
        autovalidate: _validate,
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // SizedBox(
            //   //height: 60,
            //   width: 300,
            //   child: Container(
            //     color: Theme.of(context).accentColor,
            //     child: TextFormField(
            //       controller: passwordController,
            //       keyboardType: TextInputType.emailAddress,
            //       style: TextStyle(
            //         color: Colors.white,
            //         //   fontFamily: 'SFUIDisplay'
            //       ),
            //       validator: (String value){
            //         String pattern =
            //             r'^(([^&lt;&gt;()[\]\\.,;:\s@\"]+(\.[^&lt;&gt;()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
            //         RegExp regExp = new RegExp(pattern);
            //         if (value.isEmpty) {
            //           return "Mobile Number is Required";
            //         }
            //         return null;
            //       },
            //       // keyboardType: TextInputType.visiblePassword,
            //       //obscureText: true,
            //       decoration: InputDecoration(
            //           border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(UIsizes.INPUT_BUTTON_BORDER_RADIUS))),
            //           labelText: translator.translate('Mobile Number*'),
            //           prefixIcon: Icon(Icons.phone),
            //           labelStyle: TextStyle(
            //               fontSize: 15
            //           )
            //       ),
            //     ),
            //   ),
            //
            // ),
            SizedBox(
              width: 300,
              child: Container(
                color: Theme.of(context).bottomAppBarColor,
                child: TextFormField(
                  obscureText: showpassword,
                  controller: passwordController,
                  style: TextStyle(
                    color: Colors.black,
                    //   fontFamily: 'SFUIDisplay'
                  ),
                  validator: (String value) {
                    String pattern =
                        r'(^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{6,}$)';
                    RegExp regExp = new RegExp(pattern);
                    if (value.isEmpty) {
                      return "Password is Required";
                    } else if (value.length < 8) {
                      return "The password must be at least 8 characters.";
                    }
//              } else if (!regExp.hasMatch(value)) {
//                return "Password at least one uppercase letter, one lowercase letter and one number";
//              }
                    return null;
                  },
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
                      labelText: translator.translate('Password'),
                      prefixIcon: Icon(Icons.lock),
                      labelStyle: TextStyle(fontSize: 15)),
                ),
              ),
            ),
//                                       SizedBox(
//                      height: 25.0,
//                    ),
            SizedBox(
              height: 15,
              width: 300,
              child: Container(
                color: Theme.of(context).bottomAppBarColor,
              ),
            ),

            SizedBox(
              width: 300,
              child: Container(
                color: Theme.of(context).bottomAppBarColor,
                child: TextFormField(
                  obscureText: confirmShowPassword,
                  controller: confirmpasswordController,
                  style: TextStyle(
                    color: Colors.black,
                    //   fontFamily: 'SFUIDisplay'
                  ),
                  validator: (String value) {
                    String pattern =
                        r'(^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{6,}$)';
                    RegExp regExp = new RegExp(pattern);
                    if (value.isEmpty) {
                      return "Password is Required";
                    } else if (value.length < 8) {
                      return "The password must be at least 8 characters.";
                    }
//              } else if (!regExp.hasMatch(value)) {
//                return "Password at least one uppercase letter, one lowercase letter and one number";
//              }
                    return null;
                  },
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () => {confirmedShowPassword()},
                        icon: Icon(
                          Icons.visibility,
                          color: confirmShowPassword
                              ? Theme.of(context).primaryColor
                              : Colors.grey,
                        ),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(
                              UIsizes.INPUT_BUTTON_BORDER_RADIUS))),
                      labelText: translator.translate('Confirm Password'),
                      prefixIcon: Icon(Icons.lock),
                      labelStyle: TextStyle(fontSize: 15)),
                ),
              ),
            ),

            // SizedBox(
            //   height: 25.0,
            // ),
          ],
        ),
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

  // Widget _registrationButton(context){
  //   return SizedBox(
  //     height: 60,
  //     width: 300,
  //     child: FlatButton(
  //       onPressed: (){
  //         Navigator.of(context)
  //             .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
  //           return RegisterScreen();
  //         }));
  //
  //       },
  //       child: Text(translator.translate('Register'), style: TextStyle(
  //           color:  Theme.of(context).primaryColor,fontSize: 22
  //       )
  //       ),
  //       textColor: null,
  //       shape: RoundedRectangleBorder(side: BorderSide(
  //           color: Theme.of(context).primaryColor,
  //           width: 2.5,
  //           style: BorderStyle.solid
  //       ), borderRadius: BorderRadius.circular(50)),
  //     ),
  //   );
  // }

  Future<void> showerrorAlertDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(translator.translate('Error!')),
          content: Text(translator.translate('Passwords are not matching!')),
          actions: <Widget>[
//            CupertinoDialogAction(
//              child: Text('Cancel'),
//              onPressed: () {
//                Navigator.of(context).pop();
//              },
//            ),
            CupertinoDialogAction(
              child: Text(translator.translate('Ok')),
              onPressed: () {
                Navigator.of(context).pop();
//                Navigator.of(context).pushAndRemoveUntil(
//                    MaterialPageRoute(
//                        builder: (BuildContext context) => LoginPage()),
//                        (Route<dynamic> route) => false);
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

  Widget _guestButton(context) {
    return SizedBox(
      height: 60,
      width: 300,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: BorderSide(color: Theme.of(context).accentColor)),
        onPressed: () {
          if (_key.currentState.validate()) {
            if (confirmpasswordController.text == passwordController.text) {
              _sendPasswordNumber();
            } else {
              showerrorAlertDialog(context);
            }

            //_isLoading = true;
          } else {
            //showLoginAlertDialog(context);
            setState(() {
              _validate = true;
            });
            //showLoginAlertDialog(context);
          }
        },
        color: Theme.of(context).primaryColor,
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                translator.translate('Update Password'),
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
