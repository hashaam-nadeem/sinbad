import 'package:brqtrapp/screens/cart_screen.dart';
import 'package:brqtrapp/screens/category_screen.dart';
import 'package:brqtrapp/screens/item_card.dart';
import 'package:brqtrapp/screens/main_screen.dart';
import 'package:brqtrapp/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;


class VendorsByDepartmentScreen extends StatefulWidget {
  final id;

  const VendorsByDepartmentScreen({Key key, this.id}) : super(key: key);
  @override
  _VendorsByDepartmentScreenState createState() => _VendorsByDepartmentScreenState(id);
}

// class _VendorsByDepartmentScreenState extends State<VendorsByDepartmentScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
//
// }

class _VendorsByDepartmentScreenState extends State<VendorsByDepartmentScreen> {
  final id;
  bool _isLoading = false;
  bool _isLoggedIn = false;
  List departmentData = new List();
  List finalData = new List();
  var arLang = "Ar";
  var totalCount = '';
  var lang;
  var langChanged;
  var customerId;

  _VendorsByDepartmentScreenState(this.id);

  @override
  void initState() {
    // TODO: implement initState
    print('Vendors list view screen is loaded ---VendorsByDepartmentScreen');
    _getDepartmentData();
    super.initState();
    _checkIfLoggedIn();
    _getCartQuantity();
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
    //print("Numbers of items in cart are->>>>>> $sliderData");
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

  Future<dynamic> _getDepartmentData() async {
    setState(() {
      _isLoading = true;
    });

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');

    var url = APIConstants.API_BASE_URL_DEV + "vendorByDepartment?DepartmentId=$id";
    Map<String, String> requestHeaders = {
      //'Content-type': 'application/json',
      //'Accept': 'application/json',
      'x-api-key': '987654',
      //'Authorization': 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjZmMjc2ZGU3YTI1YWE3MDlmOTdiYjcwZDllODY3ZGNjNzllNWRjMzJmOGZlZjNlNWQ1YzhlMzM5YTU5ZjMyNTU2YWNlZWM1YTdlZDc3MjY0In0.eyJhdWQiOiIyIiwianRpIjoiNmYyNzZkZTdhMjVhYTcwOWY5N2JiNzBkOWU4NjdkY2M3OWU1ZGMzMmY4ZmVmM2U1ZDVjOGUzMzlhNTlmMzI1NTZhY2VlYzVhN2VkNzcyNjQiLCJpYXQiOjE1ODA1NDM5ODUsIm5iZiI6MTU4MDU0Mzk4NSwiZXhwIjoxNjEyMTY2Mzg1LCJzdWIiOiIxMzIiLCJzY29wZXMiOltdfQ.h33_EIU37oXVwrBR3bU6Y7NzyoM4m1wue-09NkDOh4AEimZ9mjjoqxU2fvGEZ_Bo-o6sE5hNg_84bJ-WctedsnoEdwNSPt1O_1SWIrIFhyU5vvv1i9HyBIKx_l4uZLcC-C52TxxvO2awQrrDHPxcbAsyqqa7Z3jh02dAN91r-6Oe0XaH6OV-FabwSMdsWh028GxuIzJwATfHA_zPfDtIquG1TBLc7Q9cFOzlio7IOy3tOLCxVL4f_vt-aOwVF0C0M_eTgk8znI7nTpWk3TgKN_OjRegxbkSGXrS59SIMNZUhMBI1j1vmzSFmRlpEZ8vj5csFxnmTv9oT5tLviD06y8TIISHifpUMI4z2o4rg_qFQbHTAkf37pw2TCfsbzL5sIWMFwWNvbpeKmplurcsnqbzcXl7STqrHftWEwxz6a4Cjrt2fCcxWAkS3CzraANhMkDFuS9oaRqLGfGsZytOZVLTYzQi3HanEip_NqhtEDLhkiEZ6LSJg9CSkk9q9gjruM3zs-l_GijkwJZpdgHwb06SXQb1hF8sS-pcXMwKHU-nF9zKoYZYjodSLaawFtNleylQqZO1mg9gK0XEoMHqm1NXdJH54mqSjoIKmDtKPbmGINzERRB6Cls0pHjC5Z82JBZ9g7xwmOJbMGdN7i2rZhOzs4Mq-eT85nsP2-SNPiJE'
    };
    final response = await http.get(url, headers: requestHeaders);
    //final List<FavoriteItem> favProducts = [];
    final favData = json.decode(response.body);
    final deptData = favData['Data'];
    print("All Vendors by Department data ===========->>> $deptData");
    List dataDepart = new List();
    var dataLength = deptData.length;
    for (int i = 0; i < dataLength; i++) {
      dataDepart.add(deptData[i]);
    }
    //print("All Department data ===========->>> ${favData[]}");

    //var favProd = favData['product'];
    // print('favorite Product Name - $favProd');

    if (!mounted) return;
    setState(() {
      _isLoading = false;
      //favoriteData = favData;
      departmentData.addAll(dataDepart);
      finalData = departmentData;
      //print("Department Names are =======>>>> ${finalData[0]["NameEn"]}");
    });

    //print('data isss $favData["data"]');
    // if (favoriteData == null) {
    //   return;
    // }
    // _favorite = favProducts;
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: _isLoading ? 1.0 : 00,
          child: new CupertinoActivityIndicator(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _getCartQuantity();
    return Scaffold(
      //backgroundColor: Theme.of(context).accentColor,
      appBar: AppBar(
        elevation: 0.0,
        leading: new IconButton(
            icon: Platform.isIOS ? new Icon(Icons.arrow_back_ios) : new Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MainScreen(0)),
              );
            }
        ),
        automaticallyImplyLeading: true, // hides leading widget
        title: Text(
          translator.translate("Vendors"),
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
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
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) => CartScreen()));
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
                            totalCount == ''
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
                                              "$totalCount",
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
      body: _isLoading ? _buildProgressIndicator() : GridView.builder(
          itemCount: finalData.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 6.0,
            crossAxisSpacing: 2.0,
            childAspectRatio: 0.90,
            //childAspectRatio: 1 / 1,
          ),
          itemBuilder: (context, index) => ItemCard(
            image: finalData[index]['Logo'],
            title: finalData[index]['VendorNameEn'],
            titleAr: finalData[index]['VendorNameAr'],
            Id: finalData[index]['Id'],
            press: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CategoryScreen(id: finalData[index]['Id'],
                        nameEN: finalData[index]['VendorNameEn'],
                        nameAR:finalData[index]['VendorNameAr'],
                        vendorLogo:finalData[index]['Logo'],
                      ),
                )),
          )),
      // drawer: Drawer(
      //   // Add a ListView to the drawer. This ensures the user can scroll
      //   // through the options in the drawer if there isn't enough vertical
      //   // space to fit everything.
      //   child: ListView(
      //     // Important: Remove any padding from the ListView.
      //     padding: EdgeInsets.zero,
      //     children: <Widget>[
      //       DrawerHeader(
      //         child: _isLoggedIn
      //             ? Text('Hello Shahid',
      //             style: TextStyle(color: Colors.white, fontSize: 22.0))
      //             : Text(
      //           'Hello Guest',
      //           style: TextStyle(color: Colors.white, fontSize: 25.0),
      //         ),
      //         decoration: BoxDecoration(
      //           color: Theme.of(context).primaryColor,
      //         ),
      //       ),
      //       ListTile(
      //         leading: Icon(Icons.account_box),
      //         title: Text('About Us'),
      //         // onTap: () {
      //         //   Navigator.pop(context);
      //         //   // Update the state of the app.
      //         //   // ...
      //         //   Navigator.of(context).push(new MaterialPageRoute(
      //         //       builder: (BuildContext context) => AboutUs()));
      //         // },
      //       ),
      //       ListTile(
      //         leading: Icon(Icons.lock),
      //         title: Text('Privacy Policy'),
      //         // onTap: () {
      //         //   Navigator.pop(context);
      //         //   // Update the state of the app.
      //         //   // ...
      //         //
      //         //   Navigator.of(context).push(new MaterialPageRoute(
      //         //       builder: (BuildContext context) => PrivacyPolicy()));
      //         // },
      //       ),
      //       ListTile(
      //         leading: Icon(Icons.loyalty),
      //         title: Text('Terms and Conditions'),
      //         // onTap: () {
      //         //   Navigator.pop(context);
      //         //
      //         //   Navigator.of(context).push(new MaterialPageRoute(
      //         //       builder: (BuildContext context) => TermConditions()));
      //         //   // Update the state of the app.
      //         //   // ...
      //         // },
      //       ),
      //       _isLoggedIn
      //           ? ListTile(
      //         leading: Icon(Icons.language_sharp),
      //         title: Text(translator.translate('buttonTitle')),
      //         onTap: () async {
      //           SharedPreferences localStorage = await SharedPreferences.getInstance();
      //           localStorage.setBool('isLangArabic', true);
      //           localStorage.setString('selectedLanguage', arLang );
      //           setState(() {
      //             translator.setNewLanguage(
      //               context,
      //               newLanguage: translator.currentLanguage == 'ar' ? 'en' : 'ar',
      //               remember: true,
      //               restart: true,
      //             );
      //           });
      //           //Navigator.pop(context);
      //           // _changeLanguage(Language language);
      //           print("Changed Language To Arabic");
      //           //
      //           //   Navigator.of(context).push(new MaterialPageRoute(
      //           //       builder: (BuildContext context) => ContactUs()));
      //           //   // Update the state of the app.
      //           //   // ...
      //         },
      //       ): Text(''),
      //       _isLoggedIn
      //           ? ListTile(
      //         leading: Icon(Icons.logout),
      //         title: Text('Log Out'),
      //         onTap: () {
      //           Navigator.pop(context);
      //           _logoutFromTheApp(context);
      //           // Navigator.of(context).push(new MaterialPageRoute(
      //           //     builder: (BuildContext context) => ContactUs()));
      //           // Update the state of the app.
      //           // ...
      //         },
      //       )
      //           : Text(''),
      //     ],
      //   ),
      // ),
    );
  }

  // void _logoutFromTheApp(context) {
  //   AppSharedPreferences.clear();
  //   Navigator.pushReplacement(
  //     context,
  //     new MaterialPageRoute(builder: (context) => LoginPage()),
  //   );
  // }
}
