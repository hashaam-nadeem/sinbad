import 'package:brqtrapp/screens/department_screen.dart';
import 'package:brqtrapp/screens/loginscreen.dart';
import 'package:brqtrapp/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
// import 'package:Salwa_garden/data/http_excepiton.dart';
// import 'package:Salwa_garden/utils/constant.dart';
// import 'package:Salwa_garden/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'dart:ui';

//import 'package:Salwa_garden/validator.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  String _userId;
  bool showpassword = true;
  bool confirmShowPassword = true;

  String get userId {
    return _userId;
  }
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  bool _validate = false;
  bool _isLoading = false;



  final TextEditingController nameController = new TextEditingController();
  final TextEditingController nameLastController = new TextEditingController();
  final TextEditingController numberController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  final TextEditingController confirmpasswordController = new TextEditingController();

  get ConfirmpasswordController => null;

//  var _image;
//
//  Future getImage() async {
//    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
//
//    setState(() {
//      _image = image;
//    });
//  }

//  @override
//  Widget build(BuildContext context) {
//    final emailField = TextField(
//      obscureText: false,
//      style: style,
//      decoration: InputDecoration(
//          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
//          hintText: "Email",
//          //counterStyle: Colors.black,
//          border:
//          OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
//
//    );
//    final passwordField = TextField(
//      obscureText: true,
//      style: style,
//      decoration: InputDecoration(
//          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
//          hintText: "Password",
//          border:
//          OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
//    );

  Future<void> showerrorAlertDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Error'),
          content: Text('Passwords are not matching!'),
          actions: <Widget>[
//            CupertinoDialogAction(
//              child: Text('Cancel'),
//              onPressed: () {
//                Navigator.of(context).pop();
//              },
//            ),
            CupertinoDialogAction(
              child: Text('Ok'),
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

  showPassword(){
    if(showpassword==true){
      setState(() {
        showpassword=false;
      });
    }else{
      setState(() {
        showpassword=true;
      });
    }
  }

  confirmedShowPassword(){
    if(confirmShowPassword==true){
      setState(() {
        confirmShowPassword=false;
      });
    }else{
      setState(() {
        confirmShowPassword=true;
      });
    }
  }

  signUp() async {
    String error;
    setState(() {
      _isLoading = true;
    });
    final String apiURL =
    (APIConstants.API_BASE_URL_DEV + APIOperations.REGISTER);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    //var headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> data = {
      "FirstName": nameController.text,
      "LastName": nameController.text,
      "Mobile":"974${numberController.text}",
      "Email": emailController.text,
      "Password": passwordController.text,
    };
    Map<String, String> requestHeaders = {
      //'Content-type': 'application/json',
      'x-api-key': '987654',
    };
    //var jsonResponse;
    //json.encode(data)
    var response = await http.post(apiURL, body: data, headers: requestHeaders);
    print("Registration Response - =====>>${response.body}");
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print("Registration after json coding - =====>>$jsonResponse");
      //  print(jsonResponse['data']["key"]);


//      jsonResponse.then((onValue){
//        if(onValue != null){
//          onValue.data.forEach((k,v){  // add .data here
//           // print(onValue['AED']);
//            print('$k,$v');
//          });
//        }
//      });

      if (jsonResponse['Status'] == true) {
          print("Message from the response -=========> ${jsonResponse['Message']}");
        setState(() {
          _isLoading = false;
        });

        showRegisterSuccessfullAlertDialog(context);
        SharedPreferences saveUsers = await SharedPreferences.getInstance();
        saveUsers.setString('userId', jsonResponse['Id'].toString());
        saveUsers.setString('userEmail', jsonResponse['Email'].toString());
        saveUsers.setString('userMobile', jsonResponse['Mobile'].toString());
        print("userId Is ---->>> ${saveUsers.getString('userId')}");

      }
      else{
        var errorMessage;
        for (var key in jsonResponse["data"].keys) { print(jsonResponse["data"][key][0]);
        errorMessage =  "${jsonResponse["data"][key][0]}";
        }

        setState(() {
          _isLoading = false;
        });
        showRegisterAlertDialog(context,errorMessage);
//        {
//    var errorMessage = 'Authentication failed';
//    if (error.toString().contains('EMAIL_EXISTS')) {
//    errorMessage = 'This email address is already in use.';
//    } else if (error.toString().contains('email')) {
//    errorMessage = 'This is not a valid email address';
//    } else if (error.toString().contains('WEAK_PASSWORD')) {
//    errorMessage = 'This password is too weak.';
//    } else if (error.toString().contains('contact')) {
//    errorMessage = 'Contacr Number Is Needed!.';
//    } else if (error.toString().contains('INVALID_PASSWORD')) {
//    errorMessage = 'Invalid password.';
//    }
//   // _showErrorDialog(errorMessage);
//    showRegisterAlertDialog(context,errorMessage);
//    }  {
//    const errorMessage =
//    'Could not authenticate you. Please try again later.';
//   // _showErrorDialog(errorMessage);
//    showRegisterAlertDialog(context,errorMessage);
//    }
//
//    setState(() {
//    _isLoading = false;
//    });

//        if (jsonResponse['status'] == false){
//          if (jsonResponse['data']['password'] != null){
//            error = jsonResponse['data']['password'];
//            showRegisterAlertDialog(context, error);
//          } else if (jsonResponse['data']['email'] != null) {
//            error = jsonResponse['data']['email'];
//            showRegisterAlertDialog(context, error);
//          }
//        }

      }
    }
    else {
      setState(() {
        _isLoading = false;
      });

    }
  }

  /// 'Something Went Wrong!, Please Check Your Input Fields And Try Again!'

  Future<void> showRegisterAlertDialog(BuildContext context,error) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Registration Alert!'),
          content: Text('$error'),
          actions: <Widget>[
//            CupertinoDialogAction(
//              child: Text('Cancel'),
//              onPressed: () {
//                Navigator.of(context).pop();
//              },
//            ),
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

  Future<void> showRegisterSuccessfullAlertDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Registered Successfuly!'),
          content: Text('You Have Registered Successfully, Now You Need To Login To Finish The Process!'),
          actions: <Widget>[
//            CupertinoDialogAction(
//              child: Text('Cancel'),
//              onPressed: () {
//                Navigator.of(context).pop();
//              },
//            ),
            CupertinoDialogAction(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (BuildContext context) => LoginPage()),
                        (Route<dynamic> route) => false);
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


  // Password Field widget here
  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            controller: passwordController,
            validator: (String value){
              String pattern = r'(^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{6,}$)';
              RegExp regExp = new RegExp(pattern);
              if (value.isEmpty) {
                return "Password is Required";
              } else if (value.length < 8) {
                return "The password must be at least 8 characters.";}
//              } else if (!regExp.hasMatch(value)) {
//                return "Password at least one uppercase letter, one lowercase letter and one number";
//              }
              return null;
            },
            obscureText: true,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              hintStyle: TextStyle(color: Colors.black),
              //InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.black,
              ),
              hintText: 'Enter your Password',
              //hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget registerButton() {
    return Material(
      // elevation: 5.0,
      //borderRadius: BorderRadius.circular(UIsizes.INPUT_BUTTON_BORDER_RADIUS,),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UIsizes.INPUT_BUTTON_BORDER_RADIUS,),
          side: BorderSide(color: Theme.of(context).accentColor)),
      color: Theme.of(context).primaryColor,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: (){
          setState(() {
            if(_key.currentState.validate()){
              if(confirmpasswordController.text == passwordController.text){
                signUp();
              }
              else{
                showerrorAlertDialog(context);
              }
            }else{
              setState(() {
                _validate = true;
              });
            }
          });

        },

        child: Text("REGISTER",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Theme.of(context).accentColor, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget logoImage() {
    return Container(
//        child: FloatingActionButton(
//             onPressed: getImage,
//              tooltip: 'Pick Image',
//             child: Icon(Icons.add_a_photo),
//      ),
      width: 180,
      height: 180,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          //image: _image == null ? AssetImage('images/DefaultProfile.jpg') : Image.file(_image),
          image: AssetImage('images/applogo.png'),
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
          return LoginPage();
        })),
      }, //print('Sign Up Button Pressed'),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Already have an Account? ',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'SIGN IN',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
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

  Widget buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            controller: emailController,
            validator: (String value){
              String pattern =
                  r'^(([^&lt;&gt;()[\]\\.,;:\s@\"]+(\.[^&lt;&gt;()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
              RegExp regExp = new RegExp(pattern);
              if (value.isEmpty) {
                return "Email is Required";
              } else if (!(value.contains('@'))) {
                return "Invalid Email";
              } else {
                return null;
              }
            },
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(

              hintStyle: TextStyle(color: Colors.black),
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.black,
              ),
              hintText: 'Enter your Email',
              //hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  //Name TextField Widget here

  Widget nameTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          // decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            controller: nameController,
            validator: (String value){
              String pattern =
                  r'^(([^&lt;&gt;()[\]\\.,;:\s@\"]+(\.[^&lt;&gt;()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
              RegExp regExp = new RegExp(pattern);
              if (value.isEmpty) {
                return "Name is Required";
              }
              return null;
            },
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(

              hintStyle: TextStyle(color: Colors.black),
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.person,
                color: Colors.black,
              ),
              hintText: 'Enter your Name',
              //hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  // Name Text Field Widget End here

  // Mobile Number TextField Widget here

