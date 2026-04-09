import 'dart:convert';

//import 'package:Salwa_garden/screens/main_screen.dart';
import 'package:brqtrapp/screens/main_screen.dart';
import 'package:brqtrapp/screens/user_profile_screen.dart';
import 'package:brqtrapp/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:Salwa_garden/profile_page.dart';
// import 'package:Salwa_garden/utils/constant.dart';
import 'package:http/http.dart' as http;
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';

// import 'package:google_map_location_picker/google_map_location_picker.dart';

class UpdateProfile extends StatefulWidget {
  final userDetails;
  UpdateProfile(Key key, this.userDetails) : super(key: key);
  @override
  _UpdateProfileState createState() => _UpdateProfileState(userDetails);
}

class _UpdateProfileState extends State<UpdateProfile> {
//  bool _validate =false;
  Map userDetails;
  _UpdateProfileState(this.userDetails);
  var lat;
  var long;
  var city;
  var userId;
  // GoogleMapController mapController;
  // CameraPosition cPosition;

  //List<Marker> allMarkers = [];
  @override
  void initState() {
    lat = userDetails["lat"];
    long = userDetails["lon"];
    if (userDetails["lat"] == null || userDetails["lat"] == 0) {
      lat = 0.000;
      long = 0.000;
    }
    firstName.text = userDetails["FirstName"];
    lastName.text = userDetails["LastName"];
    email.text = userDetails["Email"];
    mobile.text = userDetails["Mobile"];
    building.text = userDetails["BuildingNo"];
    street.text = userDetails["Street"];
    zone.text = userDetails["Zone"];
    address.text = userDetails["Address"];
    userId = userDetails["Id"];

    //  if( lat == 0.000 || long == 0.000 ){
    //       _getCurrentLocation();
    //  }
//    print("new latttt $lat and $long");
//    _center = new LatLng(lat, long);
//    cPosition = CameraPosition(
//      target: _center,
//      zoom: 11.0,
//    );
    //_convertToAddress(lat, long);
    // TODO: implement initState
    super.initState();
//  Map data = widget.userDetails;
//     name.text =data["name"];
//     email.text =data["email"];
//     phone.text =data["contact"];
//     address.text = data["address"];

    // allMarkers.add(Marker(
    //     markerId: MarkerId('myMarker'),
    //     draggable: true,
    //     onTap: () {
    //       print('Marker Tapped');
    //     },
    //     position: _center));
  }

  // void _onMapCreated(GoogleMapController controller) {
  //   setState(() {
  //     mapController = controller;
  //     mapController.setMapStyle('[ { "featureType": "administrative", "elementType": "geometry", "stylers": [ { "visibility": "off" } ] }, { "featureType": "poi", "stylers": [ { "visibility": "off" } ] }, { "featureType": "road", "elementType": "labels.icon", "stylers": [ { "visibility": "off" } ] }, { "featureType": "transit", "stylers": [ { "visibility": "off" } ] } ]');
  //
  //
  //   });
  //   //mapController = controller;
  // }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController firstName = new TextEditingController();
  TextEditingController lastName = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController mobile = new TextEditingController();
  TextEditingController building = new TextEditingController();
  TextEditingController street = new TextEditingController();
  TextEditingController zone = new TextEditingController();
  TextEditingController address = new TextEditingController();

// LocationResult result = await showLocationPicker(context, apiKey);
  _ontextChanged() {
    setState(() {
      userDetails["name"] = firstName.text;
    });
  }

  _updateDetails() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    //userId = localStorage.getString('userID');
    //localStorage.setString('name', name.text);
    //var userId = userDetails["id"];
    //print(userId);

