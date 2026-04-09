import 'package:brqtrapp/screens/loginscreen.dart';
import 'package:brqtrapp/screens/main_screen.dart';
import 'package:brqtrapp/screens/update_profile_screen.dart';
import 'package:brqtrapp/utils/app_shared_preferences.dart';
import 'package:brqtrapp/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:Salwa_garden/login_page.dart';
// import 'package:Salwa_garden/pages/cart_page.dart';
// import 'package:Salwa_garden/pages/order_page.dart';
// import 'package:Salwa_garden/screens/update_profile.dart';
// import 'package:Salwa_garden/userLocation.dart';
// import 'package:Salwa_garden/utils/app_shared_preferences.dart';
// import 'package:Salwa_garden/utils/constant.dart';
import 'dart:io' show Platform;

bool isLoading = true;
Widget _buildProgressIndicator() {
  return new Padding(
    padding: const EdgeInsets.all(8.0),
    child: new Center(
      child: new Opacity(
        opacity: isLoading ? 1.0 : 00,
        child: new CupertinoActivityIndicator(),
      ),
    ),
  );
}

class MyProfile extends StatefulWidget {
  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfile> {
  Map userDetails;
  //List userDetails;
  String address;
  var totalCount;
  var customerId;

  @override
  void initState() {
    _getCartQuantity();
    _getProfileData();
    //_getCartItemCount();
    // TODO: implement initState
    super.initState();
    // _getProfileDetails();
  }
//   void _getCartItemCount() async{
//
//     SharedPreferences localStorage = await SharedPreferences.getInstance();
//     var token = localStorage.getString('token');
//     var branchId = localStorage.getString('branchId');
//
//
//     var url = APIConstants.API_BASE_URL_DEV + "api/cartcount?branch_id=$branchId";
//     Map<String, String> requestHeaders = {
//       'Content-type': 'application/json',
//       'Accept': 'application/json',
//       'Authorization': 'Bearer $token'
//
//     };
//     final response = await http.get(url, headers: requestHeaders);
//     //final List<FavoriteItem> favProducts = [];
//     final favData = json.decode(response.body);
//     print("CARTITEMSCOUNT- $favData");
//     //var favProd = favData['product'];
//     // print('favorite Product Name - $favProd');
//     if(!mounted)return;
//     setState(() {
// //      if(totalCount!=0) {
//       totalCount = favData;
//       //name = localStorage.getString('name');
// //      }else{
// //        totalCount = 0;
// //
// //      }
//       //isLoading = false;
//     });
//
//     //print('data isss $favData["data"]');
//     if (favData == null) {
//       return;
//     }
//     // _favorite = favProducts
//   }

  Future<dynamic> _getCartQuantity() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    customerId = localStorage.getString('userID');
    print('User Id is =====>>>$customerId');

    var url = APIConstants.API_BASE_URL_DEV + "/addToCart?UserId=$customerId";
    Map<String, String> requestHeaders = {
      'x-api-key': '987654',
    };
    final response = await http.get(url, headers: requestHeaders);
    final sliderData = json.decode(response.body);
    print("Numbers of items in cart are->>>>>> $sliderData");
    final qauntityData = sliderData['CartQuantity'];

    if (!mounted) return;
    setState(() {
      totalCount = qauntityData;
    });
  }

  _getProfileData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    customerId = localStorage.getString('userID');
    print('User Id is =====>>>$customerId');

    var url = APIConstants.API_BASE_URL_DEV +
        "/getCustomerDetails?UserId=$customerId";
    Map<String, String> requestHeaders = {
      'x-api-key': '987654',
    };
    final response = await http.get(url, headers: requestHeaders);
    final userData = json.decode(response.body);
    final userDetail = userData['Data'];
    print("All User details are->>>>>> $userDetail");
    //final qauntityData = sliderData['CartQuantity'];

