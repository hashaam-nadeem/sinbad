import 'package:brqtrapp/screens/category_screen.dart';
import 'package:brqtrapp/screens/item_card.dart';
import 'package:brqtrapp/screens/loginscreen.dart';
import 'package:brqtrapp/screens/productcard.dart';
import 'package:brqtrapp/screens/vendorsbydepart_screen.dart';
import 'package:brqtrapp/utils/app_shared_preferences.dart';
import 'package:brqtrapp/utils/constant.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:loading_gifs/loading_gifs.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'categoryrelatedproduct.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = false;
  int selectedDepartment;
  int initialDepartment;
  bool _isLoggedIn = false;
  List departmentData = new List();
  List finalData = new List();
  var arLang = "Ar";
  var lang;
  var langChanged;
  @override
  void initState() {
    // TODO: implement initState
    _getDepartmentData();
    super.initState();
    _checkIfLoggedIn();
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

  Future getdepartmentCategories() async {
    // setState(() {
    //   _isLoading = true;
    // });

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    //var token = localStorage.getString('token');
    lang = localStorage.getString('selectedLanguage');
    langChanged = localStorage.getString('LangSelect');

    var url =
        "${APIConstants.API_BASE_URL_DEV + APIOperations.categorieslist}?DepartmentId=$selectedDepartment";
    Map<String, String> requestHeaders = {
      //'Content-type': 'application/json',
      //'Accept': 'application/json',
      'x-api-key': '987654',
      //'Authorization': 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjZmMjc2ZGU3YTI1YWE3MDlmOTdiYjcwZDllODY3ZGNjNzllNWRjMzJmOGZlZjNlNWQ1YzhlMzM5YTU5ZjMyNTU2YWNlZWM1YTdlZDc3MjY0In0.eyJhdWQiOiIyIiwianRpIjoiNmYyNzZkZTdhMjVhYTcwOWY5N2JiNzBkOWU4NjdkY2M3OWU1ZGMzMmY4ZmVmM2U1ZDVjOGUzMzlhNTlmMzI1NTZhY2VlYzVhN2VkNzcyNjQiLCJpYXQiOjE1ODA1NDM5ODUsIm5iZiI6MTU4MDU0Mzk4NSwiZXhwIjoxNjEyMTY2Mzg1LCJzdWIiOiIxMzIiLCJzY29wZXMiOltdfQ.h33_EIU37oXVwrBR3bU6Y7NzyoM4m1wue-09NkDOh4AEimZ9mjjoqxU2fvGEZ_Bo-o6sE5hNg_84bJ-WctedsnoEdwNSPt1O_1SWIrIFhyU5vvv1i9HyBIKx_l4uZLcC-C52TxxvO2awQrrDHPxcbAsyqqa7Z3jh02dAN91r-6Oe0XaH6OV-FabwSMdsWh028GxuIzJwATfHA_zPfDtIquG1TBLc7Q9cFOzlio7IOy3tOLCxVL4f_vt-aOwVF0C0M_eTgk8znI7nTpWk3TgKN_OjRegxbkSGXrS59SIMNZUhMBI1j1vmzSFmRlpEZ8vj5csFxnmTv9oT5tLviD06y8TIISHifpUMI4z2o4rg_qFQbHTAkf37pw2TCfsbzL5sIWMFwWNvbpeKmplurcsnqbzcXl7STqrHftWEwxz6a4Cjrt2fCcxWAkS3CzraANhMkDFuS9oaRqLGfGsZytOZVLTYzQi3HanEip_NqhtEDLhkiEZ6LSJg9CSkk9q9gjruM3zs-l_GijkwJZpdgHwb06SXQb1hF8sS-pcXMwKHU-nF9zKoYZYjodSLaawFtNleylQqZO1mg9gK0XEoMHqm1NXdJH54mqSjoIKmDtKPbmGINzERRB6Cls0pHjC5Z82JBZ9g7xwmOJbMGdN7i2rZhOzs4Mq-eT85nsP2-SNPiJE'
    };
    final response = await http.get(url, headers: requestHeaders);
    //final List<FavoriteItem> favProducts = [];
    print("all category list: ${json.decode(response.body)}");
    var jsonData = json.decode(response.body);
    return jsonData['Data'];
    //return favData;
    // final deptData = favData['Data'];
    // print("All Department data ===========->>> $deptData");
    // List dataDepart = new List();
    // var dataLength = deptData.length;
    // for (int i = 0; i < dataLength; i++) {
    //   dataDepart.add(deptData[i]);
    // }
    // //print("All Department data ===========->>> ${favData[]}");

    // //var favProd = favData['product'];
    // // print('favorite Product Name - $favProd');

    // if (!mounted) return;
    // setState(() {
    //   _isLoading = false;
    //   //favoriteData = favData;
    //   departmentData.addAll(dataDepart);
    //   finalData = departmentData;
    //   //print("Department Names are =======>>>> ${finalData[0]["NameEn"]}");
    // });

    //print('data isss $favData["data"]');
    // if (favoriteData == null) {
    //   return;
    // }
    // _favorite = favProducts;
  }

  Future<dynamic> _getDepartmentData() async {
    setState(() {
      _isLoading = true;
    });

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    var lang;
    lang = localStorage.getString('selectedLanguage');

    var url = APIConstants.API_BASE_URL_DEV + APIOperations.HOME_PAGE;
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
    print("All Department data ===========->>> $deptData");
    List dataDepart = new List();
    var dataLength = deptData.length;
    for (int i = 0; i < dataLength; i++) {
      setState(() {
        selectedDepartment = deptData[0]['Id'];
      });
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
    return Scaffold(
      backgroundColor: Colors.white,
      //backgroundColor: Theme.of(context).accentColor,
      // appBar: AppBar(
      //   elevation: 0.0,
      //   // leading: new IconButton(
      //   //     icon: Platform.isIOS ? new Icon(Icons.arrow_back_ios) : new Icon(Icons.arrow_back),
      //   //     onPressed: (){
      //   //       Navigator.push(
      //   //         context,
      //   //         MaterialPageRoute(builder: (context) => MainScreen(0)),
      //   //       );
      //   //     }
      //   // ),
      //   automaticallyImplyLeading: true, // hides leading widget
      //   title: Text(
      //     translator.translate('Departments'),
      //     style: TextStyle(
      //       color: Colors.white,
      //     ),
      //   ),
      //   backgroundColor: Theme.of(context).primaryColor,
      //   //elevation: 0.0,
      //   // centerTitle: true,
      // ),
      body: _isLoading
          ? _buildProgressIndicator()
          : SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 2),
                        padding: EdgeInsets.all(12),
                        width: MediaQuery.of(context).size.width * .3,
                        height: MediaQuery.of(context).size.height * .798,
                        color: bluecolor,
                        child: ListView.builder(
                          itemBuilder: (context, int index) {
                            return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedDepartment = finalData[index]['Id'];
                                  });
                                },
                                child: Column(
                                  children: [
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .25,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .12,
                                        margin: EdgeInsets.only(top: 5),
                                        //  color: bluecolor.withOpacity(0.5),
                                        child: Center(
                                            child: ItemCard(
                                                image: finalData[index]
                                                    ['Photo'],
                                                title: finalData[index]
                                                    ['NameEn'],
                                                titleAr: finalData[index]
                                                    ['NameAr'],
                                                Id: finalData[index]['Id'],
                                                press: () {
                                                  setState(() {
                                                    selectedDepartment =
                                                        finalData[index]['Id'];
                                                  });
                                                  getdepartmentCategories();
                                                }
                                                // Navigator.push(
                                                //     context,
                                                //     MaterialPageRoute(
                                                //       builder: (context) =>
                                                //           VendorsByDepartmentScreen(
                                                //         id: finalData[index]['Id'],
                                                //         // nameEN: finalData[index]['VendorNameEn'],
                                                //         // nameAR:finalData[index]['VendorNameAr'],
                                                //         // vendorLogo:finalData[index]['Logo'],
                                                //       ),
                                                //     )),
                                                ))),
                                    Divider(
                                      height: 5,
                                      thickness: 3,
                                      color: orangecolor,
                                    ),
                                  ],
                                ));
                          },
                          itemCount: finalData.length,
                        ),
                      ),
                      FutureBuilder(
                        future: getdepartmentCategories(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Expanded(
                              child: Container(
                                height: MediaQuery.of(context).size.height * .8,
                                child: GridView.builder(
                                    itemCount: snapshot.data.length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 1,
                                      mainAxisSpacing: 0.2,
                                      crossAxisSpacing: 0.2,
                                      childAspectRatio: 1.7,
                                      //childAspectRatio: 1 / 1,
                                    ),
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            new MaterialPageRoute(
                                                builder: (context) =>
                                                    CategoryProducts(
                                                      id: snapshot.data[index]
                                                          ['CategoryId'],
                                                      name: snapshot.data[index]
                                                          ['NameEn'],
                                                      nameAr:
                                                          snapshot.data[index]
                                                              ['NameAr'],
                                                    )),
                                          );
                                        },
                                        child: Container(
                                            padding: EdgeInsets.all(2),
                                            margin: EdgeInsets.only(
                                                left: 2, bottom: 3),
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .2,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .32,
                                            // height: MediaQuery.of(context).size.height *
                                            //     .13,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              // borderRadius: BorderRadius.all(
                                              //     Radius.circular(12)),
                                              image: DecorationImage(
                                                image: snapshot.data[index]
                                                            ['Photo']
                                                        .toString()
                                                        .isNotEmpty
                                                    ? NetworkImage(
                                                        "${snapshot.data[index]['Photo']}")
                                                    : AssetImage(
                                                        "images/women_shirt1.png"),
                                                fit: BoxFit.cover,
                                                colorFilter:
                                                    new ColorFilter.mode(
                                                        Colors.grey
                                                            .withOpacity(0.4),
                                                        BlendMode.darken),
                                              ),
                                            ),
                                            child: Center(
                                                child: lang == "Ar" &&
                                                        langChanged != "English"
                                                    ? Text(
                                                        "${snapshot.data[index]['NameAr']}",
                                                        overflow:
                                                            TextOverflow.clip,
                                                        textAlign:
                                                            TextAlign.center,
                                                        maxLines: 2,
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18,
                                                        ),
                                                      )
                                                    : Text(
                                                        "${snapshot.data[index]['NameEn']}",
                                                        overflow:
                                                            TextOverflow.clip,
                                                        textAlign:
                                                            TextAlign.center,
                                                        maxLines: 2,
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18,
                                                        ),
                                                      ))),
                                      );
                                    }),
                              ),
                            );
                          } else {
                            return Container(
                              width: MediaQuery.of(context).size.width * .7,
                              child: Center(
                                  child: LoadingRotating.square(
                                borderColor: bluecolor,
                                backgroundColor: bluecolor,
                              )),
                            );
                          }
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),

      // GridView.builder(
      //     itemCount: finalData.length,
      //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      //       crossAxisCount: 2,
      //       mainAxisSpacing: 6.0,
      //       crossAxisSpacing: 2.0,
      //       childAspectRatio: 0.90,
      //       //childAspectRatio: 1 / 1,
      //     ),
      //     itemBuilder: (context, index) => ItemCard(
      //           image: finalData[index]['Photo'],
      //           title: finalData[index]['NameEn'],
      //           titleAr: finalData[index]['NameAr'],
      //           Id: finalData[index]['Id'],
      //           press: () => Navigator.push(
      //               context,
      //               MaterialPageRoute(
      //                 builder: (context) =>
      //                     VendorsByDepartmentScreen(id: finalData[index]['Id'],
      //                       // nameEN: finalData[index]['VendorNameEn'],
      //                       // nameAR:finalData[index]['VendorNameAr'],
      //                       // vendorLogo:finalData[index]['Logo'],
      //                     ),
      //               )),
      //         )),

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

  void _logoutFromTheApp(context) {
    AppSharedPreferences.clear();
    Navigator.pushReplacement(
      context,
      new MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
}
