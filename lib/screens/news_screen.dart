import 'package:brqtrapp/screens/loginscreen.dart';
import 'package:brqtrapp/screens/news_detail_screen.dart';
import 'package:brqtrapp/utils/app_shared_preferences.dart';
import 'package:brqtrapp/utils/constant.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:jiffy/jiffy.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewsScreen extends StatefulWidget {
  final title;

  const NewsScreen({Key key, this.title}) : super(key: key);
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  bool _isLoggedIn = false;
  var arLang = "Ar";
  final title = "News";
  bool _isLoading = false;
  int page = 1;
  int last_page=0;
  bool _isBottomBarVisible = false;
  List news = new List();
  List newData = new List();
  var lang;
  var langChanged;


  final ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    _getDeptProduct(1);
    //_getDepartmentData();
    super.initState();
    _checkIfLoggedIn();
    _isBottomBarVisible = true;
    _scrollController.addListener(
          () {
        if (_scrollController.position.userScrollDirection ==
            ScrollDirection.reverse) {
          if (_isBottomBarVisible)
            setState(() {
              _isBottomBarVisible = false;
              //widget.isVisible(_isBottomBarVisible);
              print("scrrolll test 11111");

            });
        }
        if (_scrollController.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (!_isBottomBarVisible)
            setState(() {
              _isBottomBarVisible = true;
              //widget.isVisible(_isBottomBarVisible);

            });
        }
      },
    );



    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if(last_page >= page) {
          page++;
          //_getMoreData(page,''); ////Uncomment for More data
          //page++;
        }
