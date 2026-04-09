// import 'package:Salwa_garden/pages/cart_page.dart';
// import 'package:Salwa_garden/pages/shipping_address.dart';
import 'package:brqtrapp/screens/loginscreen.dart';
import 'package:brqtrapp/screens/main_screen.dart';
import 'package:brqtrapp/utils/constant.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:Salwa_garden/login_page.dart';
// import 'package:Salwa_garden/screens/main_screen.dart';
// import 'package:Salwa_garden/utils/constant.dart';
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
// import 'package:sliding_sheet/sliding_sheet.dart';
import 'dart:io' show Platform;

class FinalCheckOut extends StatefulWidget {
  final getSelectedAddress;
  final shipLatitude;
  final shipLongitude;
  const FinalCheckOut(
      {Key key, this.getSelectedAddress, this.shipLatitude, this.shipLongitude})
      : super(key: key);

  @override
  _FinalCheckOutState createState() =>
      _FinalCheckOutState(getSelectedAddress, shipLatitude, shipLongitude);
}

class _FinalCheckOutState extends State<FinalCheckOut> {
  final getSelectedAddress;
  final shipLatitude;
  final shipLongitude;

  _FinalCheckOutState(
      this.getSelectedAddress, this.shipLatitude, this.shipLongitude);

  TextEditingController address = new TextEditingController();
  TextEditingController textNote = new TextEditingController();
  TextEditingController mobile = new TextEditingController();
  TextEditingController name = new TextEditingController();
  TextEditingController street = new TextEditingController();
  TextEditingController building = new TextEditingController();
  TextEditingController zone = new TextEditingController();
  TextEditingController carName = new TextEditingController();
  TextEditingController carNumber = new TextEditingController();

  bool isLoading = false;
  bool _isLoggedIn = false;
  Map userDetails;
  List checkOutData = [];
  Map addressListData;
  String userName;
  String userContact;
  String userAddress = 'No Address Required for Pickup';
  String userEmail;
  String latitude = '0.0';
  String longitude = '0.0';
  String newRouteName = "checkOut";
  String _dropDownValue = "Delivery";
  String _date =
      '${DateTime.now().year} - ${DateTime.now().month} - ${DateTime.now().day}';
  String _time =
      '${DateTime.now().hour} : ${DateTime.now().minute} : ${DateTime.now().second}';

  var customerId;

  double totalAmount = 0.0;
  var lang;
  var langChanged;

  _getTotal(data) {
    double total = 0;
//    checkOutData.forEach((key, cartItem) {
//      total += cartItem.price * cartItem.quantity;
//    });
    for (var i = 0; i < data.length; i++) {
      total +=
          (double.parse(data[i]['Price'].toString())) * (data[i]['Quantity']);
      //print(data[i]['product']['branch']['price'][0]['price']);
    }
    setState(() {
      totalAmount = total;
    });
    print("total ammmmmmm iss ${total}");
  }

  int _quantityCount = 1;

  void _add(price, index, qty) {
    setState(() {
      print(price);
      _quantityCount++;
      checkOutData[index]['Quantity'] = qty + 1;
      totalAmount = totalAmount + double.parse(price.toString());
    });
  }

  void _minus(price, index, qty) {
    setState(() {
      if (qty != 1) {
        //_quantityCount--;
        checkOutData[index]['Quantity'] = qty - 1;
        totalAmount = totalAmount - double.parse(price.toString());
      }
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
      name.text = "${userDetails["FirstName"]}${userDetails["LastName"]}";
      mobile.text = userDetails["Mobile"];
      street.text = userDetails["Street"];
      building.text = userDetails["BuildingNo"];
      zone.text = userDetails["Zone"];
      address.text = userDetails["Address"];
      //totalCount = qauntityData;
    });
  }

  @override
  void initState() {
    super.initState();
    _getCartData();
    _getAddressData();
    _getProfileData();
    // _postPlacedOrderData;
  }

  Future<dynamic> _postPlacedOrderData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    //var token = localStorage.getString('token');

    //SharedPreferences userLocationSaved = await SharedPreferences.getInstance();
    //var localAddr = localStorage.getString('address');
    // if (userAddress != 'No Address Required for Pickup'){
    //   setState(() {
    //     userAddress = localAddr;
    //   });
    //
    // }
    // SharedPreferences saveBranchID = await SharedPreferences.getInstance();
    // var branch = saveBranchID.getString('branchId');
    //
    // SharedPreferences slate = await SharedPreferences.getInstance();
    // double checkOutLat = slate.getDouble('savedLat');
    // print("Saved Latitude CHECKOUT PAGE Is ----> ${slate.getDouble('savedLat')}");
    // //if(latitude != '0.0'){
    // latitude = checkOutLat.toString();
    //
    // // }
    //
    // SharedPreferences slong = await SharedPreferences.getInstance();
    // double checkOutLong = slong.getDouble('savedLong');
    // print("Saved Longitude CHECKOUT PAGE Is ----> ${slong.getDouble('savedLong')}");
    // //if(longitude != '0.0'){
    // longitude = checkOutLong.toString();
    // //}