    Map<String, String> requestHeaders = {
      'x-api-key': '987654',
      //'Accept': 'application/json',
      //'Authorization': 'Bearer $token'
    };
    Map data = {
      'UserId': userId.toString(),
      'FirstName': firstName.text,
      'LastName': lastName.text,
      'Email': email.text,
      'AlternativeMobile': mobile.text,
      'BuildingNo': building.text,
      'Street': street.text,
      'Zone': zone.text,
      'Address': address.text,
    };
    //var jsonResponse;
    final apiURL = APIConstants.API_BASE_URL_DEV + "updateCustomerDetails";
    var response = await http.post(apiURL, body: data, headers: requestHeaders);
    var res = json.decode(response.body);
    print("User Profile update response is ====>>$res");
    if (res['Status'] == true) {
      showAlertDialog(context);

      // final snackBar = SnackBar(
      //   content: Text(res['Message']['EnResponse']),
      //
      // );

      //_scaffoldKey.currentState.showSnackBar(snackBar);
      //Navigator.of(context).pop();

      //        Future.delayed(const Duration(seconds: 5), () {
      //        print("hello");
      // });
      //     Navigator.pushReplacement(
      //        context,
      //        new MaterialPageRoute(builder: (context) => MyProfilePage()),
      //      );

    } else {
      showOrderNotPlacedAlertDialog(context);
      // final snackBar = SnackBar(
      //   content: Text(res['Message']['EnResponse']),
      // );
      // _scaffoldKey.currentState.showSnackBar(snackBar);
    }
  }

  Future<void> showOrderNotPlacedAlertDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Profile Not Updated!'),
          content: Text(
              'Email Already Taken By Other User, Please try with other Email'),
          actions: <Widget>[
            // CupertinoDialogAction(
            //   child: Text('Cancel'),
            //   onPressed: () {
            //     Navigator.of(context).pop();
            //   },
            // ),
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

  Future<void> showAlertDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Updated!'),
          content: Text('Your Profile Updated Successfully'),
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
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => MyProfilePage()));
                //Navigator.of(context).pop();
                // setState(() {
                //   checkOutData = [];
                // });
                //print("Cart is Empty Now. $checkOutData");
                // Navigator.pushReplacement(
                //   context,
                //   new MaterialPageRoute(builder: (context) => MainScreen()),
                // );
                ///Navigator.pushReplacementNamed(context, '/MainScreen');
              },
            ),
          ],
        );
      },
    );
  }

  // _convertToAddress(lat,long)async{
  //   final coords =  new LatLng(lat, long);
  //   List placemark = await Geolocator()
  //       .placemarkFromCoordinates(coords.latitude, coords.longitude);
  //   //locationController.text =
  //   // "${placemark[0].name}, ${placemark[0].subLocality}, ${placemark[0].locality}";
  //   setState(() {
  //     city =placemark[0].name;
  //   });
  //   // city =placemark[0].name;
  //   print(placemark[0].subLocality);
  //   print(placemark[0].locality);
  //   print(placemark[0].country);
  //   print(placemark[0].position);
  // }
  //
  // _handleTap(LatLng point) {
  //   lat = point.latitude;
  //   long = point.longitude;
  //   setState(() {
  //     _center = point;
  //     allMarkers.add(Marker(
  //         markerId: MarkerId('myMarker'),
  //         draggable: true,
  //         onTap: () {
  //           print('Marker Tapped');
  //         },
  //         position: _center));
  //   });
  //   // setState(() {
  //   //   allMarkers.add(Marker(
  //   //     markerId: MarkerId(point.toString()),
  //   //     position: point,
  //   //     infoWindow: InfoWindow(
  //   //       title: 'I am a marker',
  //
  //   //     ),
  //   //     icon:
  //   //         BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
  //   //   ));
  //   // });
  // }
  //
  // void _getCurrentLocation() async {
  //   final position = await Geolocator()
  //       .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  //
  //   print(position);
  //   cPosition = CameraPosition(
  //     target: LatLng(position.latitude, position.longitude),
  //     zoom: 11.0,
  //   );
  //   setState(() {
  //     lat = position.latitude;
  //     long = position.longitude;
  //     _center = new LatLng(lat, long);
  //     mapController.animateCamera(CameraUpdate.newCameraPosition(cPosition));
  //
  //     allMarkers.add(Marker(
  //         markerId: MarkerId('myMarker'),
  //         draggable: true,
  //         onTap: () {
  //           print('Marker Tapped');
  //         },
  //         position: _center));
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0.0,
        // leading: IconButton(
        //     icon: Icon(Icons.arrow_back_ios, color: Colors.white),
        //     onPressed: () {
        //       Navigator.of(context).pop();
        //     },
        //   ),
        title: Text("Edit Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 15,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: "First Name",
                  // errorText: _validate ? 'Value Can\'t Be Empty' : null,
                  border: new OutlineInputBorder(
                    //borderRadius: new BorderRadius.circular(UIsizes.INPUT_BUTTON_BORDER_RADIUS),
                    borderSide: new BorderSide(),
                  ),
                  focusColor: Colors.red,
                ),
                controller: firstName,
                onChanged: _ontextChanged(),
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: "Last Name",
                  border: new OutlineInputBorder(
                    //borderRadius: new BorderRadius.circular(UIsizes.INPUT_BUTTON_BORDER_RADIUS),
                    borderSide: new BorderSide(),
                  ),
                ),
                controller: lastName,
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: "Email",
                  border: new OutlineInputBorder(
                    //borderRadius: new BorderRadius.circular(UIsizes.INPUT_BUTTON_BORDER_RADIUS),
                    borderSide: new BorderSide(),
                  ),
                ),
                controller: email,
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: "Mobile Number",
                  border: new OutlineInputBorder(
                    //borderRadius: new BorderRadius.circular(UIsizes.INPUT_BUTTON_BORDER_RADIUS),
                    borderSide: new BorderSide(),
                  ),
                ),
                controller: mobile,
                //enabled: false,
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: "Building Number",
                  border: new OutlineInputBorder(
                    //borderRadius: new BorderRadius.circular(UIsizes.INPUT_BUTTON_BORDER_RADIUS),
                    borderSide: new BorderSide(),
                  ),
                ),
                controller: building,
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: "Street",
                  border: new OutlineInputBorder(
                    //borderRadius: new BorderRadius.circular(UIsizes.INPUT_BUTTON_BORDER_RADIUS),
                    borderSide: new BorderSide(),
                  ),
                ),
                controller: street,
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: "Zone",
                  border: new OutlineInputBorder(
                    //borderRadius: new BorderRadius.circular(UIsizes.INPUT_BUTTON_BORDER_RADIUS),
                    borderSide: new BorderSide(),
                  ),
                ),
                controller: zone,
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: "Address",
                  border: new OutlineInputBorder(
                    //borderRadius: new BorderRadius.circular(UIsizes.INPUT_BUTTON_BORDER_RADIUS),
                    borderSide: new BorderSide(),
                  ),
                ),
                controller: address,
              ),
