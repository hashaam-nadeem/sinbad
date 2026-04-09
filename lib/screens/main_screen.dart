import 'dart:async';
import 'dart:ui' as ui;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:brqtrapp/screens/myprofile.dart';
import 'package:brqtrapp/screens/privacypolicy.dart';
import 'package:brqtrapp/screens/terms&conditions.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:brqtrapp/screens/cart_screen.dart';
import 'package:brqtrapp/screens/home_main_screen.dart';
import 'package:brqtrapp/screens/department_screen.dart';
import 'package:brqtrapp/screens/langScreen.dart';
import 'package:brqtrapp/screens/listing_screen.dart';
import 'package:brqtrapp/screens/loginscreen.dart';
import 'package:brqtrapp/screens/news_screen.dart';
import 'package:brqtrapp/screens/user_profile_screen.dart';
import 'package:brqtrapp/screens/vendor_screen.dart';
import 'package:brqtrapp/utils/app_shared_preferences.dart';
import 'package:brqtrapp/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'aboutus.dart';
import 'cart_screen.dart';
import 'cart_screen.dart';
import 'cart_screen.dart';
import 'cart_screen.dart';
import 'change_password_screen.dart';
import 'listing_screen.dart';

class MainScreen extends StatefulWidget {
  //final Datum fooddata;
  final selectedPage;

  const MainScreen(this.selectedPage);

  //MainScreen({this});

  @override
  _MainScreenState createState() => _MainScreenState(selectedPage);
}

class _MainScreenState extends State<MainScreen> {
  final selectedPage;
  bool _isLoggedIn = false;
  var arLang = "Ar";
  var lang;
  var title;
  var _sysLng;
  var langChanged;
  var totalCount = '';
  var customerId;
  int _page = 0;
  PageController _controller = PageController(initialPage: 0);
  GlobalKey _bottomNavigationKey = GlobalKey();
  _MainScreenState(this.selectedPage);

  int currentTab = 0;
  String branch;

  // Pages
  HomeScreen homePage;
  CartScreen cartScreen;
  ListingScreen listingScreen;
  MainHomeScreen mainHomeScreen;
  NewsScreen newsScreen;
  VendorScreen vendorScreen;
  MyProfilePage profile;

  // MyProfilePage profilePage;

  List<Widget> pages;
  List<String> titleName;
  Widget currentPage;
  bool isloggedin = false;
  bool isVisible = true;

