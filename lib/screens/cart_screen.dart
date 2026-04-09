// import 'package:flutter/material.dart';
//
// class CartScreen extends StatefulWidget {
//   @override
//   _CartScreenState createState() => _CartScreenState();
// }
//
// class _CartScreenState extends State<CartScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar:AppBar(
//         elevation: 0.0,
//         // leading: new IconButton(
//         //     icon: Platform.isIOS ? new Icon(Icons.arrow_back_ios) : new Icon(Icons.arrow_back),
//         //     onPressed: (){
//         //       Navigator.push(
//         //         context,
//         //         MaterialPageRoute(builder: (context) => MainScreen(0)),
//         //       );
//         //     }
//         // ),
//         title: Text("Cart",
//           style: TextStyle(
//             color: Colors.white,
//           ),
//         ),
//         backgroundColor:Theme.of(context).primaryColor,
//         //elevation: 0.0,
//         // centerTitle: true,
//       ),
//     );
//   }
// }

import 'package:brqtrapp/screens/checkOutScreen.dart';
import 'package:brqtrapp/screens/loginscreen.dart';
import 'package:brqtrapp/screens/main_screen.dart';
import 'package:brqtrapp/utils/constant.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:localize_and_translate/localize_and_translate.dart';
//import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:Salwa_garden/pages/cart_bloc.dart';
// import 'package:Salwa_garden/pages/final_checkout.dart';
// import 'package:Salwa_garden/screens/main_screen.dart';
// import 'package:Salwa_garden/utils/constant.dart';
import 'dart:io' show Platform;

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool isLoading = false;
  bool _isLoggedIn = false;
  List allCartData = [];
  double totalAmount = 0.0;
  var customerId;
  var cartId;
  var lang;
  var langChanged;

  _getTotal(data) {
    double total = 0;
    for (var i = 0; i < data.length; i++) {
      total +=
          (double.parse(data[i]['Price'].toString())) * (data[i]['Quantity']);

      /// change this
      //print(data[i]['product']['branch']['price'][0]['price']);
    }
    setState(() {
      totalAmount = total;
    });
    print("total amount is ${total}");
  }

  int _quantityCount = 1;

  void _add(price, index, qty) {
    setState(() {
      print(price);
      _quantityCount++;
      allCartData[index]['Quantity'] = qty + 1;
      totalAmount = totalAmount + double.parse(price.toString());
    });
  }

  void _minus(price, index, qty) {
    setState(() {
      if (qty != 1) {
        //_quantityCount--;
        allCartData[index]['Quantity'] = qty - 1;
        totalAmount = totalAmount - double.parse(price.toString());
      }
    });
  }

  @override
  void initState() {
    _getCartData();
    _checkIfLoggedIn();
    //_deleteCartItem(prodId,qty,price,index);
    super.initState();
  }

  Future<dynamic> _getCartData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    customerId = localStorage.getString('userID');
    lang = localStorage.getString('selectedLanguage');
    langChanged = localStorage.getString('LangSelect');
    print("Logged in customer id is =======>>>>>>$customerId");
    setState(() {
      isLoading = true;
    });
    //SharedPreferences localStorage = await SharedPreferences.getInstance();
    //var token = localStorage.getString('token');
    var url = APIConstants.API_BASE_URL_DEV + "viewCart?UserId=$customerId";
    print("Cart Url is --->> $url");
    Map<String, String> requestHeaders = {
      'x-api-key': '987654',
      //'Accept': 'application/json',
      //'Authorization': 'Bearer $token',
    };
    final response = await http.get(url, headers: requestHeaders);
    final cartData = json.decode(response.body);
    final allData = cartData['Data'];
    //final cartID = allData['CartId'];
    print("Carts Data- $allData");
    //print("Carts ID- $cartID");
    setState(() {
      allCartData = allData;
      _getTotal(allData);
      isLoading = false;
    });

    if (allCartData == null) {
      return;
    }
  }

  sumEachPrice(price, qty) {
    var total = price * qty;
    return total;
  }

  Future<dynamic> _deleteCartItem(prodId, qty, price, index) async {
    SharedPreferences saveBranchID = await SharedPreferences.getInstance();
    //var brnID = saveBranchID.getString('branchId');
    // setState(() {
    //   isLoading = true;
    // });

    //var bloc = Provider.of<CartBloc>(context);

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    //var token = localStorage.getString('token');
    //print('Post Prouduct Id - $prodId');
    var url = APIConstants.API_BASE_URL_DEV + "/deleteCart/$prodId";
    Map<String, dynamic> favItem = {
      'UserId': customerId,
      //'CartId': prodId.toString(),
    };
    Map<String, String> requestHeaders = {
      'x-api-key': '987654',
      //'Accept': 'application/json',
      //'Authorization': 'Bearer $token'
    };
    final response = await http.delete(url, headers: requestHeaders);
    var jsonData = json.decode(response.body);
//     if (response.statusCode == 200) {
//       setState(() {
//         totalAmount = totalAmount - (double.parse(price.toString()) * qty);
//         print(totalAmount);
//         print(price);
//         print(qty);
//         allCartData.removeAt(index);
//
//       });
//       var jsonResponse = json.decode(response.body);
//       print(response.body);
//       if (jsonResponse['status'] == true) {
//         print(jsonResponse['data']);
//         setState(() {
// //          if(index != -1){
// //            bloc.removeFromCart(index);
// //          }
//
//           isLoading = false;
//         });
//       }
//     }
    if (jsonData['Status'] == true) {
      print(jsonData['Message']);
      print(jsonData['CartQuantity']);
      setState(() {
        totalAmount = totalAmount - (double.parse(price.toString()) * qty);
        print(totalAmount);
        print(price);
        print(qty);

        allCartData.removeAt(index);
      });
    }
  }

  /// // ------------------PUT METHOD FOR--------

  _updateCartItems(prodId, qty) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');

    Map<String, String> requestHeaders = {
      'x-api-key': '987654',
      //'Accept': 'application/json',
      //'Authorization': 'Bearer $token'
    };
    Map data = {
      'UserId': customerId.toString(),
      'CartId': prodId.toString(),
      'Quantity': qty.toString(),
//      'product_price_id': priceId.toString(),
    };
    //var jsonResponse;
    final apiURL = APIConstants.API_BASE_URL_DEV + "updateCart";
    var response = await http.post(apiURL, body: data, headers: requestHeaders);
    var res = json.decode(response.body);

    if (res['status'] == true) {
      print('Cart has been updated successfully $res');
      print("UPDATED CART DATA - $data,$prodId");
      final snackBar = SnackBar(
        content: Text('Cart has been updated successfully'),
      );
    } else {
      final snackBar = SnackBar(
        content: Text('An error occured, try again'),
      );
      // _scaffoldKey.currentState.showSnackBar(snackBar);
    }
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

  @override
  Widget build(BuildContext context) {
    //var bloc = Provider.of<CartBloc>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        leading: new IconButton(
            icon: Platform.isIOS
                ? new Icon(Icons.arrow_back_ios)
                : new Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MainScreen(0)),
              );
            }),
        title: Text(
          translator.translate("Your Cart"),
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        //elevation: 0.0,
        // centerTitle: true,
      ),
      //backgroundColor: Colors.grey[46],
      body: isLoading
          ? _buildProgressIndicator()
          : allCartData.isEmpty
              ? Center(
                  child: Text(translator
                      .translate("No Items Added Yet, Please Add Some Item!")),
                )
              : ListView.builder(
                  itemCount: allCartData == null ? 0 : allCartData.length,
                  itemBuilder: (context, index) {
                    cartId = allCartData[index]['CartId'];
                    return isLoading
                        ? Center(
                            child: Container(
                            child: _buildProgressIndicator(),
                          ))
                        : Card(
                            //color: Colors.grey[100],
                            elevation: 0.0,
                            //color: Color(0xffe1e1e1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 10.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    width: 6.0,
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          //shape: BoxShape.circle,
                                          color: Colors.grey[300],
                                          borderRadius: BorderRadius.circular(
                                              UIsizes
                                                  .INPUT_BUTTON_BORDER_RADIUS)),
                                      height: 80.0,
                                      width: 80.0,
                                      child:
                                          allCartData[index]['Photo'].length !=
                                                  0
                                              ? CachedNetworkImage(
                                                  imageUrl: allCartData[index]
                                                              ['Photo'] !=
                                                          []
                                                      ? '${allCartData[index]['Photo']}'
                                                      : Image.asset(
                                                          'images/applogo.png'),
                                                  fit: BoxFit.cover,
                                                  placeholder: (context, url) =>
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
                                    ),
                                  ),
                                  SizedBox(
                                    width: 12.0,
                                  ),
                                  Flexible(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        lang == "Ar" && langChanged != "English"
                                            ? Text(
                                                "${allCartData[index]['NameAr']}",
                                                maxLines: 3,
                                                overflow: TextOverflow.clip,
                                                style: TextStyle(
                                                  fontSize: 12.0,
                                                  // fontWeight:
                                                  //     FontWeight.bold
                                                ),
                                              )
                                            : Text(
                                                "${allCartData[index]['NameEn']}",
                                                maxLines: 3,
                                                overflow: TextOverflow.clip,
                                                style: TextStyle(
                                                  fontSize: 12.0,
                                                  // fontWeight:
                                                  //     FontWeight.bold
                                                ),
                                              ),
                                        SizedBox(height: 20.0),
                                        // Text(
                                        //   "QAR - ${allCartData[index]['price']['price']}",
                                        //   style: TextStyle(
                                        //       fontSize: 16.0,
                                        //       color: Theme.of(context).accentColor,
                                        //       fontWeight: FontWeight.bold),
                                        // ),

                                        Container(
                                          decoration: BoxDecoration(
                                            //border: Border.all(color: Color(0xFFD3D3D3), width: 2.0),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          width: 100.0,
                                          height: 35.0,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 6.0,
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                InkWell(
                                                    onTap: () {
                                                      _minus(
                                                          allCartData[index]
                                                              ['Price'],
                                                          index,
                                                          allCartData[index]
                                                              ['Quantity']);
                                                      _updateCartItems(
                                                          allCartData[index]
                                                              ['CartId'],
                                                          allCartData[index]
                                                              ['Quantity']);
                                                    },
                                                    child: Icon(
                                                        Icons.remove_circle,
                                                        color:
                                                            Color(0xFFD3D3D3))),
                                                Text(
                                                  allCartData[index]['Quantity']
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 15.0,
                                                      color: Colors.grey),
                                                ),
                                                InkWell(
                                                    onTap: () {
                                                      _add(
                                                          allCartData[index]
                                                              ['Price'],
                                                          index,
                                                          allCartData[index]
                                                              ['Quantity']);

                                                      _updateCartItems(
                                                          allCartData[index]
                                                              ['CartId'],
                                                          allCartData[index]
                                                              ['Quantity']);
                                                    },
                                                    child: Icon(
                                                        Icons.add_circle,
                                                        color: Theme.of(context)
                                                            .primaryColor)),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 5.0),
                                      ],
                                    ),
                                  ),
                                  Spacer(),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () {
                                          //bloc.clear(index);
                                          print(
                                              "Cart id is =====>${allCartData[index]['CartId']}");
                                          print("User id is =====>$customerId");
                                          setState(() {
                                            //_deleteCartItem();
                                            //bloc.removeFromCart(index);
                                            _deleteCartItem(
                                                '${allCartData[index]['CartId']}',
                                                allCartData[index]['Quantity'],
                                                allCartData[index]['Price'],
                                                index);
                                          });
                                        },
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 25.0,
                                      ),
                                      // Container(
                                      //   decoration: BoxDecoration(
                                      //     border: Border.all(color: Color(0xFFD3D3D3), width: 2.0),
                                      //     borderRadius: BorderRadius.circular(10.0),
                                      //   ),
                                      //   width: 100.0,
                                      //   height: 35.0,
                                      //   child: Padding(
                                      //     padding: EdgeInsets.symmetric(
                                      //       horizontal: 6.0,
                                      //     ),
                                      //     child: Row(
                                      //       crossAxisAlignment: CrossAxisAlignment.center,
                                      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      //       children: <Widget>[
                                      //         InkWell(
                                      //             onTap: () {
                                      //               _minus(allCartData[index]['price']['price'],index,allCartData[index]['quantity']);
                                      //               _updateCartItems(allCartData[index]['id'], allCartData[index]['quantity']);
                                      //             },
                                      //             child: Icon(Icons.remove_circle,
                                      //                 color: Color(0xFFD3D3D3))),
                                      //         Text(
                                      //           allCartData[index]['quantity'].toString(),
                                      //           style: TextStyle(fontSize: 15.0, color: Colors.grey),
                                      //         ),
                                      //         InkWell(
                                      //             onTap: () {
                                      //               _add(allCartData[index]['price']['price'],index,allCartData[index]['quantity']);
                                      //               _updateCartItems(allCartData[index]['id'], allCartData[index]['quantity']);
                                      //             },
                                      //             child: Icon(Icons.add_circle,
                                      //                 color: Theme.of(context).primaryColor)),
                                      //       ],
                                      //     ),
                                      //   ),
                                      // ),
                                      Text(
                                        "QAR - ${sumEachPrice(allCartData[index]['Price'], allCartData[index]['Quantity'])}",
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            color:
                                                Theme.of(context).accentColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                  },
                ),
      bottomNavigationBar: _buildTotalContainer(),
    );
  }

  Widget _buildTotalContainer() {
    return Container(
      color: Colors.white,
      height: 200.0,
      padding: EdgeInsets.only(
        left: 10.0,
        right: 10.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Divider(
            height: 2.0,
          ),
          SizedBox(
            height: 20.0,
          ),
          _isLoggedIn
              ? Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      translator.translate("Total"),
                      style: TextStyle(
                          color: Color(0xFF6C6D6D),
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
                )
              : Container(),
          SizedBox(
            height: 20.0,
          ),
          Column(
            children: <Widget>[
              _isLoggedIn
                  ? GestureDetector(
                      onTap: () {
                        if (_isLoggedIn == true) {
                          if (allCartData.isEmpty) {
                            Fluttertoast.showToast(
                                msg: "no item in cart",
                                gravity: ToastGravity.CENTER,
                                backgroundColor: bluecolor,
                                textColor: Colors.white);
                          } else {
                            Navigator.of(context).push(new MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    FinalCheckOut()));
                          }
                        } else {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) => LoginPage()));
                          //_guestAlertForAddtoCart();
                        }
                      },
                      child: Container(
                        height: 50.0,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(
                              UIsizes.INPUT_BUTTON_BORDER_RADIUS),
                        ),
                        child: Center(
                          child: Text(
                            translator.translate("Proceed To Checkout"),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(),
              SizedBox(
                height: 10.0,
              ),
              FlatButton(
                child: Text(
                  translator.translate('Continue shopping'),
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  //Navigator.of(context).push(LoginScreen()); pushNamed(LoginScreen.routeName);
                  Navigator.pushReplacement(
                    context,
                    new MaterialPageRoute(builder: (context) => MainScreen(0)),
                  );
                },
              ),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
        ],
      ),
    );
  }
}