    if (!mounted) return;
    setState(() {
      userDetails = userDetail;
      //totalCount = qauntityData;
    });
  }

  @override
  Widget build(BuildContext context) {
    ///Profile code
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   automaticallyImplyLeading: false,
      //   title: Text(translator.translate('Profile')),

      //   ///leading: Container(),
      //   leading: new IconButton(
      //       icon: Platform.isIOS
      //           ? new Icon(Icons.arrow_back_ios)
      //           : new Icon(Icons.arrow_back),
      //       onPressed: () {
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(builder: (context) => MainScreen(0)),
      //         );
      //       }),
      //   actions: <Widget>[
      //     Stack(
      //       children: <Widget>[
      //         IconButton(
      //           icon: Icon(Icons.shopping_basket),
      //           onPressed: () {
      //             // Navigator.of(context)
      //             //     .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
      //             //   return CartPage();
      //             // }));
      //           },
      //         ),
      //         totalCount == '' || totalCount == null
      //             ? new Container()
      //             : Stack(
      //                 children: <Widget>[
      //                   Container(
      //                     height: 20.0,
      //                     width: 20.0,
      //                     child: Align(
      //                       alignment: Alignment.center,
      //                       child: new Center(
      //                           child: new Text(
      //                         "$totalCount",
      //                         style: new TextStyle(
      //                             color: Colors.white,
      //                             fontSize: 11.0,
      //                             fontWeight: FontWeight.w500),
      //                       )),
      //                     ),
      //                     decoration: BoxDecoration(
      //                         borderRadius:
      //                             BorderRadius.all(Radius.circular(100.0)),
      //                         color: Colors.red),
      //                   ),
      //                 ],
      //               )
      //       ],
      //     )
      //   ],
      //   backgroundColor: Theme.of(context).primaryColor,
      //   elevation: 0.0,
      // ),

      body: isLoading
          ? _buildProgressIndicator()
          : Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              //crossAxisAlignment: CrossAxisAlignment.,
              children: [
                  Container(
                    height: 290.0,
                    child: Container(
                      height: deviceHeight * 0.2,
                      width: deviceWidth * 1.0,
                      //color: Colors.red,
                      child: UserProfilePage(
                        userDeatils: userDetails,
                      ),

                      //_buildUpperContainer(context),
                    ),
                  ),
                  // ),
                  Divider(
                    height: 3.0,
                  ),
                  Expanded(
                    child: Container(
                      //padding: EdgeInsets.all(10.0),
                      height: deviceHeight * 0.5,
                      width: deviceWidth * 1.0,
                      color: Colors.white,
//         child: SingleChildScrollView(
//         ),
                      child: UsersDetails(
                        userDeatils: userDetails,
                      ),
                      //Put your child widget here.
                    ),
                  ),
                ]),
    );
  }
}

///Details of The User Code Start here-->

class UsersDetails extends StatelessWidget {
  final Map userDeatils;
  final address;
  UsersDetails({Key key, this.userDeatils, this.address}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _myListView(context, userDeatils, address);
  }
}

Widget _myListView(BuildContext context, userDetails, address) {
  // final Map position={
  //   "Lat": 25.282028399999998,
  //   "Long": 51.4953696
  // };
  // List placemark = await Geolocator()
  //       .placemarkFromCoordinates(position, position.longitude);
  //   locationController.text =
  //   "${placemark[0].name}, ${placemark[0].subLocality}, ${placemark[0]
  //       .locality}";
  if (userDetails != null) {
    return ListView(
        children: userDetails != null
            ? ListTile.divideTiles(
                context: context,
                tiles: [
                  ListTile(
                    title: userDetails["FirstName"] != ''
                        ? Text('${userDetails["FirstName"]}')
                        : Text(translator.translate("Add Your First Name")),
                    subtitle: Text(translator.translate("FirstName")),
                    leading: Icon(Icons.account_box),
                  ),
                  ListTile(
                    title: userDetails["LastName"] != ''
                        ? Text('${userDetails["LastName"]}')
                        : Text(translator.translate("Add Your Last Name")),
                    subtitle: Text(translator.translate("Last Name")),
                    leading: Icon(Icons.account_box),
                  ),
                  ListTile(
                    title: userDetails["Email"] != null
                        ? Text('${userDetails["Email"]}')
                        : Text(translator.translate("Add Your Email")),
                    subtitle: Text(translator.translate("Email")),
                    leading: Icon(Icons.email),
                  ),
                  ListTile(
                    title: userDetails["Mobile"] != null
                        ? Text('${userDetails["Mobile"]}')
                        : Text(translator.translate("Add Your Mobile")),
                    subtitle: Text(translator.translate("Phone")),
                    leading: Icon(Icons.phone),
                  ),
                  ListTile(
                    title: userDetails["BuildingNo"] != null
                        ? Text('${userDetails["BuildingNo"]}')
                        : Text(translator.translate("Building Number")),
                    subtitle: Text(translator.translate("Building Number")),
                    leading: Icon(Icons.house_rounded),
                  ),
                  ListTile(
                    title: userDetails["Street"] != null
                        ? Text('${userDetails["Street"]}')
                        : Text(translator.translate("Street")),
                    subtitle: Text(translator.translate("Street")),
                    leading: Icon(Icons.streetview_rounded),
                  ),
                  ListTile(
                    title: userDetails["Zone"] != null
                        ? Text('${userDetails["Zone"]}')
                        : Text(translator.translate("Zone")),
                    subtitle: Text(translator.translate("Zone")),
                    leading: Icon(Icons.place),
                  ),
                  ListTile(
                    title: userDetails["Address"] != null
                        ? Text('${userDetails["Address"]}')
                        : Text(translator.translate("Select Your Address")),
                    subtitle: Text(translator.translate("Address")),
                    leading: Icon(Icons.map),
                    // trailing: IconButton(icon: Icon(Icons.edit),
                    //   onPressed:           (){
                    //     // print('Address Changed Button Tap!');
                    //     // Navigator.of(context).push(new MaterialPageRoute(
                    //     //     builder: (BuildContext context) => ShippingAddress()
                    //     // ));
                    //
                    //   },
                    // ),
                  ),
                ],
              ).toList()
            : ListTile.divideTiles(
                context: context,
                tiles: [
                  // ListTile(
                  //   title: Text('Name :'),
                  // ),
                  // ListTile(
                  //   title: Text('Email : '),
                  // ),
                  // ListTile(
                  //   title: Text('Phone : '),
                  // ),

                  // ListTile(
                  //   title: Text('Address : '),
                  // ),
                  // ListTile(
                  //   title: Text('Lat & long : '),
                  // ),
                ],
              ).toList());
  } else {
    return ListView();
  }
}

