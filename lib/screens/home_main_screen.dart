import 'package:brqtrapp/classes/language.dart';
import 'package:brqtrapp/localization/demo_localization.dart';
import 'package:brqtrapp/main.dart';
import 'package:brqtrapp/screens/allproducts.dart';
import 'package:brqtrapp/screens/banner_slider.dart';
import 'package:brqtrapp/screens/dept_listview.dart';
import 'package:brqtrapp/screens/loginscreen.dart';
import 'package:brqtrapp/screens/product_detail_screen.dart';
import 'package:brqtrapp/screens/totalsalelist.dart';
import 'package:brqtrapp/screens/vendor_listview.dart';
import 'package:brqtrapp/utils/app_shared_preferences.dart';
import 'package:brqtrapp/utils/constant.dart';
import 'package:brqtrapp/utils/constant.dart';
import 'package:brqtrapp/utils/ui_helper.dart';
import 'package:brqtrapp/widgets/custom_divider.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MainHomeScreen extends StatefulWidget {
  @override
  _MainHomeScreenState createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  bool _isLoggedIn = false;
  var arLang = "Ar";
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  int page = 1;
  final ScrollController _scrollController = new ScrollController();
  List vendorData = new List();
  List finalData = new List();
  var lang;
  var langChanged;
  @override
  void initState() {
    // TODO: implement initState
    //_getDepartmentData();
    super.initState();
    getAllProducts();
    _checkIfLoggedIn();
  }

  Future<dynamic> getAllProducts() async {
    // setState(() {
    //   _isLoading = true;
    // });

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    //var token = localStorage.getString('token');
    lang = localStorage.getString('selectedLanguage');
    langChanged = localStorage.getString('LangSelect');
    // print("page no: ${widget.page}");
    var url =
        "${APIConstants.API_BASE_URL_DEV}${APIOperations.allProductList}?CurrentPage=0&NextPage=$page";
    Map<String, String> requestHeaders = {
      //'Content-type': 'application/json',
      //'Accept': 'application/json',
      'x-api-key': '987654',
      //'Authorization': 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjZmMjc2ZGU3YTI1YWE3MDlmOTdiYjcwZDllODY3ZGNjNzllNWRjMzJmOGZlZjNlNWQ1YzhlMzM5YTU5ZjMyNTU2YWNlZWM1YTdlZDc3MjY0In0.eyJhdWQiOiIyIiwianRpIjoiNmYyNzZkZTdhMjVhYTcwOWY5N2JiNzBkOWU4NjdkY2M3OWU1ZGMzMmY4ZmVmM2U1ZDVjOGUzMzlhNTlmMzI1NTZhY2VlYzVhN2VkNzcyNjQiLCJpYXQiOjE1ODA1NDM5ODUsIm5iZiI6MTU4MDU0Mzk4NSwiZXhwIjoxNjEyMTY2Mzg1LCJzdWIiOiIxMzIiLCJzY29wZXMiOltdfQ.h33_EIU37oXVwrBR3bU6Y7NzyoM4m1wue-09NkDOh4AEimZ9mjjoqxU2fvGEZ_Bo-o6sE5hNg_84bJ-WctedsnoEdwNSPt1O_1SWIrIFhyU5vvv1i9HyBIKx_l4uZLcC-C52TxxvO2awQrrDHPxcbAsyqqa7Z3jh02dAN91r-6Oe0XaH6OV-FabwSMdsWh028GxuIzJwATfHA_zPfDtIquG1TBLc7Q9cFOzlio7IOy3tOLCxVL4f_vt-aOwVF0C0M_eTgk8znI7nTpWk3TgKN_OjRegxbkSGXrS59SIMNZUhMBI1j1vmzSFmRlpEZ8vj5csFxnmTv9oT5tLviD06y8TIISHifpUMI4z2o4rg_qFQbHTAkf37pw2TCfsbzL5sIWMFwWNvbpeKmplurcsnqbzcXl7STqrHftWEwxz6a4Cjrt2fCcxWAkS3CzraANhMkDFuS9oaRqLGfGsZytOZVLTYzQi3HanEip_NqhtEDLhkiEZ6LSJg9CSkk9q9gjruM3zs-l_GijkwJZpdgHwb06SXQb1hF8sS-pcXMwKHU-nF9zKoYZYjodSLaawFtNleylQqZO1mg9gK0XEoMHqm1NXdJH54mqSjoIKmDtKPbmGINzERRB6Cls0pHjC5Z82JBZ9g7xwmOJbMGdN7i2rZhOzs4Mq-eT85nsP2-SNPiJE'
    };
    final response = await http.get(url, headers: requestHeaders);
    //final List<FavoriteItem> favProducts = [];
    final favData = json.decode(response.body);
    print("all products list: $favData");
    final deptData = favData['Data'];
    print("All products data ===========->>> $deptData");
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
      //_isLoading = false;
      //favoriteData = favData;
      vendorData.addAll(dataDepart);
      finalData = vendorData;
      //print("Department Names are =======>>>> ${finalData[0]["NameEn"]}");
    });

    //print('data isss $favData["data"]');
    // if (favoriteData == null) {
    //   return;
    // }
    // _favorite = favProducts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Theme.of(context).accentColor,
      // appBar: AppBar(
      //   actions: <Widget>[
      //     IconButton(
      //       icon: Icon(Icons.search),
      //       onPressed: () {
      //         print("Search Button Pressed!");
      //       },
      //     ),
      //     // IconButton(
      //     //   icon: Icon(Icons.person),
      //     //   onPressed: () {
      //     //   },
      //     // )
      //   ],
      //   //automaticallyImplyLeading: true,
      //   elevation: 0.0,
      //   // leading: new IconButton(
      //   //     icon: new Icon(Icons.search_rounded),
      //   //     onPressed: (){
      //   //       Navigator.push(
      //   //         context,
      //   //         MaterialPageRoute(builder: (context) => null),
      //   //       );
      //   //     }
      //   // ),
      //   title: Text(
      //     translator.translate('Dashboard'),
      //     style: TextStyle(
      //       color: Colors.white,
      //     ),
      //   ),
      //   backgroundColor:Theme.of(context).primaryColor,
      //   //elevation: 0.0,
      //   // centerTitle: true,
      // ),
      body: SafeArea(
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            // decoration: BoxDecoration(
            //   image: DecorationImage(
            //     image: AssetImage("images/logo.jpeg"),
            //     fit: BoxFit.contain,
            //     colorFilter: new ColorFilter.mode(
            //         lightblue.withOpacity(0.2), BlendMode.dstATop),
            //   )
            // ),
            child: SmartRefresher(
              controller: _refreshController,
              enablePullDown: false,
              enablePullUp: true,
              onLoading: () {
                print("loading");
                setState(() {
                  page = page + 1;
                });
                print("updated page count: $page");
                getAllProducts();
                _refreshController.loadComplete();
              },
              child: CustomScrollView(
                  controller: _scrollController,
                  shrinkWrap: true,
                  slivers: <Widget>[
                    SliverToBoxAdapter(
                      child: BannerImages(),
                    ),
                    SliverToBoxAdapter(
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: 15,
                          ),
                          Icon(
                            EvaIcons.home,
                            size: 28.0,
                            color: Theme.of(context).primaryColor,
                          ),
                          UIHelper.horizontalSpaceSmall(),
                          Text(
                            translator.translate('Top Departments'),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                              //fontWeight: FontWeight.bold,
                            ),
                            // style: Theme.of(context)
                            //     .textTheme
                            //     .headline4
                            //     .copyWith(fontSize: 20.0,fontWeight: FontWeight.bold,),
                          )
                        ],
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 10,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: DepartListView(),
                    ),
                    SliverToBoxAdapter(
                      child: VendorsListView(),
                    ),
                    SliverToBoxAdapter(
                      child: TotalSaleList(),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Text(
                          translator.translate('All Products'),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            //fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () async {
                              SharedPreferences localStorage =
                                  await SharedPreferences.getInstance();
                              var customerId = localStorage.getString('userID');
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProductDetailScreen(
                                            id: finalData[index]['Id'],
                                            titleAr: finalData[index]['NameAr'],
                                            title: finalData[index]['NameEn'],
                                            price: finalData[index]['Price'],
                                            description: finalData[index]
                                                ['DescriptionEn'],
                                            descriptionAr: finalData[index]
                                                ['DescriptionAr'],
                                            shortDes: finalData[index]
                                                ['ShortDescriptionEn'],
                                            shortDesAr: finalData[index]
                                                ['ShortDescriptionAr'],
                                            userId: customerId,
                                            vendorId: finalData[index]
                                                ['VendorId'],
                                            inStock: finalData[index]
                                                ['StockStatus'],
                                            // nameEN: finalData[index]['NameEn'],
                                            // nameAR: finalData[index]['NameAr'],
                                            // vendorLogo: finalData[index]['Photo'],
                                          )));
                            },
                            child: Container(
                                margin: const EdgeInsets.only(
                                    top: 10, left: 15, right: 15),
                                //   padding: EdgeInsets.all(4),
                                width: MediaQuery.of(context).size.width * .4,
                                height:
                                    MediaQuery.of(context).size.height * .32,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white,
                                    //  border: Border.all(color: bluecolor, width: 1)
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black.withOpacity(0.3),
                                          blurRadius: 1,
                                          spreadRadius: 0.2)
                                    ]),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .41,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .25,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(16)),
                                              // boxShadow: <BoxShadow>[
                                              //   BoxShadow(
                                              //     color: Colors.black12,
                                              //     blurRadius: 2.0,
                                              //   ),
                                              // ],
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                    "${finalData[index]['Photo']}",
                                                  ),
                                                  colorFilter:
                                                      new ColorFilter.mode(
                                                          Colors.grey
                                                              .withOpacity(0.4),
                                                          BlendMode.darken),
                                                  fit: BoxFit.cover)),
                                          // child: Center(
                                          //   child: Image.network(

                                          //     width:
                                          //         MediaQuery.of(context).size.width * .29,
                                          //     height:
                                          //         MediaQuery.of(context).size.height * .14,
                                          //     fit: BoxFit.contain,
                                          //   ),
                                          // )
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Flexible(
                                          child: lang == "Ar" &&
                                                  langChanged != "English"
                                              ? Text(
                                                  finalData[index]['NameAr'],
                                                  maxLines: 1,
                                                  textAlign: TextAlign.center,
                                                  overflow: TextOverflow.clip,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16.0,
                                                    //     fontWeight: FontWeight.bold,
                                                  ),
                                                  // style: Theme.of(context).textTheme.subtitle2.copyWith(
                                                  //   fontSize: 14.0,
                                                  //   fontWeight: FontWeight.w600,
                                                  // ),
                                                )
                                              : Text(
                                                  finalData[index]['NameEn'],
                                                  textAlign: TextAlign.center,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.clip,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16.0,
                                                    //    fontWeight: FontWeight.bold,
                                                  ),
                                                  // style: Theme.of(context).textTheme.subtitle2.copyWith(
                                                  //   fontSize: 14.0,
                                                  //   fontWeight: FontWeight.w600,
                                                  // ),
                                                ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Flexible(
                                          child: lang == "Ar" &&
                                                  langChanged != "English"
                                              ? Text(
                                                  "${translator.translate('Price')}: ${finalData[index]['Price']}",
                                                  maxLines: 1,
                                                  textAlign: TextAlign.center,
                                                  overflow: TextOverflow.clip,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14.0,
                                                    //    fontWeight: FontWeight.bold,
                                                  ),
                                                  // style: Theme.of(context).textTheme.subtitle2.copyWith(
                                                  //   fontSize: 14.0,
                                                  //   fontWeight: FontWeight.w600,
                                                  // ),
                                                )
                                              : Text(
                                                  "${translator.translate('Price')}: ${finalData[index]['Price']}",
                                                  textAlign: TextAlign.center,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.clip,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14.0,
                                                    //      fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                        )
                                      ],
                                    ),
                                  ],
                                )),
                          );
                        },
                        childCount: finalData.length,
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisSpacing: 0.2,
                          crossAxisSpacing: 0.2,
                          crossAxisCount: 2,
                          childAspectRatio: 0.7),

                      //  SliverGridDelegateWithMaxCrossAxisExtent(

                      //   maxCrossAxisExtent: 200.0,
                      //   mainAxisSpacing: 2.0,
                      //   crossAxisSpacing: 2.0,
                      //   childAspectRatio: 0.75,
                      // ),
                    ),

                    // SliverToBoxAdapter(
                    //   child:
                    // ),
                  ]),

              //  Column(
              //   children: <Widget>[
              //     Expanded(
              //       child:    ),
              //     // SingleChildScrollView(
              //     //   child: Column(
              //     //     crossAxisAlignment: CrossAxisAlignment.start,
              //     //     mainAxisSize: MainAxisSize.min,
              //     //     children: <Widget>[
              //     //       BannerImages(),
              //     //       Divider(
              //     //         height: 1,
              //     //         thickness: 1,
              //     //         indent: 20,
              //     //         endIndent: 20,
              //     //       ),
              //     //       SizedBox(
              //     //         height: 8,
              //     //       ),
              //     //       //CustomDividerView(),
              //     //       Row(
              //     //         children: <Widget>[
              //     //           SizedBox(
              //     //             width: 15,
              //     //           ),
              //     //           Icon(
              //     //             EvaIcons.home,
              //     //             size: 28.0,
              //     //             color: Theme.of(context).primaryColor,
              //     //           ),
              //     //           UIHelper.horizontalSpaceSmall(),
              //     //           Text(
              //     //             translator.translate('Top Departments'),
              //     //             style: TextStyle(
              //     //               color: Colors.black,
              //     //               fontSize: 18.0,
              //     //               //fontWeight: FontWeight.bold,
              //     //             ),
              //     //             // style: Theme.of(context)
              //     //             //     .textTheme
              //     //             //     .headline4
              //     //             //     .copyWith(fontSize: 20.0,fontWeight: FontWeight.bold,),
              //     //           )
              //     //         ],
              //     //       ),
              //     //       SizedBox(
              //     //         height: 8,
              //     //       ),
              //     //       DepartListView(),

              //     //       /// Top pick up
              //     //       Divider(
              //     //         height: 0.5,
              //     //         thickness: 1,
              //     //         indent: 20,
              //     //         endIndent: 20,
              //     //       ),
              //     //       VendorsListView(),
              //     //       Divider(
              //     //         height: 0.5,
              //     //         thickness: 1,
              //     //         indent: 20,
              //     //         endIndent: 20,
              //     //       ),
              //     //       TotalSaleList(),
              //     //       Divider(
              //     //         height: 0.8,
              //     //         thickness: 1,
              //     //         indent: 20,
              //     //         endIndent: 20,
              //     //       ),
              //     //       SizedBox(
              //     //         height: 8,
              //     //       ),
              //     //       Row(children: [
              //     //         SizedBox(
              //     //           width: 15,
              //     //         ),
              //     //         Icon(
              //     //           EvaIcons.pricetags,
              //     //           size: 28.0,
              //     //           color: Theme.of(context).primaryColor,
              //     //         ),
              //     //         SizedBox(
              //     //           width: 8,
              //     //         ),
              //     //         Text(
              //     //           translator.translate('All Products'),
              //     //           style: TextStyle(
              //     //             color: Colors.black,
              //     //             fontSize: 18.0,
              //     //             //fontWeight: FontWeight.bold,
              //     //           ),
              //     //         ),
              //     //       ] // style: Theme.of(context)
              //     //           //     .textTheme
              //     //           //     .headline4
              //     //           //     .copyWith(fontSize: 20.0,fontWeight: FontWeight.bold,),
              //     //           ),
              //     //       AllProductList(
              //     //         page: page,
              //     //       ),
              //     //     ],
              //     //   ),
              //     // ),
              //   ],
              // ),
            )),
      ),
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
      //          onTap: () async {
      //            SharedPreferences localStorage = await SharedPreferences.getInstance();
      //            localStorage.setBool('isLangArabic', true);
      //            localStorage.setString('selectedLanguage', arLang );
      //            setState(() {
      //             translator.setNewLanguage(
      //               context,
      //               newLanguage: translator.currentLanguage == 'ar' ? 'en' : 'ar',
      //               remember: true,
      //               restart: true,
      //             );
      //           });
      //            //Navigator.pop(context);
      //          // _changeLanguage(Language language);
      //            print("Changed Language To Arabic");
      //         //
      //         //   Navigator.of(context).push(new MaterialPageRoute(
      //         //       builder: (BuildContext context) => ContactUs()));
      //         //   // Update the state of the app.
      //         //   // ...
      //          },
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

  // void _changeLanguage(Language language){
  //   Locale _temp;
  //   // switch(language.languageCode){
  //   //   case
  //   // }
  //
  //   MyApp.setLocale(context, _temp);
  // }

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

  // void _logoutFromTheApp(context) {
  //   AppSharedPreferences.clear();
  //   Navigator.pushReplacement(
  //     context,
  //     new MaterialPageRoute(builder: (context) => LoginPage()),
  //   );
  // }
}
