import 'dart:async';
import 'package:brqtrapp/screens/user_password_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:ui';
import 'package:brqtrapp/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Otp extends StatefulWidget {
  final pinCode;
  final mobile;
  final String email;
  final String newEmail;
  final bool isGuestCheckOut;
  final bool type;

  const Otp({
    Key key,
    this.type,
    @required this.email,
    this.newEmail = "",
    this.isGuestCheckOut,
    this.pinCode,
    this.mobile,
  }) : super(key: key);

  @override
  _OtpState createState() => new _OtpState(pinCode, mobile);
}

class _OtpState extends State<Otp> with SingleTickerProviderStateMixin {
  // Constants
  final pinCode;
  final mobile;
  final int time = 30;
  AnimationController _controller;
  var otp;
  bool _isLoading = false;
  var userId;

  // Variables
  Size _screenSize;
  int _currentDigit;
  int _firstDigit;
  int _secondDigit;
  int _thirdDigit;
  int _fourthDigit;

  Timer timer;
  int totalTimeInSeconds;
  bool _hideResendButton;

  String userName = "";
  bool didReadNotifications = false;
  int unReadNotificationsCount = 0;

  _OtpState(this.pinCode, this.mobile);

  // Returns "Appbar"
  get _getAppbar {
    return new AppBar(
      title: Text(
        "OTP",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      elevation: 0.0,
      leading: new InkWell(
        borderRadius: BorderRadius.circular(30.0),
        child: new Icon(
          Icons.arrow_back,
          //color: Colors.black54,
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      centerTitle: true,
    );
  }

  // Return "Verification Code" label
  get _getVerificationCodeLabel {
    return new Text(
      pinCode.toString(),
      textAlign: TextAlign.center,
      style: new TextStyle(
          fontSize: 28.0, color: Colors.black, fontWeight: FontWeight.bold),
    );
  }

  // Return "Email" label
  get _getEmailLabel {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
      child: new Text(
        translator.translate("Please enter OTP"),
        textAlign: TextAlign.center,
        style: new TextStyle(
            fontSize: 18.0, color: Colors.black, fontWeight: FontWeight.w600),
      ),
    );
  }

  // Return "OTP" input field
  get _getInputField {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _otpTextField(_firstDigit),
        _otpTextField(_secondDigit),
        _otpTextField(_thirdDigit),
        _otpTextField(_fourthDigit),
      ],
    );
  }

