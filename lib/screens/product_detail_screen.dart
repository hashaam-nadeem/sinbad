// import 'package:brqtrapp/components/add_to_cart.dart';
// import 'package:brqtrapp/components/color_and_size.dart';
// import 'package:brqtrapp/components/counter_with_fav_btn.dart';
// import 'package:brqtrapp/components/description.dart';
// import 'package:brqtrapp/components/product_title_with_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
//
// class DetailsScreen extends StatelessWidget {
//   final filterName;
//
//   const DetailsScreen({Key key, this.filterName}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // each product have a color
//       //backgroundColor: product.color,
//       appBar: buildAppBar(context),
//       body: Body(filterName: filterName),
//     );
//   }
//
//   AppBar buildAppBar(BuildContext context) {
//     return AppBar(
//       //backgroundColor: product.color,
//       elevation: 0,
//       leading: IconButton(
//         icon: SvgPicture.asset(
//           'assets/icons/back.svg',
//           color: Colors.white,
//         ),
//         onPressed: () => Navigator.pop(context),
//       ),
//       actions: <Widget>[
//         IconButton(
//           icon: SvgPicture.asset("assets/icons/search.svg"),
//           onPressed: () {},
//         ),
//         IconButton(
//           icon: SvgPicture.asset("assets/icons/cart.svg"),
//           onPressed: () {},
//         ),
//         SizedBox(width: 20 / 2)
//       ],
//     );
//   }
// }
// class Body extends StatelessWidget {
//   final filterName;
//
//   const Body({Key key, this.filterName}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     // It provide us total height and width
//     Size size = MediaQuery.of(context).size;
//     return SingleChildScrollView(
//       child: Column(
//         children: <Widget>[
//           SizedBox(
//             height: size.height,
//             child: Stack(
//               children: <Widget>[
//                 Container(
//                   margin: EdgeInsets.only(top: size.height * 0.3),
//                   padding: EdgeInsets.only(
//                     top: size.height * 0.12,
//                     left: 20.0,//kDefaultPaddin,
//                     right: 20.0,//kDefaultPaddin,
//                     //bottom: 20.0,
//                   ),
//                    height: 500,
//                   decoration: BoxDecoration(
//                     color: Colors.blueGrey,
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(24),
//                       topRight: Radius.circular(24),
//                     ),
//                   ),
//                   child: Column(
//                     children: <Widget>[
//                       ColorAndSize(filterName: filterName),
//                       SizedBox(height: 10.0),
//                       //Description(filterName: filterName),
//                       //SizedBox(height: 10.0),
//                       CounterWithFavBtn(),
//                       //SizedBox(height: 20 / 2),
//                       //AddToCart(filterName: filterName)
//                     ],
//                   ),
//                 ),
//                 ProductTitleWithImage(filterName: filterName)
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
import 'package:brqtrapp/screens/Products_banner_images.dart';
import 'package:brqtrapp/screens/cart_screen.dart';
import 'package:brqtrapp/screens/category_screen.dart';
import 'package:brqtrapp/utils/constant.dart';
import 'package:brqtrapp/utils/ui_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;


class ProductDetailScreen extends StatefulWidget {
  final id;
  final title;
  final titleAr;
  final price;
  final shortDes;
  final shortDesAr;
  final description;
  final descriptionAr;
  final userId;
  final vendorId;
  final inStock;

  const ProductDetailScreen({Key key, this.id, this.title, this.titleAr, this.price, this.shortDes, this.shortDesAr, this.description, this.descriptionAr, this.userId, this.vendorId, this.inStock}) : super(key: key);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState(id,title,titleAr,price,shortDes,shortDesAr,description,descriptionAr,userId,vendorId,inStock);
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final id;
  final title;
  final titleAr;
  final price;
  final shortDes;
  final shortDesAr;
  final description;
  final descriptionAr;
  final userId;
  final vendorId;
  final inStock;