  _checkIfLoggedIn() async {
    // check if token is there
    // SharedPreferences localStorage = await SharedPreferences.getInstance();
    // //branch =loca
    //  var token = localStorage.getString('token');
    // if(token!= null){
    //  setState(() {
    // isloggedin=  true;
    homePage = HomeScreen(); //HomePage(widget.foodModel);
    cartScreen = CartScreen();
    profile = MyProfilePage();
    listingScreen = ListingScreen();
    mainHomeScreen = MainHomeScreen();
    newsScreen = NewsScreen();
    vendorScreen = VendorScreen();
    //profilePage = null;//ProfilePage();
    pages = [homePage, mainHomeScreen, cartScreen, MyProfile()];
    titleName = ['homePage', 'mainHomeScreen', 'Cart', "Account"];

    //  });

    // }else{
    //   setState(() {
    //     isloggedin=  false;
    //     pages = [homePage,favoritePage];
    //         currentPage = homePage;

    //   });
    // }
    // currentPage = homePage;
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
      if (qauntityData != null) {
        totalCount = qauntityData;
      }

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

  @override
  initState() {
    _getCartQuantity();

    // _controller.animateToPage(2,
    //     duration: Duration(milliseconds: 500), curve: Curves.ease);
    print('This is inside the initState In');
    homePage = HomeScreen(); //HomePage(widget.foodModel);
    cartScreen = CartScreen();
    listingScreen = ListingScreen();
    mainHomeScreen = MainHomeScreen();
    newsScreen = NewsScreen();
    vendorScreen = VendorScreen();
    //profilePage = null;//ProfilePage();
    pages = [homePage, mainHomeScreen, cartScreen, MyProfile()];
    titleName = ['Dashboard', 'Departments', 'Cart', 'Account'];

    //_checkIfLoggedIn()
    super.initState();

    if (selectedPage == 0) {
      currentPage = mainHomeScreen;
      title = titleName[0];
    } else {
      currentPage = mainHomeScreen;
      currentTab = 1;
      title = titleName[1];
    }
    _isIfLoggedIn();
  }

  // @override
  // void didChangeDependencies() {
  //   //_counter = Provider.of<int>(context);
  //   _getCartQuantity();
  //   print('didChangeDependencies(), counter = $totalCount');
  //   super.didChangeDependencies();
  // }

  void _isIfLoggedIn() async {
    print('This is inside the Logged In');
    // check if token is there
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    //totalCount = localStorage.getString('CartQuantity');
    if (token != null) {
      setState(() {
        _isLoggedIn = true;
        _getCartQuantity();
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

  @override
  Widget build(BuildContext context) {
    print('Build Method call');
    //_getCartQuantity();
    //_sysLng = ui.window.locale.languageCode;
    //print("SYSTEM LANGUAGE IS ======>>>>$_sysLng");
    return WillPopScope(
      onWillPop: () {},
      child: Scaffold(
        appBar: AppBar(
            elevation: 0.0,
            title: Text(
              translator.translate(title),
            ),
            //backgroundColor:Theme.of(context).primaryColor,
            centerTitle: true,
            // leading: new IconButton(
            //     icon: Platform.isIOS ? new Icon(Icons.arrow_back_ios) : new Icon(Icons.arrow_back),
            //     onPressed: (){
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(builder: (context) => MainScreen(0)),
            //       );
            //     }
            // ),
            automaticallyImplyLeading: true,
            // hides leading widget
            // title: Text(
            //   translator.translate('Departments'),
            //   style: TextStyle(
            //     color: Colors.white,
            //   ),
            // ),
            backgroundColor: Theme.of(context).primaryColor,
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
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
                                builder: (BuildContext context) =>
                                    CartScreen()));
                          } else {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    CartScreen()));
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
                                    child: new Stack(
                                      children: <Widget>[
//                                new Icon(Icons.brightness_1,
//                                    size: 19.0,
//                                    color: Theme.of(context).accentColor),
                                        Container(
                                          height: 20.0,
                                          width: 20.0,
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: new Center(
                                                child: new Text(
                                              "$totalCount",
                                              style: new TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 11.0,
                                                  fontWeight: FontWeight.w500),
                                            )),
                                          ),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(100.0)),
                                              color: Colors.red),
                                        ),
                                      ],
                                    )),
                          ],
                        ))),
              ),
            ]
            //elevation: 0.0,
            // centerTitle: true,
            ),
        backgroundColor: soilcolor,
        resizeToAvoidBottomPadding: true,
        bottomNavigationBar: CurvedNavigationBar(
          buttonBackgroundColor: orangecolor,
          color: redColor,
          index: _page,
          //index: _controller.animateToPage(_page, duration: null, curve: null),
          backgroundColor: soilcolor,
          height: MediaQuery.of(context).size.height * .08,
          key: _bottomNavigationKey,
          items: <Widget>[
            Icon(
              Icons.home,
              size: 30,
              color: Colors.white,
            ),
            Icon(
              Icons.grid_on,
              size: 30,
              color: Colors.white,
            ),
            Icon(
              Icons.shopping_basket_rounded,
              size: 30,
              color: Colors.white,
            ),
            Icon(
              Icons.person,
              size: 30,
              color: Colors.white,
            ),
          ],
          onTap: (index) {
            print(index);
            setState(() {
              title = titleName[index];
              _page = index;
              print(_page);
              _controller.jumpToPage(_page);
            });
          },
        ),
        // AnimatedContainer(
        //   //color: Theme.of(context).primaryColor,
        //   duration: Duration(milliseconds: 500),
        //   //height: isVisible ? 56.0 : 0.0,
        //   child: Wrap(children: <Widget>[
        //     BottomNavigationBar(
        //       backgroundColor: Theme.of(context).primaryColor,
        //       showSelectedLabels: true,
        //       showUnselectedLabels: true,
        //       iconSize: 30.0,
        //       selectedItemColor: orangecolor,
        //       unselectedItemColor: Colors.grey,
        //       currentIndex: currentTab,
        //       onTap: (index) {
        //         setState(() {
        //           currentTab = index;
        //           currentPage = pages[index];
        //           title = titleName[index];
        //         });
        //         print(index);
        //       },
        //       type: BottomNavigationBarType.fixed,
        //       items: <BottomNavigationBarItem>[
        //         BottomNavigationBarItem(
        //           //backgroundColor: Colors.white,
        //           icon: Icon(
        //             Icons.home_work,
        //           ),
        //           title: Text(translator.translate("Department")),
        //         ),
        //         BottomNavigationBarItem(
        //           icon: Icon(
        //             Icons.home,
        //           ),
        //           title: Text(translator.translate("Home")),
        //         ),
        //         BottomNavigationBarItem(
        //           icon: Icon(
        //             Icons.shopping_cart,
        //           ),
        //           title: Text(translator.translate("Cart")),
        //         ),
        //         BottomNavigationBarItem(
        //           icon: Icon(
        //             Icons.person,
        //           ),
        //           title: Text(translator.translate("Account")),
        //         ),
        //       ],
        //     ),
        //   ]),
        // ),

        body: PageView(
          physics: BouncingScrollPhysics(),
          controller: _controller,
          onPageChanged: (value) {
            setState(() {
              _page = value;
            });
          },
          children: [
            MainHomeScreen(),
            HomeScreen(),
            CartScreen(),
            _isLoggedIn ? MyProfile() : LoginPage()
          ],
        ),
        //currentPage,
        drawer: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: bluecolor,
          ),
          child: Drawer(
              // Add a ListView to the drawer. This ensures the user can scroll
              // through the options in the drawer if there isn't enough vertical
              // space to fit everything.
              child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              // image: DecorationImage(
              //   image: AssetImage("images/logo.jpeg"),
              //   fit: BoxFit.contain,
              //   colorFilter: new ColorFilter.mode(
              //       bluecolor.withOpacity(0.3), BlendMode.dstATop),
              // )
            ),
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  padding: EdgeInsets.all(5.0),
                  child: _isLoggedIn
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            new CircleAvatar(
                              radius: 60.0,
                              backgroundColor: Colors.white,
                              child: new Image.asset(
                                'images/logo.jpeg',
                                fit: BoxFit.contain,
                                width: 80,
                                height: 80,
                              ), //For Image Asset
                            ),
                            Text('Welcome',
                                style: TextStyle(
                                    color: Theme.of(context).bottomAppBarColor,
                                    fontSize: 20.0)),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            new CircleAvatar(
                              radius: 60.0,
                              backgroundColor: Colors.white,
                              child: new Image.asset(
                                'images/logo.jpeg',
                                fit: BoxFit.contain,
                                width: 80,
                                height: 80,
                              ), //For Image Asset
                            ),
                            Text(
                              'Hello Guest',
                              style: TextStyle(
                                  color: Theme.of(context).bottomAppBarColor,
                                  fontSize: 20.0),
                            ),
                          ],
                        ),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                        bluecolor,
                        bluecolor,
                        // Colors.white,
                        // bluecolor
                      ])),
                ),
                ListTile(
                  leading: Icon(Icons.supervised_user_circle_rounded,
                      size: 30, color: Colors.black),
                  title: Text(
                    translator.translate('Profile'),
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    // Update the state of the app.
                    // ..._isLoggedIn
                    _isLoggedIn
                        ? Navigator.of(context).push(new MaterialPageRoute(
                            builder: (BuildContext context) => MyProfilePage()))
                        : Navigator.of(context).push(new MaterialPageRoute(
                            builder: (BuildContext context) => LoginPage()));
                  },
                ),
                ListTile(
                  leading:
                      Icon(Icons.account_box, size: 30, color: Colors.black),
                  title: Text(
                    translator.translate('About Us'),
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                  onTap: () {
                    // Navigator.pop(context);
                    // // Update the state of the app.
                    // // ...
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (BuildContext context) => AboutUs()));
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.lock,
                    size: 30,
                    color: Colors.black,
                  ),
                  title: Text(
                    translator.translate('Privacy Policy'),
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                  onTap: () {
                    // Navigator.pop(context);
                    // // Update the state of the app.
                    // // ...
                    //
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (BuildContext context) => PrivacyPolicy()));
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.loyalty,
                    size: 30,
                    color: Colors.black,
                  ),
                  title: Text(
                    translator.translate('Terms and Conditions'),
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                  onTap: () {
                    // Navigator.pop(context);
                    //
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (BuildContext context) => TermsCondition()));
                    // Update the state of the app.
                    // ...
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.lock,
                    size: 30,
                    color: Colors.black,
                  ),
                  title: Text(
                    translator.translate("change password"),
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                  onTap: () async {
                    // Navigator.pop(context);
                    // // Update the state of the app.
                    // // ...
                    //
                    print(isloggedin);
                    _isLoggedIn
                        ? Navigator.of(context).push(new MaterialPageRoute(
                            builder: (BuildContext context) => ChangePassword(
                                  userId: customerId,
                                )))
                        : Navigator.of(context).push(new MaterialPageRoute(
                            builder: (BuildContext context) => LoginPage()));
                    // if (isloggedin == true) {
                    //   SharedPreferences localStorage =
                    //       await SharedPreferences.getInstance();
                    //   String customerId = localStorage.getString('userID');
                    //   print(customerId);
                    //   Navigator.of(context).push(new MaterialPageRoute(
                    //       builder: (BuildContext context) => ));
                    // } else {
                    //   Navigator.of(context).push(new MaterialPageRoute(
                    //       builder: (BuildContext context) => LoginPage()));
                    // }
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.language_sharp,
                    size: 30,
                    color: Colors.black,
                  ),
                  title: Text(
                    translator.translate('buttonTitle'),
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                  onTap: () async {
                    langChanged = translator.translate('buttonTitle');
                    print("Selected Language is =========>>>>>>$langChanged");
                    SharedPreferences localStorage =
                        await SharedPreferences.getInstance();
                    localStorage.setBool('isLangArabic', true);
                    localStorage.setString('selectedLanguage', arLang);
                    localStorage.setString('LangSelect', langChanged);
                    setState(() {
                      translator.setNewLanguage(
                        context,
                        newLanguage:
                            translator.currentLanguage == 'ar' ? 'en' : 'ar',
                        remember: true,
                        restart: true,
                      );
                    });
                    print("Changed Language To Arabic");
                  },
                ),
                _isLoggedIn
                    ? ListTile(
                        leading:
                            Icon(Icons.logout, size: 30, color: Colors.black),
                        title: Text(
                          translator.translate('Log Out'),
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          _logoutFromTheApp(context);
                          // Navigator.of(context).push(new MaterialPageRoute(
                          //     builder: (BuildContext context) => ContactUs()));
                          // Update the state of the app.
                          // ...
                        },
                      )
                    : Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: FlatButton(
                          color: Theme.of(context).primaryColor,
                          textColor: bluecolor,
                          disabledColor: Colors.grey,
                          disabledTextColor: Colors.black,
                          padding: EdgeInsets.all(8.0),
                          splashColor: Colors.blueAccent,
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    LoginPage()));
                          },
                          child: Text(
                            translator.translate("Login"),
                            style:
                                TextStyle(fontSize: 20.0, color: Colors.white),
                          ),
                        ),
                      ),
              ],
            ),
          )),
        ),
      ),
    );
  }

  void _logoutFromTheApp(context) {
    AppSharedPreferences.clear();
    Navigator.pushReplacement(
      context,
      new MaterialPageRoute(builder: (context) => LanguageScreen()),
    );
  }

  void checkIsvisible(bool value) {
    setState(() {
      isVisible = value;
      print("value iss $value");
    });
  }
}