    var url = APIConstants.API_BASE_URL_DEV + "placeOrder";

    List cartItem = [];
//
    var index;
//    cart.add({'product_id' :checkOutData[index]['product_id']});
//    cart.add({"product_id" : "02" , "name":"", "model":"ab","quantity":"3", "price":"100"});
//    cart.add({"product_id" : "03" , "name":"", "model":"ab","quantity":"3", "price":"100"});

//    'product_id' => $product->product_id,
//    'name' => $product->product->info[0]->name,
//    'model' => $product->product->model,
//    'quantity' => $product->quantity,
//    'price' => $product->subtotal,
    //print("longitude asdfadsfasdfa-$checkOutLong");

    Map<String, dynamic> cartData = {
      //'invoice_prefix': checkOutData[0]['product']['branch']['branch']["invoice_prefix"],
      'UserId': customerId.toString(),
      'Street': street.text,
      'AlternativeMobile': mobile.text,
      'AddressHint': address.text,
      'city': 'Doha',
      'BuildingNo': building.text,
      'TotalAmount': totalAmount.toString(),
      'Zone': zone.text,
      'Notes': textNote.text,
      // 'pickup_date' : _date.toString(),
      // 'pickup_time' : _time.toString(),
      // 'car_number' : carNumber.text,
      // 'car_name' : carName.text,
      // 'type': _dropDownValue,
    };