  bool _isLoggedIn = false;
  var totalCount = "";
  int numOfItems = 1;
  var customerId;
  bool _isLoading = false;
  var successMessage;
  var errorMessage;
  var lang;
  var langChanged;

  _ProductDetailScreenState(this.id, this.title, this.titleAr, this.price, this.shortDes, this.shortDesAr, this.description, this.descriptionAr, this.userId, this.vendorId, this.inStock);


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkIfLoggedIn();
    _getCartQuantity();
    print("User Id == $userId");
    print("Vendor Id =====>>>$vendorId");
    print("Product Id =====>>>$id");
    print("Product title ======>>>$title");
    print("Product title ======>>>$titleAr");
    print("Check Availability ======>>>$inStock");
  }

  Future<dynamic> _getCartQuantity() async {

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    customerId = localStorage.getString('userID');

    var url = APIConstants.API_BASE_URL_DEV + "/addToCart?UserId=$customerId";
    Map<String, String> requestHeaders = {
      //'Content-type': 'application/json',
      //'Accept': 'application/json',
      'x-api-key': '987654',
      //'Authorization': 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjZmMjc2ZGU3YTI1YWE3MDlmOTdiYjcwZDllODY3ZGNjNzllNWRjMzJmOGZlZjNlNWQ1YzhlMzM5YTU5ZjMyNTU2YWNlZWM1YTdlZDc3MjY0In0.eyJhdWQiOiIyIiwianRpIjoiNmYyNzZkZTdhMjVhYTcwOWY5N2JiNzBkOWU4NjdkY2M3OWU1ZGMzMmY4ZmVmM2U1ZDVjOGUzMzlhNTlmMzI1NTZhY2VlYzVhN2VkNzcyNjQiLCJpYXQiOjE1ODA1NDM5ODUsIm5iZiI6MTU4MDU0Mzk4NSwiZXhwIjoxNjEyMTY2Mzg1LCJzdWIiOiIxMzIiLCJzY29wZXMiOltdfQ.h33_EIU37oXVwrBR3bU6Y7NzyoM4m1wue-09NkDOh4AEimZ9mjjoqxU2fvGEZ_Bo-o6sE5hNg_84bJ-WctedsnoEdwNSPt1O_1SWIrIFhyU5vvv1i9HyBIKx_l4uZLcC-C52TxxvO2awQrrDHPxcbAsyqqa7Z3jh02dAN91r-6Oe0XaH6OV-FabwSMdsWh028GxuIzJwATfHA_zPfDtIquG1TBLc7Q9cFOzlio7IOy3tOLCxVL4f_vt-aOwVF0C0M_eTgk8znI7nTpWk3TgKN_OjRegxbkSGXrS59SIMNZUhMBI1j1vmzSFmRlpEZ8vj5csFxnmTv9oT5tLviD06y8TIISHifpUMI4z2o4rg_qFQbHTAkf37pw2TCfsbzL5sIWMFwWNvbpeKmplurcsnqbzcXl7STqrHftWEwxz6a4Cjrt2fCcxWAkS3CzraANhMkDFuS9oaRqLGfGsZytOZVLTYzQi3HanEip_NqhtEDLhkiEZ6LSJg9CSkk9q9gjruM3zs-l_GijkwJZpdgHwb06SXQb1hF8sS-pcXMwKHU-nF9zKoYZYjodSLaawFtNleylQqZO1mg9gK0XEoMHqm1NXdJH54mqSjoIKmDtKPbmGINzERRB6Cls0pHjC5Z82JBZ9g7xwmOJbMGdN7i2rZhOzs4Mq-eT85nsP2-SNPiJE'
    };
    final response = await http.get(url, headers: requestHeaders);
    //final List<FavoriteItem> favProducts = [];
    final sliderData = json.decode(response.body);
    print("Numbers of items in cart are->>>>>> $sliderData");
    final qauntityData = sliderData['CartQuantity'];
    //List dataBanner = new List();
    //var dataLength = bannerImgData.length;
    // for (int i = 0; i < dataLength; i++) {
    //   dataBanner.add(bannerImgData[i]);
    // }
    //var favProd = favData['product'];
    // print('favorite Product Name - $favProd');

    if (!mounted) return;
    setState(() {
      totalCount = qauntityData;
      // bannerData.addAll(dataBanner);
      // images = bannerData;
      // isLoading = false;
    });

    //print('data isss $favData["data"]');
    // if (totalCount == null) {
    //   return;
    // }
    // _favorite = favProducts;
  }

  void _checkIfLoggedIn() async {
    // check if token is there
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    customerId = localStorage.getString('userID');
    lang = localStorage.getString('selectedLanguage');
    langChanged = localStorage.getString('LangSelect');
    print("Logged in customer id is =======>>>>>>$customerId");
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

  void _addToCartPost() async {
    setState(() {
      _isLoading = true;
    });
    final String apiURL = (APIConstants.API_BASE_URL_DEV + APIOperations.ADDTOCART);
    Map<String, dynamic> userData = {
      'UserId': customerId.toString(),
      'VendorId': vendorId.toString(),
      'ProductId': id.toString(),
      'Quantity': numOfItems.toString(),
    };
    Map<String, String> requestHeaders = {
      'x-api-key': '987654',
      //'Content-type': 'application/json',
      //'Accept': 'application/json',
    };
    final response = await http.post(apiURL, body: userData, headers: requestHeaders);
    var jsonData = json.decode(response.body);
    print("Login Response $jsonData");
    if (jsonData['Status'] != false && jsonData['VendorAlreadyExist'] == false) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      successMessage = jsonData['Message']['EnResponse'];
      print("Message from the cart is =======>>>${jsonData['Message']['EnResponse']}");
      setState(() {
        _isLoading = false;
      });
      successMessageAlert(successMessage);
      // if(jsonData['Status'] == true && jsonData['VendorAlreadyExist'] == true){
      //   successMessageAlert(successMessage);
      // }
    }  else{
      errorMessage = jsonData['Message']['EnResponse'];
      print('order not placed');
      //successMessageAlert(successMessage);
      failedMessageAlert(errorMessage);
    }
  }

  void _deleteAddCartPost() async {
    setState(() {
      _isLoading = true;
    });
    final String apiURL = (APIConstants.API_BASE_URL_DEV + 'addToCartAfterDelete');
    Map<String, dynamic> userData = {
      'UserId': customerId.toString(),
      'VendorId': vendorId.toString(),
      'ProductId': id.toString(),
      'Quantity': numOfItems.toString(),
    };
    Map<String, String> requestHeaders = {
      'x-api-key': '987654',
      //'Content-type': 'application/json',
      //'Accept': 'application/json',
    };
    final response = await http.post(apiURL, body: userData, headers: requestHeaders);
    var jsonData = json.decode(response.body);
    print("Login Response $jsonData");
    if (jsonData['Status'] != false) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      successMessage = jsonData['Message']['EnResponse'];
      print("Message from the cart is =======>>>${jsonData['Message']['EnResponse']}");
      setState(() {
        _isLoading = false;
      });
      successMessageAlert(successMessage);
      // if(jsonData['Status'] == true && jsonData['VendorAlreadyExist'] == true){
      //   successMessageAlert(successMessage);
      // }
    }  else{
      errorMessage = jsonData['Message']['EnResponse'];
      print('order not placed');
      //successMessageAlert(successMessage);
      //failedMessageAlert(errorMessage);
    }
  }

  Future<void> successMessageAlert(string) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Added Successful!'),
          content: Text(successMessage
              ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('Continue'),
              onPressed: () {
                Navigator.of(context).pop();
                _getCartQuantity();
//                Navigator.pushReplacement(
//                  context,
//                  new MaterialPageRoute(builder: (context) => MainScreen()),
//                );
              },
            ),
            CupertinoDialogAction(
              child: Text('Check Out'),
              onPressed: () {
                Navigator.of(context).pop();
               Navigator.pushReplacement(
                 context,
                 new MaterialPageRoute(builder: (context) => CartScreen()),
               );
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> failedMessageAlert(string) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Cart Alert!'),
          content: Text(errorMessage),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
//                Navigator.pushReplacement(
//                  context,
//                  new MaterialPageRoute(builder: (context) => MainScreen()),
//                );
              },
            ),
            CupertinoDialogAction(
              child: Text('Delete',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteAddCartPost();
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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Theme.of(context).accentColor,
      appBar: AppBar(
          elevation: 0.0,
          // leading: new IconButton(
          //     icon: Platform.isIOS ? new Icon(Icons.arrow_back_ios) : new Icon(Icons.arrow_back),
          //     onPressed: (){
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(builder: (context) => CategoryScreen()),
          //       );
          //     }
          // ),
          title:lang == "Ar" && langChanged != "English" ? Text(titleAr,
            style: TextStyle(
              color: Colors.white,
            ),
          ):Text(title,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor:Theme.of(context).primaryColor,
          actions: <Widget>[
            Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                    height: 150.0,
                    width: 30.0,
                    child: GestureDetector(
                        onTap: () {
//                  _isLoggedIn? Navigator.of(context).push(new MaterialPageRoute(
//                      builder: (BuildContext context) => CartPage()
//                  )) : null;
                          if (_isLoggedIn == true) {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) => CartScreen()));
                          } else {
                            //_guestAlertForAddtoCart();
                          }
                        },

                        /// badge on Cart code --
                        child: new Stack(
                          children: <Widget>[
                            new IconButton(
                              icon: new Icon(
                                Icons.shopping_basket_rounded,
                                color: Colors.white,
                              ),
                              onPressed: null,
                              iconSize: 27,
                            ),
                            totalCount == ""
                                ? new Container()
                                : new Positioned(
                                left: 3,
                                child: _isLoggedIn
                                    ? new Stack(
                                  children: <Widget>[
//                                new Icon(Icons.brightness_1,
//                                    size: 19.0,
//                                    color: Theme.of(context).accentColor),
                                    Container(
                                      height: 20.0,
                                      width: 20.0,
                                      child: Align(
                                        alignment:
                                        Alignment.center,
                                        child: new Center(
                                            child: _isLoggedIn
                                                ? new Text(
                                              "${totalCount}",
                                              style: new TextStyle(
                                                  color: Colors
                                                      .white,
                                                  fontSize:
                                                  11.0,
                                                  fontWeight:
                                                  FontWeight.w500),
                                            )
                                                : null),
                                      ),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.all(
                                              Radius.circular(
                                                  100.0)),
                                          color: Colors.red),
                                    ),
                                  ],
                                )
                                    : null),
                          ],
                        )))

              // OutlineButton(
              //   child: Text("LOGIN"),
              //   shape: RoundedRectangleBorder(
              //       borderRadius: new BorderRadius.circular(
              //           UIsizes.INPUT_BUTTON_BORDER_RADIUS)),
              //   color: Theme.of(context).primaryColor,
              //   onPressed: () {
              //     Navigator.pushReplacement(
              //       context,
              //       MaterialPageRoute(builder: (context) => LoginPage()),
              //     );
              //   },
              // ),
            ),
          ]
        //elevation: 0.0,
        // centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: <Widget> [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ProductsBannerImages(id:id),
                      SizedBox(height: 20.0,),
                      Divider(height: 1,thickness: 1,indent: 10,),
                      _productTitlePrice(),
                      //CustomDividerView(),
                     // DepartListView(),/// Top pick up
                      Divider(height: 1,thickness: 1,indent: 10,endIndent: 10,),
                      SizedBox(height: 15,),
                      _quantityCounter(),
                      SizedBox(height: 15,),
                      Divider(height: 1,thickness: 1,indent: 10,endIndent: 10,),
                      SizedBox(height: 10,),
                      _longDescription(),
                     // VendorsListView(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: inStock == 0 ? null : _cartButton(),
    );
  }

  Widget _quantityCounter(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              buildOutlineButton(
                //color: Colors.red,
                icon: Icons.remove,
                press: () {
                  if (numOfItems > 1) {
                    setState(() {
                      numOfItems--;
                    });
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20 / 2),
                child: Text(
                  // if our item is less  then 10 then  it shows 01 02 like that
                  numOfItems.toString().padLeft(2, "0"),
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              buildOutlineButton(
                //color: Colors.green,
                  icon: Icons.add,
                  press: () {
                    setState(() {
                      numOfItems++;
                    });
                  }),
            ],
          ),
        ),
        inStock == 0 ? Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text("Out Of Stock",style: TextStyle(color: Colors.red,fontSize: 16,fontWeight: FontWeight.bold),),
        ): Text(""),
      ],
    );
  }

  SizedBox buildOutlineButton({IconData icon, Function press,}) {
    return SizedBox(
      width: 40,
      height: 32,
      child: Container(
        //color: Colors.green,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          //color: Colors.redAccent,
          boxShadow: [
            BoxShadow(color: Colors.white,spreadRadius: 0.5 ),
          ],
        ),
        child: OutlineButton(
          //disabledBorderColor: Colors.orange,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
          //color: Colors.red,
          onPressed: press,
          child: Icon(icon,),
        ),
      ),
    );
  }

  Widget _productTitlePrice(){
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //SizedBox(height: 10,),
          // Text(
          //   'BREAKFAST',
          //   style: Theme.of(context).textTheme.bodyText1.copyWith(
          //     fontSize: 10.0,
          //     color: Colors.grey[700],
          //   ),
          // ),
          //UIHelper.verticalSpaceLarge(),
          Row(
            children: <Widget>[
              //VegBadgeView(),
              UIHelper.horizontalSpaceExtraSmall(),
              Flexible(
                child:lang == "Ar" && langChanged != "English" ? Text(
                  titleAr,
                  style: TextStyle(
                      color: Colors.black,fontSize: 22.0,fontWeight: FontWeight.bold
                  ),
                ):Text(
                  title,
                  style: TextStyle(
                      color: Colors.black,fontSize: 22.0,fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ],
          ),
          UIHelper.verticalSpaceMedium(),
          Row(
            children: <Widget>[
              //VegBadgeView(),
              UIHelper.horizontalSpaceExtraSmall(),
              Flexible(
                child: lang == "Ar" && langChanged != "English" ?Text(
                  shortDesAr,
                  style: TextStyle(
                      color: Colors.black,fontSize: 14.0,fontWeight: FontWeight.normal
                  ),
                ):Text(
                  shortDes,
                  style: TextStyle(
                      color: Colors.black,fontSize: 14.0,fontWeight: FontWeight.normal
                  ),
                ),
              ),
            ],
          ),
          // Spacer(),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("QAR - ${price.toString()}",
                style: TextStyle(
                  color: Colors.red,fontSize: 20.0,fontWeight: FontWeight.bold
                ),
                  ),
              //AddBtnView()
            ],
          )
        ],
      ),
    );

  }

  Widget _longDescription(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(translator.translate('Product Details:'),style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
            child: Container(
              child: RichText(
              text: lang == "Ar" && langChanged != "English" ? TextSpan(
                text: descriptionAr,
                style: TextStyle(color: Colors.black)
              ):TextSpan(
                  text: description,
                  style: TextStyle(color: Colors.black)
              ),
            ),),
          ),
        ],
      ),
    );
  }

  Widget _cartButton(){
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 40),
      child: SizedBox(
        height: 50,
        child: FlatButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25)),
          color: Theme.of(context).primaryColor,
          onPressed: () {
            _addToCartPost();
          },
          child: Text(
              translator.translate("Add To Cart").toUpperCase(),
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