class UserProfilePage extends StatelessWidget {
  bool isLoading = false;
  final Map userDeatils;
  UserProfilePage({Key key, this.userDeatils}) : super(key: key);

  List _userProfile;
  SharedPreferences sharedPreferences;

  final String _fullName = "Shahid jafrey";
  final String _status = "Software Developer";
  final String _bio =
      "\"Hi, I am a Freelance developer working for hourly basis. If you wants to contact me to build your product leave a message.\"";
  final String _followers = "173";
  final String _posts = "24";
  final String _scores = "450";

  Widget _buildCoverImage(Size screenSize) {
    return Container(
      height: screenSize.height / 2.4,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/logo.jpeg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildProfileImage(userDeatils, context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * .33,
        height: MediaQuery.of(context).size.height * .15,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage('images/logo.jpeg'),
              fit: BoxFit.contain,
            ),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black, blurRadius: 0.5, spreadRadius: 0.1),
            ]
            //    borderRadius: BorderRadius.circular(100.0),
            // border: Border.all(
            //   color: Colors.grey[300],
            //   width: 1.0,
            // ),
            ),
        // child: CircleAvatar(
        //   backgroundColor: Theme.of(context).primaryColor,
        //   radius: 50,
        //   backgroundImage: AssetImage(
        //     'images/logo.jpeg',
        //   ),
        // ),
      ),
    );
  }

  Widget _buildFullName(userDeatils) {
    TextStyle _nameTextStyle = TextStyle(
      fontFamily: 'Roboto',
      color: Colors.black,
      fontSize: 20.0,
      fontWeight: FontWeight.w700,
    );

    return Text(
      userDeatils["FirstName"] != ''
          ? userDeatils["FirstName"]
          : translator.translate("Edit Your Profile!"),
      style: _nameTextStyle,
    );
  }

  // Widget _buildStatus(BuildContext context) {
  //   return Container(
  //     padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
  //     decoration: BoxDecoration(
  //       color: Theme.of(context).scaffoldBackgroundColor,
  //       borderRadius: BorderRadius.circular(4.0),
  //     ),
  //     child: Text(
  //       _status,
  //       style: TextStyle(
  //         fontFamily: 'Spectral',
  //         color: Colors.black,
  //         fontSize: 12.0,
  //         fontWeight: FontWeight.w300,
  //       ),
  //     ),
  //   );
  // }
  //
  // Widget _buildStatItem(String label, String count) {
  //   TextStyle _statLabelTextStyle = TextStyle(
  //     fontFamily: 'Roboto',
  //     color: Colors.black,
  //     fontSize: 16.0,
  //     fontWeight: FontWeight.w200,
  //   );
  //
  //   TextStyle _statCountTextStyle = TextStyle(
  //     color: Colors.black54,
  //     fontSize: 24.0,
  //     fontWeight: FontWeight.bold,
  //   );
  //
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: <Widget>[
  //       Text(
  //         count,
  //         style: _statCountTextStyle,
  //       ),
  //       Text(
  //         label,
  //         style: _statLabelTextStyle,
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildStatContainer(BuildContext context) {
  //   return Container(
  //     height: 50.0,
  //     margin: EdgeInsets.only(top: 8.0),
  //     decoration: BoxDecoration(
  //       color: Color(0xFFEFF4F7),
  //     ),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceAround,
  //       children: <Widget>[
  //         _buildStatItem("Orders", _followers),
  //         _buildStatItem("Posts", _posts),
  //         //_buildStatItem("Location", _scores),
  //         IconButton(
  //           icon: Icon(Icons.location_on),
  //           onPressed: () {
  //             // Navigator.of(context)
  //             //     .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
  //             //   return LocationPage();             }));
  //             // Navigator.push(
  //             //   context,
  //             //   MaterialPageRoute(builder: (context) => LocationPage()),
  //             // );
  //           },
  //         )
  //       ],
  //     ),
  //   );
  // }
  //
  // Widget _buildBio(BuildContext context) {
  //   TextStyle bioTextStyle = TextStyle(
  //     fontFamily: 'Spectral',
  //     fontWeight: FontWeight.w400,
  //     //try changing weight to w500 if not thin
  //     fontStyle: FontStyle.italic,
  //     color: Color(0xFF799497),
  //     fontSize: 16.0,
  //   );
  //
  //   return Container(
  //     color: Theme.of(context).scaffoldBackgroundColor,
  //     padding: EdgeInsets.all(8.0),
  //     child: Text(
  //       _bio,
  //       textAlign: TextAlign.center,
  //       style: bioTextStyle,
  //     ),
  //   );
  // }
  //
  // Widget _buildSeparator(Size screenSize) {
  //   return Container(
  //     width: screenSize.width / 1.6,
  //     height: 2.0,
  //     color: Colors.black54,
  //     margin: EdgeInsets.only(top: 4.0),
  //   );
  // }
  //
  // Widget _buildGetInTouch(BuildContext context) {
  //   return Container(
  //     color: Theme.of(context).scaffoldBackgroundColor,
  //     padding: EdgeInsets.only(top: 8.0),
  //     child: Text(
  //       "Get in Touch with ${_fullName.split(" ")[0]},",
  //       style: TextStyle(fontFamily: 'Roboto', fontSize: 16.0),
  //     ),
  //   );
  // }

  Widget _buildButtons(BuildContext context, userData) {
    ///logout button
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: InkWell(
              onTap: () => {
                _editPage(context, userData),
              },
              child: Container(
                height: 40.0,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(UIsizes.INPUT_BUTTON_BORDER_RADIUS),
                  // border: Border.all(),
                  color: Theme.of(context).primaryColor,
                ),
                child: Center(
                  child: Text(
                    translator.translate("Edit"),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 10.0),
          // Expanded(
          //   child: InkWell(
          //     onTap: () {
          //       _logoutFromTheApp(context);
          //     },
          //     child: Container(
          //       height: 40.0,
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(UIsizes.INPUT_BUTTON_BORDER_RADIUS),
          //
          //         border: Border.all(color: Colors.grey[400]),
          //       ),
          //       child: Center(
          //         child: Padding(
          //           padding: EdgeInsets.all(10.0),
          //           child: Text(translator.translate("Log Out"),
          //             style: TextStyle(fontWeight: FontWeight.w600),
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  void _logoutFromTheApp(context) {
    AppSharedPreferences.clear();
    Navigator.pushReplacement(
      context,
      new MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  void _editPage(context, userdet) {
    //  Map data;
    //  data.addAll({"name":"inshaf","qty":10});
    //  data.addAll({"name":"shki","qty":12});
    //  data.addAll({"name":"bishu","qty":10});
    //  data.addAll({"name":"raja","qty":3});

    //  print(data);
    //          Navigator.pushReplacement(
    //    context,
    //    new MaterialPageRoute(builder: (context) => UpdateProfile(key,userdet)),
    //  );
    Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context) => UpdateProfile(key, userdet)));
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: isLoading ? 1.0 : 00,
          child: new CupertinoActivityIndicator(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      //backgroundColor: Colors.black12,
      body: Stack(
        children: <Widget>[
          //_buildCoverImage(screenSize),
          SafeArea(
            child: userDeatils != null
                ? Column(
                    children: <Widget>[
                      SizedBox(height: 20.0),
                      _buildProfileImage(userDeatils, context),
                      SizedBox(
                        height: 10,
                      ),
                      _buildFullName(userDeatils),
                      SizedBox(
                        height: 20,
                      ),
                      //   _buildStatus(context),
                      // _buildStatContainer(context),
                      _buildButtons(context, userDeatils),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  )
                : _buildProgressIndicator(),
          ),
        ],
      ),
    );
  }
}