  // Returns "OTP" input part
  get _getInputPart {
    return new Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        //_getVerificationCodeLabel,
        _getEmailLabel,
        _getInputField,
        _getSubmitButton,
        _hideResendButton ? _getTimerText : _getResendButton,
        _getOtpKeyboard
      ],
    );
  }

  // Returns "Timer" label
  get _getTimerText {
    return Container(
      height: 32,
      child: new Offstage(
        offstage: !_hideResendButton,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Icon(Icons.access_time),
            new SizedBox(
              width: 5.0,
            ),
            OtpTimer(_controller, 15.0, Colors.black)
          ],
        ),
      ),
    );
  }

  // Returns "Resend" button

  get _getResendButton {
    return GestureDetector(
      onTap: () => {
        _resendOtpNumber()
        // Navigator.of(context)
        //     .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
        //   return MobileRegistration();
        // })),
      }, //print('Sign Up Button Pressed'),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: translator.translate('Did not get OTP?'),
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 16.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: translator.translate('Resend'),
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // get _getResendButton {
  //   return new InkWell(
  //     child: new Container(
  //       height: 32,
  //       width: 120,
  //       decoration: BoxDecoration(
  //           color: Colors.black,
  //           shape: BoxShape.rectangle,
  //           borderRadius: BorderRadius.circular(32)),
  //       alignment: Alignment.center,
  //       child: new Text(
  //         "Resend OTP",
  //         style:
  //         new TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
  //       ),
  //     ),
  //     onTap: () {
  //       // Resend you OTP via API or anything
  //     },
  //   );
  // }

  get _getSubmitButton {
    return SizedBox(
      height: 60,
      width: 300,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: BorderSide(color: Theme.of(context).accentColor)),
        onPressed: () {
          if (otp != null && otp == pinCode.toString()) {
            _sendMobileNumber();
            print('Entered OTP is equal to Pin Code');
            print("Entered OTP is =====>>>>$otp");
            print("Received OTP is =====>>>>$pinCode");
          } else {
            showLoginAlertDialog(context, "please enter valid OTP");
            print('Entered OTP is Wrong compared with Pin Code');
            print("Entered OTP is =====>>>>$otp");
            print("Received OTP is =====>>>>$pinCode");
          }
        },
        color: Theme.of(context).primaryColor,
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                translator.translate("Submit OTP"),
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

  // get _getSubmitButton {
  //   return new InkWell(
  //     child: new Container(
  //       height: 32,
  //       width: 120,
  //       decoration: BoxDecoration(
  //           color: Theme.of(context).primaryColor,
  //           shape: BoxShape.rectangle,
  //           borderRadius: BorderRadius.circular(32)),
  //       alignment: Alignment.center,
  //       child: new Text(
  //         "Submit OTP",
  //         style:
  //         new TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
  //       ),
  //     ),
  //     onTap: () {
  //       if(otp != null && otp == pinCode.toString()){
  //         _sendMobileNumber();
  //         print('Entered OTP is equal to Pin Code');
  //         print("Entered OTP is =====>>>>$otp");
  //         print("Received OTP is =====>>>>$pinCode");
  //
  //       }else {
  //         showLoginAlertDialog(context);
  //         print('Entered OTP is Wrong compared with Pin Code');
  //         print("Entered OTP is =====>>>>$otp");
  //         print("Received OTP is =====>>>>$pinCode");
  //       }
  //       // Resend you OTP via API or anything
  //     },
  //   );
  // }

  Future<void> showLoginAlertDialog(
      BuildContext context, String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(translator.translate('Invalid')),
          content: Text("$message"),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text(translator.translate('Ok')),
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

  _sendMobileNumber() async {
    // setState(() {
    //   _isLoading = true;
    // });
    final String apiURL = widget.type == false
        ? (APIConstants.API_BASE_URL_DEV + "registerCustomer")
        : (APIConstants.API_BASE_URL_DEV + "registerCustomerWithEmail");
    Map<String, dynamic> userData = widget.type == false
        ? {'Mobile': mobile.toString()}
        : {
            'Email': mobile.toString(),
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
    String message = jsonData['Status'] == true
        ? jsonData['Message']
        : jsonData['Message']['EnResponse'];
    if (jsonData['Status'] == true) {
      userId = jsonData["Id"].toString();

      // setState(() {
      //   _isLoading = false;
      // });
      print("SUCCESSFULLY LOGGED IN Message ${jsonData["Message"]}");
      print("Registered User ID is =====>>>>  ${userId}");
      print("Token for the current user is ========>>>> ${jsonData['Token']}");

      SharedPreferences localStorage = await SharedPreferences.getInstance();
      //
      localStorage.setString('token', jsonData['Token']);
      localStorage.setString('userID', jsonData['Id'].toString());
      // localStorage.setString('userFN', json.encode(jsonData["Response"]['FirstName']));
      // localStorage.setString('userLN', json.encode(jsonData["Response"]['LastName']));
      // localStorage.setString('userPhone', json.encode(jsonData["Response"]['Mobile']));
      // localStorage.setString('userEmailId', json.encode(jsonData["Response"]['Email']));
      Navigator.pushReplacement(
        context,
        new MaterialPageRoute(
            builder: (context) => UserPassword(userId: userId)),
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
      showLoginAlertDialog(context, message);
    }
    //showLoginAlertDialog(context);
  }

  _resendOtpNumber() async {
    setState(() {
      _isLoading = true;
    });
    final String apiURL = widget.type == false
        ? (APIConstants.API_BASE_URL_DEV + "sendCustomerMobileNumber")
        : (APIConstants.API_BASE_URL_DEV + "sendCustomerEmail");
    Map<String, dynamic> userData = widget.type == false
        ? {
            'Mobile': mobile,
          }
        : {
            'Email': mobile,
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
    String message = jsonData['Status'] == true
        ? jsonData['Message']
        : jsonData['Message']['EnResponse'];
    //String message = jsonData['Message']['EnResponse'];
    if (jsonData['Status'] == true) {
      // pinCode = jsonData["Data"]['Pin'];
      // mobileNumber = jsonData["Data"]['Mobile'];
      setState(() {
        _isLoading = false;
      });
      print("SUCCESSFULLY LOGGED IN Message ${jsonData["Message"]}");
      print(
          "Registered Mobile Number is =====>>>>  ${jsonData["Data"]['Mobile']}");
      print("Pin sent to Register number is ========>>>> ${pinCode}");

      // SharedPreferences localStorage = await SharedPreferences.getInstance();
      //
      // localStorage.setString('token', jsonData["Response"]['Token']);
      // localStorage.setString('userID', json.encode(jsonData["Response"]['Id']));
      // localStorage.setString('userFN', json.encode(jsonData["Response"]['FirstName']));
      // localStorage.setString('userLN', json.encode(jsonData["Response"]['LastName']));
      // localStorage.setString('userPhone', json.encode(jsonData["Response"]['Mobile']));
      // localStorage.setString('userEmailId', json.encode(jsonData["Response"]['Email']));

      // Navigator.pushReplacement(
      //   context,
      //   new MaterialPageRoute(builder: (context) => Otp(pinCode:pinCode,mobile:mobileNumber)),
      // );
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
      showLoginAlertDialog(context, "$message");
    }
    //showLoginAlertDialog(context);
  }

  // Returns "Otp" keyboard
  get _getOtpKeyboard {
    return new Container(
        height: _screenSize.width - 80,
        child: new Column(
          children: <Widget>[
            new Expanded(
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _otpKeyboardInputButton(
                      label: "1",
                      onPressed: () {
                        _setCurrentDigit(1);
                      }),
                  _otpKeyboardInputButton(
                      label: "2",
                      onPressed: () {
                        _setCurrentDigit(2);
                      }),
                  _otpKeyboardInputButton(
                      label: "3",
                      onPressed: () {
                        _setCurrentDigit(3);
                      }),
                ],
              ),
            ),
            new Expanded(
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _otpKeyboardInputButton(
                      label: "4",
                      onPressed: () {
                        _setCurrentDigit(4);
                      }),
                  _otpKeyboardInputButton(
                      label: "5",
                      onPressed: () {
                        _setCurrentDigit(5);
                      }),
                  _otpKeyboardInputButton(
                      label: "6",
                      onPressed: () {
                        _setCurrentDigit(6);
                      }),
                ],
              ),
            ),
            new Expanded(
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _otpKeyboardInputButton(
                      label: "7",
                      onPressed: () {
                        _setCurrentDigit(7);
                      }),
                  _otpKeyboardInputButton(
                      label: "8",
                      onPressed: () {
                        _setCurrentDigit(8);
                      }),
                  _otpKeyboardInputButton(
                      label: "9",
                      onPressed: () {
                        _setCurrentDigit(9);
                      }),
                ],
              ),
            ),
            new Expanded(
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new SizedBox(
                    width: 80.0,
                  ),
                  _otpKeyboardInputButton(
                      label: "0",
                      onPressed: () {
                        _setCurrentDigit(0);
                      }),
                  _otpKeyboardActionButton(
                      label: new Icon(
                        Icons.backspace,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          if (_fourthDigit != null) {
                            _fourthDigit = null;
                          } else if (_thirdDigit != null) {
                            _thirdDigit = null;
                          } else if (_secondDigit != null) {
                            _secondDigit = null;
                          } else if (_firstDigit != null) {
                            _firstDigit = null;
                          }
                        });
                      }),
                ],
              ),
            ),
          ],
        ));
  }

  // Overridden methods
  @override
  void initState() {
    totalTimeInSeconds = time;
    super.initState();
    _controller =
        AnimationController(duration: Duration(seconds: time), vsync: this)
          ..addStatusListener((status) {
            if (status == AnimationStatus.dismissed) {
              setState(() {
                _hideResendButton = !_hideResendButton;
              });
            }
          });
    _controller.reverse(
        from: _controller.value == 0.0 ? 1.0 : _controller.value);
    _startCountdown();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    return new Scaffold(
      appBar: _getAppbar,
      backgroundColor: Theme.of(context).accentColor,
      body: new Container(
        width: _screenSize.width,
//        padding: new EdgeInsets.only(bottom: 16.0),
        child: _getInputPart,
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
        onPressed: () {},
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
                translator.translate('Submit OTP'),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).accentColor,
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(context).accentColor,
              )
            ],
          ),
        ),
      ),
    );
  }

  // Returns "Otp custom text field"
  Widget _otpTextField(int digit) {
    return new Container(
      width: 35.0,
      height: 45.0,
      alignment: Alignment.center,
      child: new Text(
        digit != null ? digit.toString() : "",
        style: new TextStyle(
          fontSize: 30.0,
          color: Colors.black,
        ),
      ),
      decoration: BoxDecoration(
//            color: Colors.grey.withOpacity(0.4),
          border: Border(
              bottom: BorderSide(
        width: 2.0,
        color: Colors.black,
      ))),
    );
  }

  // Returns "Otp keyboard input Button"
  Widget _otpKeyboardInputButton({String label, VoidCallback onPressed}) {
    return new Material(
      color: Colors.transparent,
      child: new InkWell(
        onTap: onPressed,
        borderRadius: new BorderRadius.circular(40.0),
        child: new Container(
          height: 80.0,
          width: 80.0,
          decoration: new BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: new Center(
            child: new Text(
              label,
              style: new TextStyle(
                fontSize: 30.0,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Returns "Otp keyboard action Button"
  _otpKeyboardActionButton({Widget label, VoidCallback onPressed}) {
    return new InkWell(
      onTap: onPressed,
      borderRadius: new BorderRadius.circular(40.0),
      child: new Container(
        height: 80.0,
        width: 80.0,
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: new Center(
          child: label,
        ),
      ),
    );
  }

  // Current digit
  void _setCurrentDigit(int i) {
    setState(() {
      _currentDigit = i;
      if (_firstDigit == null) {
        _firstDigit = _currentDigit;
      } else if (_secondDigit == null) {
        _secondDigit = _currentDigit;
      } else if (_thirdDigit == null) {
        _thirdDigit = _currentDigit;
      } else if (_fourthDigit == null) {
        _fourthDigit = _currentDigit;

        otp = _firstDigit.toString() +
            _secondDigit.toString() +
            _thirdDigit.toString() +
            _fourthDigit.toString();

        // Verify your otp by here. API call
      }
    });
  }

  Future<Null> _startCountdown() async {
    setState(() {
      _hideResendButton = true;
      totalTimeInSeconds = time;
    });
    _controller.reverse(
        from: _controller.value == 0.0 ? 1.0 : _controller.value);
  }

  void clearOtp() {
    _fourthDigit = null;
    _thirdDigit = null;
    _secondDigit = null;
    _firstDigit = null;
    setState(() {});
  }
}

class OtpTimer extends StatelessWidget {
  final AnimationController controller;
  double fontSize;
  Color timeColor = Colors.black;

  OtpTimer(this.controller, this.fontSize, this.timeColor);

  String get timerString {
    Duration duration = controller.duration * controller.value;
    if (duration.inHours > 0) {
      return '${duration.inHours}:${duration.inMinutes % 60}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
    }
    return '${duration.inMinutes % 60}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  Duration get duration {
    Duration duration = controller.duration;
    return duration;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: controller,
        builder: (BuildContext context, Widget child) {
          return new Text(
            timerString,
            style: new TextStyle(
                fontSize: fontSize,
                color: timeColor,
                fontWeight: FontWeight.w600),
          );
        });
  }
}
