import 'package:flutter/material.dart';

final kHintTextStyle = TextStyle(
  color: Colors.white54,
  fontFamily: 'OpenSans',
);
final redcolor = Color(0xffF16B52);
final bluecolor = Color(0xffF16B52);
final orangecolor = Color(0xffFF9559);
final soilcolor = Color(0xffF5D372);
final redColor = Color(0xffF16B52);
final lightblue = Color(0xff74AAB5);
final brownColor = Color(0xff644C42);
final darkblue = Color(0xff015071);
final kLabelStyle = TextStyle(
  color: Colors.black,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

final kBoxDecorationStyle = BoxDecoration(
  color: Colors.black38,
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);

///////////////////////////////////////////////////////////////////////////////
class APIConstants {
  static const String OCTET_STREAM_ENCODING = "application/json";
  static const String API_BASE_URL_DEMO = "";
  static const String API_BASE_URL_DEV = "http://3.139.170.222/api/br/";
  static const String newbaseApiUrl = "http://3.14.44.2/brQatar/api/br/";
  //static const String API_BASE_URL_DEV =   "";
}

///////////////////////////////////////////////////////////////////////////////
class APIOperations {
  static const String HOME_PAGE = "departments";
  static const String VENDOR_LIST = "vendorList";
  static const String FeatureProducts = "featuredProducts";
  static const String categorieslist = "categories";
  static const String categoriesProductlist = "productsByCategories";
  static const String subCategoryList = "subCategoriesByCategory";
  static const String allProductList = "productsAll";
  static const String NewProducts = "newProducts";
  static const String LOGIN = "customerLogin";
  static const String ADDTOCART = "addToCart";
  static const String REGISTER = "customerRegistration";
  static const String CHANGE_PASSWORD = "";
  static const String SUCCESS = "success";
  static const String FAILURE = "failure";
}

class UIsizes {
  static const INPUT_BUTTON_BORDER_RADIUS = 30.0;
}

///////////////////////////////////////////////////////////////////////////////
class EventConstants {
  static const int NO_INTERNET_CONNECTION = 0;

///////////////////////////////////////////////////////////////////////////////
  static const int LOGIN_USER_SUCCESSFUL = 500;
  static const int LOGIN_USER_UN_SUCCESSFUL = 501;

///////////////////////////////////////////////////////////////////////////////
  static const int USER_REGISTRATION_SUCCESSFUL = 502;
  static const int USER_REGISTRATION_UN_SUCCESSFUL = 503;
  static const int USER_ALREADY_REGISTERED = 504;

///////////////////////////////////////////////////////////////////////////////
  static const int CHANGE_PASSWORD_SUCCESSFUL = 505;
  static const int CHANGE_PASSWORD_UN_SUCCESSFUL = 506;
  static const int INVALID_OLD_PASSWORD = 507;
///////////////////////////////////////////////////////////////////////////////
}

///////////////////////////////////////////////////////////////////////////////
class APIResponseCode {
  static const int SC_OK = 200;
}
///////////////////////////////////////////////////////////////////////////////

class SharedPreferenceKeys {
  static const String IS_USER_LOGGED_IN = "IS_USER_LOGGED_IN";
  static const String USER = "USER";
}

///////////////////////////////////////////////////////////////////////////////
class ProgressDialogTitles {
  static const String IN_PROGRESS = "In Progress...";
  static const String USER_LOG_IN = "Logging In...";
  static const String USER_CHANGE_PASSWORD = "Changing...";
  static const String USER_REGISTER = "Registering...";
}

///////////////////////////////////////////////////////////////////////////////
class SnackBarText {
  static const String NO_INTERNET_CONNECTION = "No Internet Conenction";
  static const String LOGIN_SUCCESSFUL = "Login Successful";
  static const String LOGIN_UN_SUCCESSFUL = "Login Un Successful";
  static const String CHANGE_PASSWORD_SUCCESSFUL = "Change Password Successful";
  static const String CHANGE_PASSWORD_UN_SUCCESSFUL =
      "Change Password Un Successful";
  static const String REGISTER_SUCCESSFUL = "Register Successful";
  static const String REGISTER_UN_SUCCESSFUL = "Register Un Successful";
  static const String USER_ALREADY_REGISTERED = "User Already Registered";
  static const String ENTER_PASS = "Please Enter your Password";
  static const String ENTER_NEW_PASS = "Please Enter your New Password";
  static const String ENTER_OLD_PASS = "Please Enter your Old Password";
  static const String ENTER_EMAIL = "Please Enter your Email Id";
  static const String ENTER_VALID_MAIL = "Please Enter Valid Email Id";
  static const String ENTER_NAME = "Please Enter your Name";
  static const String INVALID_OLD_PASSWORD = "Invalid Old Password";
}

///////////////////////////////////////////////////////////////////////////////
class Texts {
  static const String REGISTER_NOW = "Not Registered ? Register Now !";
  static const String LOGIN_NOW = "Already Registered ? Login Now !";
  static const String LOGIN = "LOGIN";
  static const String REGISTER = "REGISTER";
  static const String PASSWORD = "Password";
  static const String OLD_PASSWORD = "Old Password";
  static const String NEW_PASSWORD = "New Password";
  static const String CHANGE_PASSWORD = "CHANGE PASSWORD";
  static const String LOGOUT = "LOGOUT";
  static const String EMAIL = "Email";
  static const String NAME = "Name";
}
///////////////////////////////////////////////////////////////////////////////