    Map<String, String> requestHeaders = {
      'x-api-key': '987654',
      //'Content-type': 'application/json',
      //'Accept': 'application/json',
      //'Authorization': 'Bearer $token'
    };
    final response =
        await http.post(url, body: cartData, headers: requestHeaders);
    //if (response == 200) {
    var jsonResponse = json.decode(response.body);
    print("Check Out - ${response.body}");
    if (jsonResponse['Status'] == true) {
      showAlertDialog(context);
      print(jsonResponse['data']);
      setState(() {
        isLoading = false;
        //checkOutData = [];
      });
    } else {
      print('Order is not placed');
      showOrderNotPlacedAlertDialog(context);
      setState(() {
        isLoading = false;
      });
    }
    //}
  }

  Future<void> showOrderNotPlacedAlertDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(translator.translate('Order Not Placed!')),
          content: Text(translator
              .translate('Your Order is Not Placed Yet, Please check Again')),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text(translator.translate('Cancel')),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
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

  /// -------->>>>>Order Confirm order Alert ------->>>>

  Future<void> showAlertDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(translator.translate('Order Placed!')),
          content:
              Text(translator.translate('Your Order is Placed Successfully')),
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
                setState(() {
                  checkOutData = [];
                });
                print("Cart is Empty Now. $checkOutData");
                // Navigator.pushReplacement(
                //   context,
                //   new MaterialPageRoute(builder: (context) => MainScreen()),
                // );
                Navigator.pushReplacementNamed(context, '/MainScreen');
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> showAddressAlertDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Address Alert!'),
          content: Text(
              'Address field should not be Empty, \n Please Select The Address'),
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
              },
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> _deleteCartItem(prodId, qty, price, index) async {
    SharedPreferences saveBranchID = await SharedPreferences.getInstance();
    var brnID = saveBranchID.getString('branchId');
    setState(() {
      isLoading = true;
    });

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    print('Post Prouduct Id - $prodId');
    var url = APIConstants.API_BASE_URL_DEV + "api/cart/$prodId";

    Map<String, dynamic> favItem = {
      'product_id': prodId.toString(),
    };
    Map<String, String> requestHeaders = {
      //'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    final response = await http.delete(url, headers: requestHeaders);
    if (response.statusCode == 200) {
      setState(() {
        totalAmount = totalAmount - (double.parse(price.toString()) * qty);
        print(totalAmount);
        print(price);
        print(qty);

        checkOutData.removeAt(index);
      });
      var jsonResponse = json.decode(response.body);
      print(response.body);
      if (jsonResponse['status'] == true) {
        print(jsonResponse['data']);
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  sumEachPrice(price, qty) {
    var total = price * qty;
    print("priceeisss $price");
    print("priceeisss $qty");

    return total;
  }

  Future<dynamic> _getCartData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    customerId = localStorage.getString('userID');
    lang = localStorage.getString('selectedLanguage');
    langChanged = localStorage.getString('LangSelect');
    setState(() {
      isLoading = true;
    });

    var token = localStorage.getString('token');

    var url = APIConstants.API_BASE_URL_DEV + "viewCart?UserId=$customerId";
    Map<String, String> requestHeaders = {
      'x-api-key': '987654',
      // 'Accept': 'application/json',
      // 'Authorization': 'Bearer $token'
    };
    final response = await http.get(url, headers: requestHeaders);
    final cartData = json.decode(response.body);
    final checkoutData = cartData['Data'];
    print("Check Out Data-=====>>> ${checkoutData}");
    if (!mounted) return;
    setState(() {
      checkOutData = checkoutData;
      _getTotal(checkoutData);
      isLoading = false;
    });

    if (checkOutData == null) {
      return;
    }
  }

  /// // ------------------POST METHOD FOR FAVORITE--------

  Future<dynamic> _getAddressData() async {
    setState(() {
      isLoading = true;
    });

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    var localAddress = localStorage.getString('address');

    var url = APIConstants.API_BASE_URL_DEV + "api/user";
    Map<String, String> requestHeaders = {
      //'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    final response = await http.get(url, headers: requestHeaders);
    final addressData = json.decode(response.body);
    final usrName = addressData['name'];
    final usrContact = addressData['contact'];
    final usrAddress = addressData['address'];
    final usrEmail = addressData['email'];
    final lati = addressData['lat'].toString();
    final longi = addressData['lng'].toString();

    print("Address Data- ${addressData['address']}");
    print("User Name is- ${addressData['name']}");
    setState(() {
      addressListData = addressData;
      userName = usrName;
      name.text = userName;
      userContact = usrContact;
      mobile.text = userContact;
      if (getSelectedAddress == null && localAddress == null) {
        userAddress = usrAddress;
      } else if (getSelectedAddress == null) {
        userAddress = localAddress;
      } else {
        userAddress = getSelectedAddress;
      }
      address.text = userAddress;
      userEmail = usrEmail;
      latitude = lati;
      longitude = longi;
      isLoading = false;
      //_getTotal(addressData);
    });

    if (addressListData == null) {
      return;
    }
  }

  /// --------------------------END HERE------------------

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

//  Widget _confirmOrderAlert(){
//    new CupertinoAlertDialog(
//      title: new Text("Dialog Title"),
//      content: new Text("This is my content"),
//      actions: <Widget>[
//        CupertinoDialogAction(
//          isDefaultAction: true,
//          child: Text("Yes"),
//        ),
//        CupertinoDialogAction(
//          child: Text("No"),
//        )
//      ],
//    );
//  }

  void _checkIfLoggedIn() async {
    // check if token is there
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    if (token != null) {
      setState(() {
        _isLoggedIn = true;
        print("User Is Logged In");
        showConfirmAlertDialog();
      });
    } else {
      print("User Is Not Logged In");
      //showLoginAlertDialog(context);
      _handleClickMe();
//      Navigator.pushReplacement(
//        context,
//        new MaterialPageRoute(builder: (context) => LoginPage()),
//      );
    }
  }

  ///----------------

  Future<void> _handleClickMe() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Login Needed!'),
          content: Text('Your Need To Login To Place this Order'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text('Go To Login'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  new MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> showConfirmAlertDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Confirm Order'),
          content: Text('Would You Like To Continue To Place The Order?'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text('Continue'),
              onPressed: () {
                _postPlacedOrderData();
                //Navigator.pop(context);
                Navigator.of(context).pop();

                /// ----------------------------------------------------------------->>>>>>>>>>>>>
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

  _updateCartItems(prodId, qty) async {
    setState(() {
      isLoading = true;
    });

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    //var userId = userDetails["id"];
    //print(userId);

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    Map data = {
      'quantity': qty.toString(),
//      'product_price_id': priceId.toString(),
    };
    //var jsonResponse;
    final apiURL = APIConstants.API_BASE_URL_DEV + "api/cart/$prodId";
    var response = await http.put(apiURL, body: data, headers: requestHeaders);
    var res = json.decode(response.body);

    if (res['status'] == true) {
      print('Cart has been updated successfully $res');
      print("UPDATED CART DATA - $data,$prodId");
      setState(() {
        isLoading = false;
      });
      final snackBar = SnackBar(
        content: Text('Cart has been updated successfully'),
      );

      // _scaffoldKey.currentState.showSnackBar(snackBar);
      //        Future.delayed(const Duration(seconds: 5), () {
      //        print("hello");
      // });
      //     Navigator.pushReplacement(
      //        context,
      //        new MaterialPageRoute(builder: (context) => MyProfilePage()),
      //      );

    } else {
      final snackBar = SnackBar(
        content: Text('An error occured, try again'),
      );
      // _scaffoldKey.currentState.showSnackBar(snackBar);
    }
  }

  ///-------------

  @override
  Widget build(BuildContext context) {
    // var // bloc = Provider.of<Cart// bloc>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      //resizeToAvoidBottomInset: false,
      //resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        // leading: new IconButton(
        //     icon: Platform.isIOS ? new Icon(Icons.arrow_back_ios) : new Icon(Icons.arrow_back),
        //     onPressed: (){
        //       Navigator.push(context,
        //         MaterialPageRoute(builder: (context) => CartPage()),
        //       );
        //     }
        // ),
        title: Text(
          translator.translate("Check Out"),
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        //elevation: 0.0,
        centerTitle: true,
        elevation: 0.0,
      ),
      body: isLoading
          ? _buildProgressIndicator()
          : checkOutData.length == 0
              ? Center(
                  child: Text(translator
                      .translate("No Items Added Yet, Please Add Some Item!")),
                )
              : SingleChildScrollView(
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * .24,
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: checkOutData.length,
                          itemBuilder: (context, index) {
                            return Card(
                              elevation: 0.0,
                              color: Color(0xffe1e1e1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15.0, vertical: 2.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    /// =============>>>>>>>>COUNTER CODE HERE
                                    Row(
                                      children: <Widget>[
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              UIsizes
                                                  .INPUT_BUTTON_BORDER_RADIUS),
                                          child: Container(
                                            height: 50.0,
                                            width: 50.0,
                                            child: checkOutData[index]['Photo']
                                                        .length !=
                                                    0
                                                ? CachedNetworkImage(
                                                    imageUrl: checkOutData[
                                                                    index]
                                                                ['Photo'] !=
                                                            []
                                                        ? '${checkOutData[index]['Photo']}'
                                                        : Image.asset(
                                                            'images/applogo.png'),
                                                    fit: BoxFit.cover,
                                                    placeholder:
                                                        (context, url) =>
                                                            Image.asset(
                                                      'images/applogo.png',
                                                      fit: BoxFit.cover,
                                                    ),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Image.asset(
                                                      'images/applogo.png',
                                                      fit: BoxFit.cover,
                                                    ), //new Icon(Icons.error),
                                                  )
                                                : Image.asset(
                                                    'images/applogo.png',
                                                    fit: BoxFit.cover,
                                                  ),
//                    decoration: BoxDecoration(
//                        image: DecorationImage(
//                            image: NetworkImage('http://tastytea.tas-taz.com/${checkOutData[index]['product']['image'][0]['src']}'),
////                            image: AssetImage("images/recipeImage/cookiecream.jpg"),
//                            fit: BoxFit.cover),
//                        borderRadius: BorderRadius.circular(35.0),
//                        boxShadow: [
//                          BoxShadow(
//                              color: Colors.black,
//                              blurRadius: 5.0,
//                              offset: Offset(0.0, 2.0))
//                        ]),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10.0,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              //height:,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .4,
                                              child: Card(
                                                elevation: 0.0,
                                                child: lang == "Ar" &&
                                                        langChanged != "English"
                                                    ? Text(
                                                        "${checkOutData[index]['NameAr']}",
                                                        style: TextStyle(
                                                            fontSize: 15.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )
                                                    : Text(
                                                        "${checkOutData[index]['NameEn']}",
                                                        style: TextStyle(
                                                            fontSize: 18.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                              ),
                                            ),
                                            SizedBox(height: 5.0),
                                            Text(
                                              "QAR - ${checkOutData[index]['Price']}",
                                              style: TextStyle(
                                                  fontSize: 12.0,
                                                  color: Theme.of(context)
                                                      .accentColor,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            //SizedBox(height: 5.0),
                                          ],
                                        ),
                                      ],
                                    ),
                                    // SizedBox(
                                    //   width: 20.0,
                                    // ),
                                    // Flexible(
                                    //   child: Column(
                                    //     mainAxisAlignment: MainAxisAlignment.start,
                                    //     crossAxisAlignment: CrossAxisAlignment.start,
                                    //     children: <Widget>[
                                    //       Text(
                                    //         "${checkOutData[index]['product']['meta_title']}",
                                    //         style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                                    //       ),
                                    //       SizedBox(height: 5.0),
                                    //       Text(
                                    //         "QAR - ${checkOutData[index]['price']['price']}",
                                    //         style: TextStyle(
                                    //             fontSize: 16.0,
                                    //             color: Theme.of(context).accentColor,
                                    //             fontWeight: FontWeight.bold),
                                    //       ),
                                    //       SizedBox(height: 5.0),
                                    //     ],
                                    //   ),
                                    // ),
                                    Spacer(
                                      flex: 2,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Text(
                                          " QAR ${sumEachPrice(checkOutData[index]['Price'], checkOutData[index]['Quantity'])}"),
                                    )
//                           Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: <Widget>[
//                               GestureDetector(
//                                 onTap: () {
//                                   // bloc.clear(index);
//                                   //// bloc.removeFromCart(index);
//                                   setState(() {
//                                     _deleteCartItem('${checkOutData[index]['id']}',checkOutData[index]['quantity'],checkOutData[index]['price']['price'],index);
//                                   });
//                                 },
//                                 child: Icon(
//                                   Icons.delete,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                               SizedBox(height: 15.0,),
//                               // Container(
//                               //   decoration: BoxDecoration(
//                               //     border: Border.all(color: Color(0xFFD3D3D3), width: 2.0),
//                               //     borderRadius: BorderRadius.circular(10.0),
//                               //   ),
//                               //   width: 100.0,
//                               //   height: 35.0,
//                               //   child: Padding(
//                               //     padding: EdgeInsets.symmetric(
//                               //       horizontal: 6.0,
//                               //     ),
//                               //     child: Row(
//                               //       crossAxisAlignment: CrossAxisAlignment.center,
//                               //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               //       children: <Widget>[
//                               //         InkWell(
//                               //             onTap: () {
//                               //               _minus(checkOutData[index]['price']['price'],index,checkOutData[index]['quantity']);
//                               //               _updateCartItems(checkOutData[index]['id'], checkOutData[index]['quantity']);
//                               //             },
//                               //             child: Icon(Icons.remove_circle,
//                               //                 color: Color(0xFFD3D3D3))),
//                               //         Text(
//                               //           checkOutData[index]['quantity'].toString(),
//                               //           style: TextStyle(fontSize: 15.0, color: Colors.grey),
//                               //         ),
//                               //         InkWell(
//                               //             onTap: () {
//                               //               _add(checkOutData[index]['price']['price'],index,checkOutData[index]['quantity']);
//                               //               _updateCartItems(checkOutData[index]['id'], checkOutData[index]['quantity']);
//                               //             },
//                               //             child: Icon(Icons.add_circle,
//                               //                 color: Color(0xFFD3D3D3))),
//                               //       ],
//                               //     ),
//                               //   ),
//                               // ),

//                             ],
//                           ),
// //                  GestureDetector(
//                    onTap: () {
//                      // bloc.clear(index);
//                      // bloc.removeFromCart(index);
//                      setState(() {
//                        _deleteCartItem('${checkOutData[index]['id']}',checkOutData[index]['quantity'],checkOutData[index]['product']['branch']['price'][0]['price'],index);
//                      });
//                    },
//                    child: Icon(
//                      Icons.delete,
//                      color: Colors.grey,
//                    ),
//                  ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Container(
                        //height: 450,
                        padding: EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width,
                        // height: MediaQuery.of(context).size.height*.45,
                        child: Column(
                          //  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            SizedBox(
                              height: 10.0,
                            ),
                            Container(
                              height: 40.0,
                              child: TextField(
                                textAlign: TextAlign.start,
                                style: new TextStyle(
                                    fontSize: 14.0,
                                    height: 1.0,
                                    color: Colors.black87),
                                decoration: InputDecoration(
                                  labelText: translator.translate("Full Name"),
                                  border: new OutlineInputBorder(
                                    borderRadius:
                                        new BorderRadius.circular(5.0),
                                    borderSide: new BorderSide(),
                                  ),
                                ),
                                controller: name,
                                //enabled: false,
                              ),
                            ),
                            SizedBox(
                              height: 14.0,
                            ),
                            Container(
                              height: 40.0,
                              child: TextField(
                                enabled: false,
                                textAlign: TextAlign.start,
                                style: new TextStyle(
                                    fontSize: 14.0,
                                    height: 1.0,
                                    color: Colors.black87),
                                decoration: InputDecoration(
                                  labelText:
                                      translator.translate("Mobile Number"),
                                  border: new OutlineInputBorder(
                                    borderRadius:
                                        new BorderRadius.circular(5.0),
                                    borderSide: new BorderSide(),
                                  ),
                                ),
                                controller: mobile,
                                //enabled: false,
                              ),
                            ),
                            SizedBox(
                              height: 14.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 40.0,
                                  width: 100,
                                  child: TextField(
                                    textAlign: TextAlign.start,
                                    style: new TextStyle(
                                        fontSize: 14.0,
                                        height: 1.0,
                                        color: Colors.black87),
                                    decoration: InputDecoration(
                                      labelText: translator.translate("Street"),
                                      border: new OutlineInputBorder(
                                        borderRadius:
                                            new BorderRadius.circular(5.0),
                                        borderSide: new BorderSide(),
                                      ),
                                    ),
                                    controller: street,
                                    //enabled: false,
                                  ),
                                ),
                                SizedBox(
                                  height: 14.0,
                                ),
                                Container(
                                  height: 40.0,
                                  width: 100,
                                  child: TextField(
                                    textAlign: TextAlign.start,
                                    style: new TextStyle(
                                        fontSize: 14.0,
                                        height: 1.0,
                                        color: Colors.black87),
                                    decoration: InputDecoration(
                                      labelText:
                                          translator.translate("Building"),
                                      border: new OutlineInputBorder(
                                        borderRadius:
                                            new BorderRadius.circular(5.0),
                                        borderSide: new BorderSide(),
                                      ),
                                    ),
                                    controller: building,
                                    //enabled: false,
                                  ),
                                ),
                                SizedBox(
                                  height: 14.0,
                                ),
                                Container(
                                  height: 40.0,
                                  width: 100,
                                  child: TextField(
                                    textAlign: TextAlign.start,
                                    style: new TextStyle(
                                        fontSize: 14.0,
                                        height: 1.0,
                                        color: Colors.black87),
                                    decoration: InputDecoration(
                                      labelText: translator.translate("Zone"),
                                      border: new OutlineInputBorder(
                                        borderRadius:
                                            new BorderRadius.circular(5.0),
                                        borderSide: new BorderSide(),
                                      ),
                                    ),
                                    controller: zone,
                                    //enabled: false,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 14.0,
                            ),
                            // SizedBox(
                            //   height: 10.0,
                            // ),
                            Container(
                              height: 40.0,
                              child: TextField(
                                textAlign: TextAlign.start,
                                style: new TextStyle(
                                    fontSize: 14.0,
                                    height: 1.0,
                                    color: Colors.black87),
                                decoration: InputDecoration(
                                  labelText: translator.translate("Address"),
                                  border: new OutlineInputBorder(
                                    borderRadius:
                                        new BorderRadius.circular(5.0),
                                    borderSide: new BorderSide(),
                                  ),
                                ),
                                controller: address,
                              ),
                            ),
                            SizedBox(
                              height: 14.0,
                            ),
                            // SizedBox(
                            //   height: 8.0,
                            // ),
                            TextField(
                              decoration: InputDecoration(
                                labelText: translator.translate("Note!"),
                                border: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(5.0),
                                  borderSide: new BorderSide(),
                                ),
                              ),
                              controller: textNote,
                            ),
                            // SizedBox(
                            //   height: 13.0,
                            // ),
                            Divider(
                              height: 3.0,
                            ),
                            // SizedBox(
                            //   height: 5.0,
                            // ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                // mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    translator.translate("Total"),
                                    style: TextStyle(
                                        color: Color(0xFF9BA7C6),
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    totalAmount.toString(),
                                    style: TextStyle(
                                        color: Color(0xFF6C6D6D),
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
      bottomNavigationBar: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * .17,
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                _checkIfLoggedIn();
                // if(userAddress != null || _dropDownValue == "Pickup"){
                //   _checkIfLoggedIn();
                // }else{
                //   showAddressAlertDialog(context);
                // }
              },
              child: Container(
//                padding: EdgeInsets.only(left: 10, right: 10),
                height: 50.0,
                width: MediaQuery.of(context).size.width * .85,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius:
                      BorderRadius.circular(UIsizes.INPUT_BUTTON_BORDER_RADIUS),
                ),
                child: Center(
                  child: Text(
                    translator.translate("Place My Order"),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            FlatButton(
              child: Text(
                translator.translate('Continue shopping'),
                style: TextStyle(fontSize: 18),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  new MaterialPageRoute(builder: (context) => MainScreen(0)),
                );
                //Navigator.of(context).push(LoginScreen()); pushNamed(LoginScreen.routeName);
                // Navigator.pushReplacement(
                //   context,
                //   new MaterialPageRoute(builder: (context) => MainScreen(0)),
                // );
              },
            ),
          ],
        ),
      ),

      // bottomNavigationBar: Padding(
      //   padding: const EdgeInsets.all(10.0),
      //   child: SafeArea(
      //     child: SingleChildScrollView(
      //       child:     Container(
      //         height: 450,
      //         child: Column(
      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //           children: <Widget>[
      //             SizedBox(
      //               height: 10.0,
      //             ),
      //             Container(
      //               height: 40.0,
      //               child: TextField(
      //                 textAlign: TextAlign.start,
      //                 style: new TextStyle(
      //                     fontSize: 14.0,
      //                     height: 1.0,
      //                     color: Colors.black87
      //                 ),
      //                 decoration: InputDecoration(
      //                   labelText: translator.translate("Full Name"),
      //                   border: new OutlineInputBorder(
      //                     borderRadius: new BorderRadius.circular(5.0),
      //                     borderSide: new BorderSide(
      //                     ),
      //                   ),
      //                 ),
      //                 controller: name,
      //                 //enabled: false,
      //               ),
      //             ),
      //             // SizedBox(
      //             //   height: 2.0,
      //             // ),
      //             Container(
      //               height: 40.0,
      //               child: TextField(
      //                 textAlign: TextAlign.start,
      //                 style: new TextStyle(
      //                     fontSize: 14.0,
      //                     height: 1.0,
      //                     color: Colors.black87
      //                 ),
      //                 decoration: InputDecoration(
      //                   labelText: translator.translate("Mobile Number"),
      //                   border: new OutlineInputBorder(
      //                     borderRadius: new BorderRadius.circular(5.0),
      //                     borderSide: new BorderSide(
      //                     ),
      //                   ),
      //                 ),
      //                 controller: mobile,
      //                 //enabled: false,
      //               ),
      //             ),
      //             Row(
      //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //               children: [
      //                 Container(
      //                   height: 40.0,
      //                   width: 120,
      //                   child: TextField(
      //                     textAlign: TextAlign.start,
      //                     style: new TextStyle(
      //                         fontSize: 14.0,
      //                         height: 1.0,
      //                         color: Colors.black87
      //                     ),
      //                     decoration: InputDecoration(
      //                       labelText: translator.translate("Street"),
      //                       border: new OutlineInputBorder(
      //                         borderRadius: new BorderRadius.circular(5.0),
      //                         borderSide: new BorderSide(
      //                         ),
      //                       ),
      //                     ),
      //                     controller: street,
      //                     //enabled: false,
      //                   ),
      //                 ),
      //                 Container(
      //                   height: 40.0,
      //                   width: 120,
      //                   child: TextField(
      //                     textAlign: TextAlign.start,
      //                     style: new TextStyle(
      //                         fontSize: 14.0,
      //                         height: 1.0,
      //                         color: Colors.black87
      //                     ),
      //                     decoration: InputDecoration(
      //                       labelText: translator.translate("Building"),
      //                       border: new OutlineInputBorder(
      //                         borderRadius: new BorderRadius.circular(5.0),
      //                         borderSide: new BorderSide(
      //                         ),
      //                       ),
      //                     ),
      //                     controller: building,
      //                     //enabled: false,
      //                   ),
      //                 ),
      //                 Container(
      //                   height: 40.0,
      //                   width: 120,
      //                   child: TextField(
      //                     textAlign: TextAlign.start,
      //                     style: new TextStyle(
      //                         fontSize: 14.0,
      //                         height: 1.0,
      //                         color: Colors.black87
      //                     ),
      //                     decoration: InputDecoration(
      //                       labelText: translator.translate("Zone"),
      //                       border: new OutlineInputBorder(
      //                         borderRadius: new BorderRadius.circular(5.0),
      //                         borderSide: new BorderSide(
      //                         ),
      //                       ),
      //                     ),
      //                     controller: zone,
      //                     //enabled: false,
      //                   ),
      //                 ),
      //               ],
      //             ),
      //             // SizedBox(
      //             //   height: 10.0,
      //             // ),
      //             Container(
      //               height: 40.0,
      //               child: TextField(
      //                 textAlign: TextAlign.start,
      //                 style: new TextStyle(
      //                     fontSize: 14.0,
      //                     height: 1.0,
      //                     color: Colors.black87
      //                 ),
      //                 decoration: InputDecoration(
      //                   labelText: translator.translate("Address"),
      //                   border: new OutlineInputBorder(
      //                     borderRadius: new BorderRadius.circular(5.0),
      //                     borderSide: new BorderSide(
      //                     ),
      //                   ),
      //                 ),
      //                 controller: address,
      //               ),
      //             ),
      //             // SizedBox(
      //             //   height: 8.0,
      //             // ),
      //             TextField(decoration: InputDecoration(
      //               labelText: translator.translate("Note!"),
      //               border: new OutlineInputBorder(
      //                 borderRadius: new BorderRadius.circular(5.0),
      //                 borderSide: new BorderSide(
      //                 ),
      //               ),
      //
      //             ),
      //               controller: textNote,
      //             ),
      //             // SizedBox(
      //             //   height: 13.0,
      //             // ),
      //             Divider(
      //               height: 3.0,
      //             ),
      //             // SizedBox(
      //             //   height: 5.0,
      //             // ),
      //             Padding(
      //               padding: const EdgeInsets.all(8.0),
      //               child: Row(
      //                 // mainAxisSize: MainAxisSize.max,
      //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                 children: <Widget>[
      //                   Text(translator.translate("Total"),
      //                     style: TextStyle(
      //                         color: Color(0xFF9BA7C6),
      //                         fontSize: 16.0,
      //                         fontWeight: FontWeight.bold),
      //                   ),
      //                   Text(
      //                     totalAmount.toString(),
      //                     style: TextStyle(
      //                         color: Color(0xFF6C6D6D),
      //                         fontSize: 16.0,
      //                         fontWeight: FontWeight.bold),
      //                   ),
      //                 ],
      //               ),
      //             ),
      //             Column(
      //               children: <Widget>[
      //                 GestureDetector(
      //                   onTap: (){
      //                     _checkIfLoggedIn();
      //                     // if(userAddress != null || _dropDownValue == "Pickup"){
      //                     //   _checkIfLoggedIn();
      //                     // }else{
      //                     //   showAddressAlertDialog(context);
      //                     // }
      //
      //                   },
      //                   child: Container(
      //                     height: 50.0,
      //                     decoration: BoxDecoration(
      //                       color: Theme.of(context).primaryColor,
      //                       borderRadius: BorderRadius.circular(UIsizes.INPUT_BUTTON_BORDER_RADIUS),
      //                     ),
      //                     child: Center(
      //                       child: Text(translator.translate("Place My Order"),
      //                         style: TextStyle(
      //                           color: Colors.white,
      //                           fontSize: 18.0,
      //                           fontWeight: FontWeight.bold,
      //                         ),
      //                       ),
      //                     ),
      //                   ),
      //                 ),
      //
      //                 SizedBox(height: 10.0,),
      //                 FlatButton(
      //                   child: Text(
      //                     translator.translate('Continue shopping'),
      //                     style: TextStyle(fontSize: 18),
      //                   ),
      //                   onPressed: () {
      //                     Navigator.pushReplacement(
      //                       context,
      //                       new MaterialPageRoute(builder: (context) => MainScreen(0)),
      //                     );
      //                     //Navigator.of(context).push(LoginScreen()); pushNamed(LoginScreen.routeName);
      //                     // Navigator.pushReplacement(
      //                     //   context,
      //                     //   new MaterialPageRoute(builder: (context) => MainScreen(0)),
      //                     // );
      //                   },
      //                 ),
      //               ],
      //             ),
      //           ],
      //         ),
      //       ),
      //
      //     )
      //    ),
      // ),
    );
  }

  Widget orderTypeContainer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        InkWell(
          onTap: () {
            setState(() {
              _dropDownValue = "Delivery";
            });
          },
          child: Container(
            height: 35,
            width: MediaQuery.of(context).size.width / 2.5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Delivery",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: _dropDownValue == "Delivery"
                        ? Colors.white
                        : Colors.grey[900]),
              ),
            ),
            decoration: BoxDecoration(
                color: _dropDownValue == "Delivery"
                    ? Theme.of(context).primaryColor
                    : Colors.grey[200],
                borderRadius: BorderRadius.all(Radius.circular(20))),
          ),
        ),
        InkWell(
          onTap: () {
            setState(() {
              _dropDownValue = "Pickup";
            });
            //showAsBottomSheet();
          },
          child: Container(
            height: 35,
            width: MediaQuery.of(context).size.width / 2.5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Pickup",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: _dropDownValue == "Pickup"
                        ? Colors.white
                        : Colors.grey[900]),
              ),
            ),
            decoration: BoxDecoration(
                color: _dropDownValue == "Pickup"
                    ? Theme.of(context).primaryColor
                    : Colors.grey[200],
                borderRadius: BorderRadius.all(Radius.circular(20))),
          ),
        ),
      ],
    );
  }
}