//        else{
//          setState(() {
//            filterName= null;
//            users =null;
//          });
//        }
      }
    });
  }


  Future<dynamic>_getDeptProduct(int index) async{
    // SharedPreferences saveBranchID = await SharedPreferences.getInstance();
    // var branchId = saveBranchID.getString('branchId');

    // String catId;
    // String branchCheck;
    // if (categoryID == null) {
    //   catId = "&CategoryId=";
    // } else {
    //   catId = "&CategoryId=${categoryID.toString()}";
    // }
    setState(() {
      _isLoading = true;
    });
    //SharedPreferences localStorage = await SharedPreferences.getInstance();
    //var token = localStorage.getString('token');
    var url = APIConstants.API_BASE_URL_DEV + "/getNews?Page=$page";
    print("Product by Vendors is --->> $url");
    Map<String, String> requestHeaders = {
      //'Accept': 'application/json',
      'x-api-key': '987654',
    };
    final response = await http.get(url, headers: requestHeaders);
    final catData = json.decode(response.body);
    print("All News Data- $catData");
    final catProductData = catData['Data'];
    //print('Mazeed is printing here!');
    List dataRes = new List();
    var dataLength=catProductData.length;
    for (int i = 0; i <  dataLength; i++) {
      dataRes.add(catProductData[i]);
    }
    //print("All category data ===========->>> $deptData");
    // List dataCats = new List();
    // var dataLength = catsData.length;
    // for (int i = 0; i < dataLength; i++) {
    //   dataCats.add(catsData[i]);
    // }
    setState(() {
      // categoryData.addAll(dataCats);
      // categoryList = categoryData;
      //_getTotal(cartData);
      _isLoading = false;
      news.addAll(dataRes);
      //last_page = response.data["last_page"];
      newData = news;
      print("in stock available ${newData[index]}");
    });

    if (newData == null) {
      return;
    }
  }

  void _checkIfLoggedIn() async {
    // check if token is there
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    lang = localStorage.getString('selectedLanguage');
    langChanged = localStorage.getString('LangSelect');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      //   // title: Text(
      //   //   translator.translate("News"),
      //   //   style: TextStyle(
      //   //     color: Colors.white,
      //   //   ),
      //   // ),
      //   title: Text(translator.translate(title),),
      //   backgroundColor:Theme.of(context).primaryColor,
      //   //elevation: 0.0,
      //   // centerTitle: true,
      // ),
      // body: Container(
      //   decoration: BoxDecoration(
      //     //color: product.color,
      //     borderRadius: BorderRadius.all(Radius.circular(50.0)),
      //   ),
      //   child: Center(
      //     child: ClipRRect(
      //       borderRadius: BorderRadius.vertical(top: Radius.circular(120.0),bottom: Radius.circular(55.0),),
      //       child: Image.asset("images/cm.png",
      //         fit: BoxFit.contain,
      //       ),
      //     ),
      //   ),
      //   // child: Center(child: Text("Coming Soon!",style: TextStyle(fontSize: 25.0,color: Colors.grey,
      //   //   fontWeight: FontWeight.w600,),),),
      // ),
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
        body: new ListView(
            controller: _scrollController,
            shrinkWrap: true,
            padding: const EdgeInsets.all(2.0),
            children: List.generate(newData.length, (index) {
              return InkWell(
                onTap: (){
                  print("${newData[index]['Id']}");
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => NewsDetailScreen(
                        newId:newData[index]['Id'],
                        title:newData[index]['TitleEn'],
                        titleAr:newData[index]['TitleAr'],
                        des:newData[index]['DescriptionEn'],
                        desAr:newData[index]['DescriptionAr'],
                        img:newData[index]['Photo'],
                        date:newData[index]['DateAndTime'],


                      )));
                },
                child: Card(
                  color: Colors.grey[100],
                  elevation: 0.0,
                  //color: Color(0xffe1e1e1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: 6.0,
                      ),
                      ClipRRect(
                        borderRadius:lang =="Ar"&& langChanged!="English"? BorderRadius.only(
                            topRight:  const  Radius.circular(15.0),
                            bottomRight:  const  Radius.circular(15.0)
                        ): BorderRadius.only(
                          topLeft:  const  Radius.circular(15.0),
                            bottomLeft:  const  Radius.circular(15.0)
                        ),

                        child: Container(

                          decoration: BoxDecoration(
                            //shape: BoxShape.circle,
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(UIsizes.INPUT_BUTTON_BORDER_RADIUS)),
                          height: 120.0,
                          width: 130.0,

                          child: newData[index]['Photo'].length != 0? CachedNetworkImage(
                            imageUrl: newData[index]['Photo'] != [] ?'${newData[index]['Photo']}' : Image.asset(
                                'images/applogo.png'),
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                Image.asset('images/applogo.png',fit: BoxFit.cover,),
                            errorWidget: (context, url, error) =>
                                Image.asset(
                                  'images/applogo.png',fit: BoxFit.cover,), //new Icon(Icons.error),
                          ) : Image.asset('images/applogo.png', fit: BoxFit.cover,),

                        ),
                      ),
                      SizedBox(
                        width: 12.0,
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                          child: Column(

                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              lang == "Ar" && langChanged != "English" ?Text(
                                "${newData[index]['TitleAr']}",
                                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                              ):Text(
                                "${newData[index]['TitleEn']}",
                                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10.0),
                              Row(
                                //mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Icon(Icons.calendar_today_rounded,size: 18,color: Theme.of(context).primaryColor,),
                                  SizedBox(width: 10,),
                                  Text(
                                    "${Jiffy("${newData[index]['DateAndTime']}").yMMMMd}",
                                    style: TextStyle(
                                        fontSize: 13.0,
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),

                              // Container(
                              //   decoration: BoxDecoration(
                              //     //border: Border.all(color: Color(0xFFD3D3D3), width: 2.0),
                              //     borderRadius: BorderRadius.circular(10.0),
                              //   ),
                              //   width: 100.0,
                              //   height: 35.0,
                              //   child: Padding(
                              //     padding: EdgeInsets.symmetric(
                              //       horizontal: 6.0,
                              //     ),
                              //     // child: Row(
                              //     //   crossAxisAlignment: CrossAxisAlignment.center,
                              //     //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //     //   children: <Widget>[
                              //     //     InkWell(
                              //     //         onTap: () {
                              //     //           _minus(allCartData[index]['Price'],index,allCartData[index]['Quantity']);
                              //     //           _updateCartItems(allCartData[index]['CartId'], allCartData[index]['Quantity']);
                              //     //         },
                              //     //         child: Icon(Icons.remove_circle,
                              //     //             color: Color(0xFFD3D3D3))),
                              //     //     Text(
                              //     //       allCartData[index]['Quantity'].toString(),
                              //     //       style: TextStyle(fontSize: 15.0, color: Colors.grey),
                              //     //     ),
                              //     //     InkWell(
                              //     //         onTap: () {
                              //     //           _add(allCartData[index]['Price'],index,allCartData[index]['Quantity']);
                              //     //
                              //     //           _updateCartItems(allCartData[index]['CartId'], allCartData[index]['Quantity']);
                              //     //         },
                              //     //         child: Icon(Icons.add_circle,
                              //     //             color: Theme.of(context).primaryColor)),
                              //     //   ],
                              //     // ),
                              //   ),
                              // ),
                              // SizedBox(height: 5.0),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }))
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


// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final title = "ListView List";
//
//     List choices = const [
//       const Choice(
//           title: 'MacBook Pro',
//           date: '1 June 2019',
//           description:
//           'MacBook Pro (sometimes abbreviated as MBP) is a line of Macintosh portable computers introduced in January 2006 by Apple Inc.',
//           imglink:
//           'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60'),
//       const Choice(
//           title: 'MacBook Air',
//           date: '1 June 2016',
//           description:
//           'MacBook Air is a line of laptop computers developed and manufactured by Apple Inc. It consists of a full-size keyboard, a machined aluminum case, and a thin light structure.',
//           imglink:
//           'https://images.unsplash.com/photo-1499673610122-01c7122c5dcb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60'),
//       const Choice(
//           title: 'iMac',
//           date: '1 June 2019',
//           description:
//           'iMac is a family of all-in-one Macintosh desktop computers designed and built by Apple Inc. It has been the primary part of Apple consumer desktop offerings since its debut in August 1998, and has evolved through seven distinct forms.',
//           imglink:
//           'https://images.unsplash.com/photo-1517059224940-d4af9eec41b7?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60'),
//       const Choice(
//           title: 'Mac Mini',
//           date: '1 June 2017',
//           description:
//           'Mac mini (branded with lowercase "mini") is a desktop computer made by Apple Inc. One of four desktop computers in the current Macintosh lineup, along with the iMac, Mac Pro, and iMac Pro, it uses many components usually featured in laptops to achieve its small size.',
//           imglink:
//           'https://www.apple.com/v/mac-mini/f/images/shared/og_image__4mdtjbfhcduu_large.png?201904170831'),
//       const Choice(
//           title: 'Mac Pro',
//           date: '1 June 2018',
//           description:
//           'Mac Pro is a series of workstation and server computer cases designed, manufactured and sold by Apple Inc. since 2006. The Mac Pro, in most configurations and in terms of speed and performance, is the most powerful computer that Apple offers.',
//           imglink:
//           'https://i0.wp.com/9to5mac.com/wp-content/uploads/sites/6/2017/01/mac-pro-2-concept-image.png?resize=1000%2C500&quality=82&strip=all&ssl=1'),
//     ];
//
//     return MaterialApp(
//         title: title,
//         home: Scaffold(
//             appBar: AppBar(
//               title: Text(title),
//             ),
//             body: new ListView(
//                 shrinkWrap: true,
//                 padding: const EdgeInsets.all(20.0),
//                 children: List.generate(choices.length, (index) {
//                   return Center(
//                     child: ChoiceCard(
//                         choice: choices[index], item: choices[index]),
//                   );
//                 }))));
//   }
// }
//
// class Choice {
//   final String title;
//   final String date;
//   final String description;
//   final String imglink;
//
//   const Choice({this.title, this.date, this.description, this.imglink});
// }
//
// class ChoiceCard extends StatelessWidget {
//   const ChoiceCard(
//       {Key key,
//         this.choice,
//         this.onTap,
//         @required this.item,
//         this.selected: false})
//       : super(key: key);
//
//   final Choice choice;
//
//   final VoidCallback onTap;
//
//   final Choice item;
//
//   final bool selected;
//
//   @override
//   Widget build(BuildContext context) {
//     TextStyle textStyle = Theme.of(context).textTheme.display1;
//
//     if (selected)
//       textStyle = textStyle.copyWith(color: Colors.lightGreenAccent[400]);
//
//     return Card(
//         color: Colors.white,
//         child: Column(
//           children: [
//             new Container(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Image.network(choice.imglink)),
//             new Container(
//               padding: const EdgeInsets.all(10.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(choice.title, style: Theme.of(context).textTheme.title),
//                   Text(choice.date,
//                       style: TextStyle(color: Colors.black.withOpacity(0.5))),
//                   Text(choice.description),
//                 ],
//               ),
//             )
//           ],
//           crossAxisAlignment: CrossAxisAlignment.start,
//         ));
//   }
// }