//            SizedBox(height: 20,),
//            TextField(decoration: InputDecoration(
//              labelText: "Address",
//              border: new OutlineInputBorder(
//                borderRadius: new BorderRadius.circular(UIsizes.INPUT_BUTTON_BORDER_RADIUS),
//                borderSide: new BorderSide(
//                ),
//              ),
//
//            ),
//              controller: address,
//            ),
              SizedBox(
                height: 15,
              ),
//            Expanded(flex: 3,
//
//              child:
//              Stack(
//                children: <Widget>[
//
//                  GoogleMap(
//                    onMapCreated: _onMapCreated,
//                    initialCameraPosition: cPosition,
//                    markers:Set.from(allMarkers) ,
//                    onTap: _handleTap,
//                  ),
//
//                  Positioned(
//                    bottom: 5.0,
//                    left: MediaQuery.of(context).size.width /3,
//                    right: 5.0,
//                    child: GestureDetector(
//                      onTap: (){
//                        _getCurrentLocation();
//                      },
//                      child: Card(
//                          color: Colors.black54,
//                          elevation: 8.0,
//                          shape: RoundedRectangleBorder(
//                            borderRadius: BorderRadius.circular(8.0),
//                          ),
//                          child: Padding(
//                            padding: const EdgeInsets.all(18.0),
//                            child: Center(child: Row(
//                              children: <Widget>[
//                                Icon(Icons.center_focus_strong, size: 20,color: Colors.white,),
//                                SizedBox(width: 8,),
//                                Text("Get Current Location",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
//                              ],
//                            )),
//                          )
//
//                        // Column(
//                        //   children: <Widget>[
//                        //     Padding(
//                        //       padding: const EdgeInsets.all(5.0),
//                        //       child: city != null? Text(
//                        //         city,
//                        //         style: TextStyle(
//                        //           fontSize: 20.0,
//                        //           fontWeight: FontWeight.bold,
//                        //         ),
//                        //       ) : Text("i"),
//                        //     ),
//                        //     Padding(
//                        //       padding: const EdgeInsets.all(8.0),
//                        //       child: Text(
//                        //           "Lorem Ipsum is simply dy  a type specimen book."),
//                        //     ),
//                        //   ],
//                        // ),
//                      ),
//                    ),)
//                ],
//
//              ),
//            )
            ],
          ),
        )),
      ),
      bottomNavigationBar: _updateButton(),
      // bottomNavigationBar: BottomAppBar(color: Colors.white,
      //   child: SizedBox(
      //     height: 45.0,
      //     width: 300.0,
      //     child: RaisedButton(
      //       padding: EdgeInsets.all(10.0),
      //       onPressed:(){
      //         if(firstName.text != null){
      //           if(lastName.text != null){
      //             _updateDetails();
      //           }else{
      //             final snackBar = SnackBar(
      //               content: Text('Error! Required fields are empty'),
      //             );
      //             _scaffoldKey.currentState.showSnackBar(snackBar);
      //           }
      //
      //         }else{
      //           final snackBar = SnackBar(
      //             content: Text('Error! Required feilds are empty'),
      //           );
      //           _scaffoldKey.currentState.showSnackBar(snackBar);
      //         }
      //
      //       },
      //       child: Text("UPDATE", style: TextStyle(color: Colors.white),),
      //       color: Theme.of(context).primaryColor,),
      //   ),),
    );
  }

  Widget _updateButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 40),
      child: SizedBox(
        height: 50,
        child: FlatButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          color: Theme.of(context).primaryColor,
          onPressed: () {
            if (firstName.text != null) {
              if (lastName.text != null) {
                _updateDetails();
              } else {
                final snackBar = SnackBar(
                  content: Text('Error! Required fields are empty'),
                );
                _scaffoldKey.currentState.showSnackBar(snackBar);
              }
            } else {
              final snackBar = SnackBar(
                content: Text('Error! Required fields are empty'),
              );
              _scaffoldKey.currentState.showSnackBar(snackBar);
            }
          },
          child: Text(
            translator.translate("Update Profile").toUpperCase(),
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