//  Widget phoneTextField() {
//    return Column(
//      crossAxisAlignment: CrossAxisAlignment.start,
//      children: <Widget>[
//        Container(
//          alignment: Alignment.centerLeft,
//          decoration: kBoxDecorationStyle,
//          height: 60.0,
//          child: TextFormField(
//            maxLength: 8,
//            controller: numberController,
//            validator: (String value){
//              String pattern =
//                  r'^(([^&lt;&gt;()[\]\\.,;:\s@\"]+(\.[^&lt;&gt;()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
//              RegExp regExp = new RegExp(pattern);
//              if (value.isEmpty) {
//                return "Phone Number is Required";
//              }
//                return null;
//            },
//            keyboardType: TextInputType.phone,
//            style: TextStyle(
//              color: Colors.black,
//              fontFamily: 'OpenSans',
//            ),
//            decoration: InputDecoration(
//
//              hintStyle: TextStyle(color: Colors.black),
//              contentPadding: EdgeInsets.only(top: 14.0),
//              prefixIcon: Icon(
//                Icons.phone,
//                color: Colors.black,
//              ),
//              hintText: 'Enter your Mobile Number',
//              //hintStyle: kHintTextStyle,
//            ),
//          ),
//        ),
//      ],
//    );
//  }

  // Mobile Number TextField Widget End here

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      body: new Stack(fit: StackFit.expand, children: <Widget>[

        Padding(
          padding: const EdgeInsets.all(30.0),
          child: Center(
            //padding: const EdgeInsets.all(30.0),
            child: SingleChildScrollView(
              child: _isLoading
                  ? Center(
                child: CircularProgressIndicator(),
                heightFactor: 20.0,
              )
                  : Form(
                key: _key,
                autovalidate: _validate,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    //SizedBox(height: 20.0),
                    // Text("Let’s Create Your Mr Grill Account", style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold,color: Theme.of(context).primaryColor,),),
                    // SizedBox(
                    //   height: 20.0,
                    // ),
                    logoImage(),

                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      child: TextFormField(
                        controller: nameController,
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          color: Colors.black,
                          //   fontFamily: 'SFUIDisplay'
                        ),
                        validator: (String value){
                          String pattern =
                              r'^(([^&lt;&gt;()[\]\\.,;:\s@\"]+(\.[^&lt;&gt;()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                          RegExp regExp = new RegExp(pattern);
                          if (value.isEmpty) {
                            return "Full Name is Required";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(UIsizes.INPUT_BUTTON_BORDER_RADIUS))),
                            labelText: 'First Name',

                            prefixIcon: Icon(Icons.person_outline),
                            labelStyle: TextStyle(
                                fontSize: 15
                            )
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Container(
                      child: TextFormField(
                        controller: nameLastController,
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          color: Colors.black,
                          //   fontFamily: 'SFUIDisplay'
                        ),
                        validator: (String value){
                          String pattern =
                              r'^(([^&lt;&gt;()[\]\\.,;:\s@\"]+(\.[^&lt;&gt;()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                          RegExp regExp = new RegExp(pattern);
                          if (value.isEmpty) {
                            return "Full Name is Required";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(UIsizes.INPUT_BUTTON_BORDER_RADIUS))),
                            labelText: 'Last Name',

                            prefixIcon: Icon(Icons.person_outline),
                            labelStyle: TextStyle(
                                fontSize: 15
                            )
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),

                    Container(
                      child: TextFormField(
                        maxLength: 8,
                        //  maxLengthEnforced: false,
                        controller: numberController,
                        style: TextStyle(
                          color: Colors.black,
                          //   fontFamily: 'SFUIDisplay'
                        ),
                        validator: (String value){
                          String pattern =
                              r'^(([^&lt;&gt;()[\]\\.,;:\s@\"]+(\.[^&lt;&gt;()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                          RegExp regExp = new RegExp(pattern);
                          if (value.isEmpty ) {
                            return "Phone is Required";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            prefix: Text("+974"),
                            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(UIsizes.INPUT_BUTTON_BORDER_RADIUS))),
                            labelText: 'Phone',
                            prefixIcon: Icon(Icons.call),
                            labelStyle: TextStyle(
                                fontSize: 15
                            )
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 15.0,
                    ),
                    Container(
                      child: TextFormField(
                        controller: emailController,
                        style: TextStyle(
                          color: Colors.black,
                          //   fontFamily: 'SFUIDisplay'
                        ),
                        validator: (String value){
                          String pattern =
                              r'^(([^&lt;&gt;()[\]\\.,;:\s@\"]+(\.[^&lt;&gt;()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                          RegExp regExp = new RegExp(pattern);
                          if (value.isEmpty) {
                            return "Email is Required";
                          }
                          return null;
                        },
                        // keyboardType: TextInputType.visiblePassword,
                        //obscureText: true,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(UIsizes.INPUT_BUTTON_BORDER_RADIUS))),
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email),
                            labelStyle: TextStyle(
                                fontSize: 15
                            )
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),

                    Container(
                      child: TextFormField(
                        obscureText: showpassword,
                        controller: passwordController,
                        style: TextStyle(
                          color: Colors.black,
                          //   fontFamily: 'SFUIDisplay'
                        ),
                        validator: (String value){
                          String pattern = r'(^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{6,}$)';
                          RegExp regExp = new RegExp(pattern);
                          if (value.isEmpty) {
                            return "Password is Required";
                          } else if (value.length < 8) {
                            return "The password must be at least 8 characters.";}
//              } else if (!regExp.hasMatch(value)) {
//                return "Password at least one uppercase letter, one lowercase letter and one number";
//              }
                          return null;
                        },
                        decoration: InputDecoration(
                            suffixIcon:  IconButton(
                              onPressed: () => {
                                showPassword()
                              },
                              icon: Icon(Icons.visibility,color: showpassword?Theme.of(context).primaryColor:Colors.grey,),
                            ),
                            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(UIsizes.INPUT_BUTTON_BORDER_RADIUS))),
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.lock),
                            labelStyle: TextStyle(
                                fontSize: 15
                            )
                        ),
                      ),
                    ),
//                                       SizedBox(
//                      height: 25.0,
//                    ),
                    SizedBox(height: 15,),

                    Container(
                      child: TextFormField(
                        obscureText: confirmShowPassword,
                        controller: confirmpasswordController,
                        style: TextStyle(
                          color: Colors.black,
                          //   fontFamily: 'SFUIDisplay'
                        ),
                        validator: (String value){
                          String pattern = r'(^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{6,}$)';
                          RegExp regExp = new RegExp(pattern);
                          if (value.isEmpty) {
                            return "Password is Required";
                          } else if (value.length < 8) {
                            return "The password must be at least 8 characters.";}
//              } else if (!regExp.hasMatch(value)) {
//                return "Password at least one uppercase letter, one lowercase letter and one number";
//              }
                          return null;
                        },
                        decoration: InputDecoration(
                            suffixIcon:  IconButton(
                              onPressed: () => {
                                confirmedShowPassword()
                              },
                              icon: Icon(Icons.visibility,color: confirmShowPassword?Theme.of(context).primaryColor:Colors.grey,),
                            ),
                            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(UIsizes.INPUT_BUTTON_BORDER_RADIUS))),
                            labelText: translator.translate('Confirm Password'),
                            prefixIcon: Icon(Icons.lock),
                            labelStyle: TextStyle(
                                fontSize: 15
                            )
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 25.0,
                    ),
                    registerButton(),
                    SizedBox(
                      height: 15.0,
                    ),
                    buildSignupBtn(),
                  ],
                ),

              ),
            ),
          ),
        ),
      ]),
    );
  }
}
