import 'dart:convert';
import 'package:brqtrapp/screens/product_detail_screen.dart';
import 'package:brqtrapp/screens/product_items.dart';
import 'package:brqtrapp/utils/ui_helper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:brqtrapp/screens/category_items.dart';
import 'package:brqtrapp/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubCategoryScreen extends StatefulWidget {
  final id;

  const SubCategoryScreen({Key key, this.id}) : super(key: key);
  @override
  _SubCategoryScreenState createState() => _SubCategoryScreenState(id);
}

// class _SubCategoryScreenState extends State<SubCategoryScreen> {
//   final id;
//   List categoryList = new List();
//   List categoryData = new List();
//
//
//   bool _isBottomBarVisible;
//
// //  _HomePageState(this._isBottomBarVisible);
//   bool _isLoggedIn = false;
//   bool isLoading = false;
//   bool isOffline = false;
//   String sizeType;
//   String singleSizeType;
//   List<bool> listCheck = [];
//   double totalAmount = 0.0;
//   var selectedPrice;
//   var selectedBrId;
//   var selectedId;
//   var selectedProductIndex;
//   int totalCount = 0;
//   String branchName;
//   String name;
//   String username;
//   int categoryID;
//   //var category = new List();
//   int activeindex;
//
//   final ScrollController _scrollController = new ScrollController();
//   String title, imageUrl;
//   int productId, userId;
//   String price;
//   bool isFavorite = false;
//   bool isAdded = false;
//   String baseURL = "http://tastytea.tas-taz.com/api/product/";
//   int page = 1;
//   int last_page=0;
//   List users = new List();
//   final dio = new Dio();
//   final TextEditingController _filter = new TextEditingController();
//   String _searchText = "";
//   List filterName = new List();
//   Icon _searchIcon = new Icon(Icons.search, color: Color(0xFF34C47C));
//   Icon _backToLogin = new Icon(Icons.arrow_back_ios, color: Colors.white);
//   Widget _appBarTitle = new Text('Tasty Tea');
//   final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
//
//   List sizes = new List();
//   List pricesId = new List();
//   var singleItemAddID;
//
//   _SubCategoryScreenState(this.id);
//
//   @override
//   void initState() {
//     users.clear();
//     networkChecked();
//     //this._getMoreData(1,'');  ////Uncomment for More data
//     _checkIfLoggedIn();
//     _getSubCat();
//     _getDeptProduct();
//
// //    totalQuantity();
// //    _quantityCount;
//     super.initState();
//     //_getCartItemCount();
//     //_getMoreData(page);
//
//     _isBottomBarVisible = true;
//     // _scrollController = ScrollController();
//     _scrollController.addListener(
//           () {
//         if (_scrollController.position.userScrollDirection ==
//             ScrollDirection.reverse) {
//           if (_isBottomBarVisible)
//             setState(() {
//               _isBottomBarVisible = false;
//               //widget.isVisible(_isBottomBarVisible);
//               print("scrrolll test 11111");
//
//             });
//         }
//         if (_scrollController.position.userScrollDirection ==
//             ScrollDirection.forward) {
//           if (!_isBottomBarVisible)
//             setState(() {
//               _isBottomBarVisible = true;
//               //widget.isVisible(_isBottomBarVisible);
//
//             });
//         }
//       },
//     );
//
//
//
//     _scrollController.addListener(() {
//       if (_scrollController.position.pixels ==
//           _scrollController.position.maxScrollExtent) {
//         if(last_page >= page) {
//           page++;
//           //_getMoreData(page,''); ////Uncomment for More data
//           //page++;
//         }
// //        else{
// //          setState(() {
// //            filterName= null;
// //            users =null;
// //          });
// //        }
//       }
//     });
//   }
//
//   void _checkIfLoggedIn() async {
//     // check if token is there
//     SharedPreferences localStorage = await SharedPreferences.getInstance();
//     var token = localStorage.getString('token');
//     if (token != null) {
//       setState(() {
//         _isLoggedIn = true;
//         //_getCartItemCount();
//
//         //print("User Is Logged In");
//         // _gotoMainpage();
//       });
//     } else {
//       print("User Is Not Logged In");
// //      Navigator.pushReplacement(
// //        context,
// //        new MaterialPageRoute(builder: (context) => LoginPage()),
// //      );
//     }
//   }
//
//   networkChecked() async {
//     var connectivityResult = await (Connectivity().checkConnectivity());
//
//     if (connectivityResult == ConnectivityResult.mobile) {
//       return 'No Network Connection! Connected to Mobile Network';
//       print("Connected to Mobile Network");
//     } else if (connectivityResult == ConnectivityResult.wifi) {
//       print("Connected to WiFi");
//       return 'No WiFi Connection! Please Connected to WiFi';
//     } else {
//       isOffline = false;
//       showNoNetworkAlertDialog(context);
//       print("Unable to connect. Please Check Internet Connection");
//     }
//   }
//
//   Future<void> showNoNetworkAlertDialog(BuildContext context) async {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: true, // user must tap button!
//       builder: (BuildContext context) {
//         return CupertinoAlertDialog(
//           title: Text('Connection Alert!'),
//           content: Text('Unable to connect. Please Check Internet Connection'),
//           actions: <Widget>[
//             CupertinoDialogAction(
//               child: Text('Ok'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//
//   Future<dynamic>_getSubCat() async{
//     // SharedPreferences saveBranchID = await SharedPreferences.getInstance();
//     // var branchId = saveBranchID.getString('branchId');
//     setState(() {
//       isLoading = true;
//     });
//     //SharedPreferences localStorage = await SharedPreferences.getInstance();
//     //var token = localStorage.getString('token');
//     var url = APIConstants.API_BASE_URL_DEV + "/subcategories?CategoryId=$id";
//     print("Cat Url is --->> $url");
//     Map<String, String> requestHeaders = {
//       //'Accept': 'application/json',
//       'x-api-key': '987654',
//     };
//     final response = await http.get(url, headers: requestHeaders);
//     final catData = json.decode(response.body);
//     print("Category data- $catData");
//     final catsData = catData['Data'];
//     //print("All category data ===========->>> $deptData");
//     List dataCats = new List();
//     var dataLength = catsData.length;
//     for (int i = 0; i < dataLength; i++) {
//       dataCats.add(catsData[i]);
//     }
//     setState(() {
//       categoryData.addAll(dataCats);
//       categoryList = categoryData;
//       //_getTotal(cartData);
//       isLoading = false;
//     });
//
//     if (categoryList == null) {
//       return;
//     }
//   }
//   //
//   // Future getCategory() {
//   //   var url = APIConstants.API_BASE_URL_DEV + "/categories?DepartmentId=$id";
//   //   return http.get(url);
//   // }
//   // _getCat() {
//   //   API.getCategory().then((response) {
//   //     if(!mounted)return;
//   //     setState(() {
//   //       categoryList = json.decode(response.body);
//   //       // category = list.map((model) => Category.fromJson(model)).toList();
//   //
//   //     });
//   //   });
//   // }
//
//   Widget _buildProgressIndicator() {
//     return new Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: new Center(
//         child: new Opacity(
//           opacity: isLoading ? 1.0 : 00,
//           child: new CupertinoActivityIndicator(),
//         ),
//       ),
//     );
//   }
//
//
//   Future<dynamic>_getDeptProduct() async{
//     // SharedPreferences saveBranchID = await SharedPreferences.getInstance();
//     // var branchId = saveBranchID.getString('branchId');
//     setState(() {
//       isLoading = true;
//     });
//     //SharedPreferences localStorage = await SharedPreferences.getInstance();
//     //var token = localStorage.getString('token');
//     var url = APIConstants.API_BASE_URL_DEV + "/productsByDepartment?DepartmentId=$id";
//     print("Cat Url is --->> $url");
//     Map<String, String> requestHeaders = {
//       //'Accept': 'application/json',
//       'x-api-key': '987654',
//     };
//     final response = await http.get(url, headers: requestHeaders);
//     final catData = json.decode(response.body);
//     print("All Product data- $catData");
//     final catProductData = catData['Data'];
//     List dataRes = new List();
//     var dataLength=catProductData.length;
//     for (int i = 0; i <  dataLength; i++) {
//       dataRes.add(catProductData[i]);
//     }
//     //print("All category data ===========->>> $deptData");
//     // List dataCats = new List();
//     // var dataLength = catsData.length;
//     // for (int i = 0; i < dataLength; i++) {
//     //   dataCats.add(catsData[i]);
//     // }
//     setState(() {
//       // categoryData.addAll(dataCats);
//       // categoryList = categoryData;
//       //_getTotal(cartData);
//       isLoading = false;
//       users.addAll(dataRes);
//       //last_page = response.data["last_page"];
//       filterName = users;
//     });
//
//     if (categoryList == null) {
//       return;
//     }
//   }
//
//
// //   void _getMoreData(int index,searchItem) async {
// //     //print("cateid isss $categoryID");
// //
// //     String categoryCheck;
// //     String branchCheck;
// //     if(categoryID ==null){
// //       categoryCheck = "&category_id=";
// //     }else{
// //       categoryCheck = "&category_id=${categoryID.toString()}";
// //     }
// //
// //
// //     SharedPreferences localStorage = await SharedPreferences.getInstance();
// //     var selectedBranchId = localStorage.getString('branchId');
// //     //branchName =localStorage.getString('branch');
// //     var token = localStorage.getString('token');
// //
// //     if(selectedBranchId ==null){
// //       branchCheck = "branch_id=";
// //     }
// //     else{
// //       branchCheck = "branch_id=${selectedBranchId.toString()}";
// //     }
// //
// //     if (!isLoading) {
// //       setState(() {
// //         isLoading = true;
// //       });
// //
// //
// //       var urlGuest =
// //           "${APIConstants.API_BASE_URL_DEV}/api/product/?$branchCheck&page=${index.toString()}&search=$searchItem"+categoryCheck ;
// //
// //       var url =
// //           "${APIConstants.API_BASE_URL_DEV}/api/auth/product?$branchCheck&page=${index.toString()}&search=$searchItem"+categoryCheck;
// //       print(_isLoggedIn);
// //       Dio dio = new Dio();
// //       dio.options.headers = {'x-api-key': '987654',};
// //
// //       final response = await dio.get(token !=null ? url : urlGuest);
// //       List dataRes = new List();
// //       var dataLength=response.data['data'].length;
// //       for (int i = 0; i <  dataLength; i++) {
// //         dataRes.add(response.data['data'][i]);
// //       }
// //
// //
// //       //  var res = response.data['data'];
// //       // var pId = res[index]['id'];
// //       //  var allPriceTage = dataRes[index]["branches"][0]['price'][0];
// //
// // //      String sizeTypes = res[index]['size_type'];
// // //      String oneSizeTypes = res[index]['size_type'];
// //       if (!mounted) return;
// //       //SharedPreferences name = await SharedPreferences.getInstunce();
// //       // username= name.getString('name');
// //       setState(() {
// //         isLoading = false;
// //         //isAdded = false;
// //         users.addAll(dataRes);
// //         last_page = response.data["last_page"];
// //         filterName = users;
// //         print("result iss ${filterName[0]["cart"]}");
// // //        print("lnt iss ${filterName.length}");
// //
// //
// // //if(page ==1){
// // //  page++;
// // //}
// //         print("page number $page");
// //         if( _isLoggedIn) {
// //           //saveFcmToken();
// //           //_getCartItemCount();
// //
// //         }
// //       });
// //     }
// //   }
//
//   // Future<void> _getData() async  {
//   //   setState(() {
//   //     _getMoreData(1, "");
//   //   });
//   // }
//
//
//   //_SubCategoryScreenState(this.id);
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Theme.of(context).accentColor,
//         appBar: AppBar(
//           elevation: 0.0,
//           // leading: new IconButton(
//           //     icon: Platform.isIOS ? new Icon(Icons.arrow_back_ios) : new Icon(Icons.arrow_back),
//           //     onPressed: (){
//           //       Navigator.push(
//           //         context,
//           //         MaterialPageRoute(builder: (context) => MainScreen(0)),
//           //       );
//           //     }
//           // ),
//           title: Text(
//             "SubCategory",
//             style: TextStyle(
//               color: Colors.white,
//             ),
//           ),
//           backgroundColor:Theme.of(context).primaryColor,
//           //elevation: 0.0,
//           // centerTitle: true,
//         ),
//         body: Column(
//             children: <Widget>[
//               Expanded(
//                 flex: 3,
//                 child: CustomScrollView(
// //                  controller: _scrollController,
//                   shrinkWrap: true,
//
//                   slivers: <Widget>[
//                     SliverToBoxAdapter( /// Search bar code start
//                       child: Padding(
//                         padding: const EdgeInsets.only(left:18.0,right: 18.0),
//                         child: SizedBox(
//                           height: 50.0,
//                           child: Container(
//                             child: TextField(
//                               onChanged: (str){
//                                 setState(() {
//                                   users.clear();
//
//                                 });
//                                 if(str.length>2){
//                                   isLoading = false;
//                                   print(str);
//                                   categoryID=null;
//                                   //_getMoreData(1, str);   ////Uncomment for More data
//                                 }else if(str.length==0){
//                                   setState(() {
//                                     users.clear();
//
//                                   });
//                                   // _getMoreData(1, ''); ///Uncomment for More data
//                                 }
//                               },
//                               decoration: InputDecoration(
//                                 //border:  InputBorder.none,
//                                   border:  InputBorder.none,
//                                   hintText: 'Search food you like',
//                                   icon: Icon(Icons.search)
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ), /// Search bar code End
//                     SliverToBoxAdapter(
//                         child: Divider(
//                           height: 1.0, color: Colors.grey[500],
//                           indent: 10.0,endIndent: 10.0,)),
//                     SliverToBoxAdapter(/// Category code start
//                       child: SizedBox(
//                         height: 100.0,
//                         width: 100,
//                         child: Container(
//                           child: categoryListView(),
//                         ),
//                       ),
//                     ),/// Category code End
//                     SliverToBoxAdapter(
//                         child: Divider(
//                           height: 2.0, color: Colors.grey[500],
//                           indent: 10.0,endIndent: 10.0,thickness: 1.0,)),
//                     SliverToBoxAdapter(child: productGridView())
// //                   SliverToBoxAdapter(/// ListView code Start
// //                     child: SizedBox(
// //                       //height: Platform.isIOS ? 580.0 : 450.0,
// //                       height: MediaQuery.of(context).size.height / 1.4,
// //                       child: (filterName.length == 0 && isLoading == false)
// //                           ? Center(child: Text('No Items Found'))
// //                           : RefreshIndicator(
// //                         onRefresh:_getData,
// //                         child: ListView.builder(
// //                           padding: EdgeInsets.only(bottom: 80), // if you have non-mini FAB else use 40
// //
// //
// //                           itemCount: filterName.length + 1,
// //                           //physics: const AlwaysScrollableScrollPhysics(),
// //                           itemBuilder: (BuildContext context, int index) {
// //                             if (!(_searchText.isEmpty)) {
// //                               List tempList = new List();
// //                               for (int i = 0;
// //                               i < filterName.length;
// //                               i++) {
// //                                 if (filterName[i]['meta_title']
// //                                     .toLowerCase()
// //                                     .contains(
// //                                     _searchText.toLowerCase())) {
// //                                   tempList.add(filterName[i]);
// //                                 }
// //                               }
// //                               filterName = tempList;
// //                               //final pId = filterName[index]['id'];
// //                             }
// //                             if (index == filterName.length) {
// //                               return Container(
// //
// //                                   child: Center(
// //                                       child: Container(
// //                                         child: _buildProgressIndicator(),
// //                                       )));
// //                             } else {
// //                               return /*isLoading
// //                                 ? Center(child: _buildProgressIndicator())
// //                                 : */
// //
// //                                 Column(
// //                                   children: <Widget>[
// //                                     Row(
// //                                       crossAxisAlignment: CrossAxisAlignment.start,
// //                                       mainAxisAlignment: MainAxisAlignment.start,
// //                                       children: <Widget>[
// //                                         Padding(
// //                                           padding: const EdgeInsets.all(8.0),
// //                                           child: ClipRRect(
// //                                             borderRadius: BorderRadius.circular(UIsizes.INPUT_BUTTON_BORDER_RADIUS),
// //
// //                                             child: Container(
// //                                               width: 80.0,
// //                                               height:90.0,
// //                                               child:  filterName[index]["image"]
// //                                                   .length != 0
// //                                                   ? CachedNetworkImage(
// //                                                 imageUrl: filterName[index]
// //                                                 ["image"][0] !=
// //                                                     []
// //                                                     ? '${APIConstants.API_BASE_URL_DEV}/${filterName[index]["image"][0]['src']}'
// //                                                     : Image.asset(
// //                                                     'images/foodItem.jpeg'),
// //                                                 fit: BoxFit.cover,
// //                                                 placeholder: (context, url) =>
// //                                                     Image.asset(
// //                                                       'images/foodItem.jpeg',
// //                                                       fit: BoxFit.cover,
// //                                                     ),
// //                                                 errorWidget:
// //                                                     (context, url, error) =>
// //                                                     Image.asset(
// //                                                       'images/foodItem.jpeg',
// //                                                       fit: BoxFit.cover,
// //                                                     ), //new Icon(Icons.error),
// //                                               )
// //                                                   : Image.asset(
// //                                                 'images/foodItem.jpeg',
// //                                                 fit: BoxFit.cover,
// //                                               ),
// //                                               decoration: BoxDecoration(
// //                                                 image: DecorationImage(
// //                                                     image: filterName[index]["image"].length != 0? NetworkImage('${APIConstants.API_BASE_URL_DEV}/${filterName[index]["image"][0]['src']}') :
// //                                                     AssetImage(
// //                                                       'images/foodItem.jpeg',
// //                                                       // fit: BoxFit.cover,
// //                                                     ),
// // //,
// //                                                     fit: BoxFit.cover
// //                                                 ),
// //                                                 borderRadius: BorderRadius.all(Radius.circular(20.0)),
// //                                               ),
// //
// //                                             ),
// //                                           ),
// //                                         ),
// //                                         Container(
// //                                           //  width: 210.0,
// //                                           child: Row(
// //                                             children: <Widget>[
// //                                               Padding(
// //                                                   padding:  EdgeInsets.only(top:12.0,left:10.0),
// //                                                   child: Column(
// //                                                     crossAxisAlignment: CrossAxisAlignment.start,
// //                                                     mainAxisAlignment: MainAxisAlignment.start,
// //                                                     children: <Widget>[
// //                                                       SizedBox(child: Text(filterName[index]["info"][0]['name'] != null ?  filterName[index]["info"][0]['name'].length >25? filterName[index]["info"][0]['name'].substring(0,25) :filterName[index]["info"][0]['name']     : 'No Name', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15.0),overflow: TextOverflow.ellipsis,)),
// //                                                       SizedBox(height: 5.0,),
// //                                                       Container(
// //                                                           constraints: new BoxConstraints(
// //                                                               maxWidth: MediaQuery.of(context).size.width/1.7),
// //                                                           child: Text(filterName[index]["info"][0]['name'] != null ? filterName[index]["info"][0]['description']: 'No Name', style: TextStyle(fontSize: 12.0),softWrap: true)),
// //
// //
// //                                                     ],
// //                                                   )
// //                                               ),
// //                                             ],
// //                                           ),
// //                                         ),
// //
// // //
// //                                         Expanded(
// //                                           child: Padding(
// //                                             padding: const EdgeInsets.fromLTRB(0.0,5.0,15.0,0.0),
// //                                             child: Column(
// //                                               crossAxisAlignment: CrossAxisAlignment.end,
// //                                               mainAxisAlignment: MainAxisAlignment.start,
// //                                               children: <Widget>[
// //                                                 favButton(index),
// //                                                 SizedBox(height: 5.0,),
// //
// //
// //                                                 SizedBox(height: 5.0,),
// //
// //                                               ],
// //                                             ),
// //                                           ),
// //                                         )
// //
// //
// //                                       ],
// //                                     ),
// //                                     Row(
// //                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                                       crossAxisAlignment :CrossAxisAlignment.center,
// //                                       children: <Widget>[
// //                                         Padding(
// //                                           padding: const EdgeInsets.only(left:15.0),
// //                                           child:_isLoggedIn? Text('QR ${filterName[index]["branch"]['price'][0]['price']}' ,style: TextStyle(fontWeight: FontWeight.bold, fontSize :18.0, color: Theme.of(context).primaryColor),) :
// //                                           Text('QR ${filterName[index]["branches"][0]['price'][0]['price']}' ,style: TextStyle(fontWeight: FontWeight.bold, fontSize :18.0, color: Theme.of(context).primaryColor),) ,
// //                                         ),
// //                                         Padding(
// //                                           padding: const EdgeInsets.all(4.0),
// //                                           child: Align(
// //                                             alignment: Alignment.centerRight,
// //                                             child: SizedBox(
// //                                               width: 150.0,
// //                                               child:_isLoggedIn? filterName[index][ "branch"]["status"] == 0?
// //                                               Chip(backgroundColor:Colors.grey[100], label:Text("NOT AVAILABLE",style: TextStyle(color: Colors.red,fontWeight: FontWeight.w700)), ) :
// //                                               OutlineButton(
// //                                                 // color: Colors.white,
// //                                                   highlightColor: Theme.of(context).primaryColor,
// //                                                   highlightedBorderColor: Theme.of(context).primaryColor,
// //                                                   highlightElevation: 4.0,
// //
// //                                                   shape:RoundedRectangleBorder(borderRadius: new BorderRadius.circular(UIsizes.INPUT_BUTTON_BORDER_RADIUS)),
// //
// //                                                   color: Theme.of(context).primaryColor,
// //                                                   borderSide: BorderSide(color: Theme.of(context).primaryColor),
// //                                                   child:  showCounter(filterName[index]['size_type'],filterName[index]['cart']) ?  counterContainer(singleItemAddID,filterName[index]['cart'],index) :filterName[index]['size_type']=="single"? Text('ADD',): Text("SELECT"),
// //                                                   onPressed: (){
// //                                                     if(!showCounter(filterName[index]['size_type'],filterName[index]['cart'])) {
// //                                                       var defaultQuantity = 1;
// //                                                       if (_isLoggedIn ==
// //                                                           true) {
// //                                                         print(
// //                                                             'User is Locked In!');
// //                                                         if (filterName[index]['size_type'] ==
// //                                                             'many') {
// //                                                           setState(() {
// //                                                             isAdded =
// //                                                             false;
// //                                                             filterName[index]['size_type'] ==
// //                                                                 'single';
// //                                                           });
// //                                                           //isAdded = false;
// //                                                           print(
// //                                                               'Mutliple -${filterName[index]['id']}');
// //                                                           print(
// //                                                               'Multiple size Founded here!');
// //                                                           print(
// //                                                               'Multiple Id - ${filterName[index]['size_type']}');
// //                                                           print(
// //                                                               'Many size Founded here!');
// //                                                           List<
// //                                                               String> sizeData = new List();
// //                                                           List<
// //                                                               Map> prices = new List();
// //                                                           print(
// //                                                               "resssss - ${filterName[index]['branch']['price']}");
// //                                                           for (int i = 0; i <
// //                                                               filterName[index]['branch']['price']
// //                                                                   .length; i++) {
// //                                                             sizeData
// //                                                                 .add(
// //                                                                 "${ filterName[index]['branch']['price'][i]["tag"]} - ${filterName[index]['branch']['price'][i]['price']} QAR,"); //tttt
// //
// //                                                             prices.add({
// //                                                               "price": filterName[index]['branch']['price'][i]['price'],
// //                                                               "id": filterName[index]['branch']['price'][i]["id"]
// //                                                             });
// //
// //                                                             ///------------------------------------------->>>>>>>
// //                                                             print(
// //                                                                 "Size List is ${sizeData[i]}");
// //                                                           }
// //                                                           setState(() {
// //                                                             //filterName[index]['size_type'] == 'many';
// //                                                             //isAdded = false;
// //                                                             sizes =
// //                                                                 sizeData;
// //                                                             pricesId =
// //                                                                 prices;
// //                                                           });
// //                                                           _addToCartBottomSheet(
// //                                                               context,
// //                                                               filterName[index]['id'],
// //                                                               index,
// //                                                               prices);
// //                                                           print(
// //                                                               "askfjaskdfaksdjfa - $sizes");
// //                                                         }
// //                                                         else {
// //                                                           setState(() {
// //                                                             selectedProductIndex =
// //                                                                 index;
// //                                                             isAdded =
// //                                                             true;
// //                                                             updateQuantity =
// //                                                             1;
// //                                                             //print('single size Founded here!');
// //                                                             print(
// //                                                                 'Single Id - ${filterName[index]['size_type']}');
// //                                                             print(
// //                                                                 'Single Id - ${filterName[index]['id']}');
// //                                                             //bloc.addToCart(index);
// //                                                             _postAddToCartData(
// //                                                                 filterName[index]['id'],
// //                                                                 filterName[index]['branch']['price'][0]["id"],
// //                                                                 defaultQuantity,
// //                                                                 index);
// //
// //                                                             ///UNCOMMENT IT
// //                                                           });
// //                                                         }
// //                                                       } else {
// //                                                         print(
// //                                                             "Your are Not Logged In to add this item to cart ");
// //                                                         _guestAlertForAddtoCart();
// //                                                       }
// //                                                     }
// //                                                   }
// //                                               ):OutlineButton(child: Text("ADD"),
// //                                                 shape:RoundedRectangleBorder(borderRadius: new BorderRadius.circular(UIsizes.INPUT_BUTTON_BORDER_RADIUS)),
// //                                                 color: Theme.of(context).primaryColor,
// //                                                 onPressed: (){
// //                                                   Navigator.pushReplacement(
// //                                                     context,
// //                                                     MaterialPageRoute(builder: (context) => LoginPage()),
// //                                                   );
// //                                                 },
// //                                               ),
// //                                             ),
// //                                           ),
// //                                         ),
// //
// //
// //                                       ],
// //                                     ),
// //
// //
// //                                   ],
// //                                 );
// //
// //
// //
// //
// //                             } //return MovieListTile(data: data[index]);
// //                           },
// //                           controller: _scrollController,
// //                         ),
// //                       ),
// //                     ),
// //                   ),/// ListView code End
//
//                   ],
//                 ),
//               ),
//
//             ])
//     );
//   }
//
//
//   /// Category List Code Start here
//   Widget categoryListView(){
//     return Padding(
//       padding: const EdgeInsets.all(6.0),
//       child: Container(
//           height: 100.0,
//           width: 100.0,
//           decoration: BoxDecoration(
//             //shape: BoxShape.circle
//             //color: Colors.grey,
//             //borderRadius: BorderRadius.all(Radius.circular(30.0))
//             //borderRadius: BorderRadius.circular(10.0),
//           ),
//           child:categoryList.length != []?ListView.builder(
//             scrollDirection: Axis.horizontal,
//             itemCount: categoryList.length,
//             itemBuilder: (BuildContext context, int index) {
//               if(categoryList.length == 0){
//                 Center(child: Text('No Items Found'),);
//               }
//               return InkWell(
//                 //borderRadius: BorderRadius.circular(50.0),
//                 onTap: (){
//                   users.clear();
//                   page=1;
//                   if(activeindex == index) {
//                     setState(() {
//                       activeindex = null;
//                       categoryID = null;
//                     });
//                     //_getMoreData(page , ""); ///Uncomment for More data
//
//                   }
//                   else{
//                     setState(() {
//                       activeindex = index;
//                       categoryID = categoryList[index]["DepartmentId"];
//                     });
//                     // _getMoreData(page , ""); ////Uncomment for More data
//                   }
//                 },
//                 child: Card(
//                     elevation: 0,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(50.0),
//                     ),
//                     color: activeindex ==index ? Theme.of(context).primaryColor : Theme.of(context).primaryColor,
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
//                       child: Center(
//                         child: activeindex ==index ? Row(
//                           children: <Widget>[
//                             Column(
//                               children: [
//                                 Expanded(
//                                   child: Container(
//                                     padding: EdgeInsets.all(10.0),
//                                     // For  demo we use fixed height  and width
//                                     // Now we dont need them
//                                     height: 80,
//                                     width: 80,
//                                     // decoration: BoxDecoration(
//                                     //   //color: product.color,
//                                     //   borderRadius: BorderRadius.all(Radius.circular(50.0)),
//                                     // ),
//                                     child: Hero(
//                                       tag: "'${categoryList[index]["Id"]}'",
//                                       child: ClipRRect(
//                                           borderRadius: BorderRadius.vertical(top: Radius.circular(20.0),/*bottom: Radius.circular(25.0),*/),
//                                           child: Image.network('${categoryList[index]["Photo"]}')),
//                                     ),
//                                   ),
//                                 ),
//                                 Text('${categoryList[index]["NameEn"]}',
//                                     style: TextStyle( fontSize: 16.0, color: activeindex ==index ? Colors.white : Colors.white)
//                                 ),
//                               ],
//                             ),
//                             SizedBox(width: 9),
//                             Container(child: Icon(Icons.cancel,color: Colors.white,size: 22.0, ),) //color: Colors.white,
//                           ],
//                         )
//                             :
//                         Column(
//                           children: [
//                             Expanded(
//                               child: Container(
//                                 padding: EdgeInsets.all(1.0),
//                                 // For  demo we use fixed height  and width
//                                 // Now we dont need them
//                                 height: 60,
//                                 width: 60,
//                                 // decoration: BoxDecoration(
//                                 //   //color: product.color,
//                                 //   borderRadius: BorderRadius.all(Radius.circular(50.0)),
//                                 // ),
//                                 child: Hero(
//                                   tag: "'${categoryList[index]["Id"]}'",
//                                   child: ClipRRect(
//                                       borderRadius: BorderRadius.vertical(top: Radius.circular(30.0),bottom: Radius.circular(30.0),),
//                                       child: Image.network('${categoryList[index]["Photo"]}')),
//                                 ),
//                               ),
//                             ),
//                             Text('${categoryList[index]["NameEn"]}',
//                                 style: TextStyle( fontSize: 16.0, color: activeindex ==index ? Colors.white : Colors.white)
//                             ),
//                           ],
//                         ),
//
//                       ),
//                     )
//                   //catName: items[index].catName
//                   //imagePath: _categories[index].imagePath,
//                   //numberOfItems: _categories[index].numberOfItems,
//                 ),
//               );
//             },
//           ): Center(child: Text('No Items Found'),)
//       ),
//     );
//   }
//
//
//   ///
//
//   Widget productGridView(){
//     return GridView.builder(
//         shrinkWrap: true,
//         physics: ClampingScrollPhysics(),
//         itemCount: filterName.length,
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           mainAxisSpacing: 5.0,
//           crossAxisSpacing: 2.0,
//           childAspectRatio: 0.90,
//         ),
//         itemBuilder: (context, index) => ProductItems(
//           image: filterName[index]['Photo'],
//           title: filterName[index]['NameEn'],
//           price: filterName[index]['Price'],
//           Id: filterName[index]['Id'],
//           press: () => Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) =>
//                     DetailsScreen(filterName:filterName[index]),
//               )),
//         ));
//   }
//
// }


class _SubCategoryScreenState extends State<SubCategoryScreen> {
  final id;
  List categoryList = new List();
  List categoryData = new List();


  bool _isBottomBarVisible;

//  _HomePageState(this._isBottomBarVisible);
  bool _isLoggedIn = false;
  bool isLoading = false;
  bool isOffline = false;
  String sizeType;
  String singleSizeType;
  List<bool> listCheck = [];
  double totalAmount = 0.0;
  var selectedPrice;
  var selectedBrId;
  var selectedId;
  var selectedProductIndex;
  int totalCount = 0;
  String branchName;
  String name;
  String username;
  int categoryID;
  //var category = new List();
  int activeindex;

  final ScrollController _scrollController = new ScrollController();
  String title, imageUrl;
  int productId, userId;
  String price;
  bool isFavorite = false;
  bool isAdded = false;
  String baseURL = "http://tastytea.tas-taz.com/api/product/";
  int page = 1;
  int last_page=0;
  List users = new List();
  final dio = new Dio();
  final TextEditingController _filter = new TextEditingController();
  String _searchText = "";
  List filterName = new List();
  Icon _searchIcon = new Icon(Icons.search, color: Color(0xFF34C47C));
  Icon _backToLogin = new Icon(Icons.arrow_back_ios, color: Colors.white);
  Widget _appBarTitle = new Text('Tasty Tea');
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List sizes = new List();
  List pricesId = new List();
  var singleItemAddID;

  _SubCategoryScreenState(this.id);

  @override
  void initState() {
    users.clear();
    networkChecked();
    //this._getMoreData(1,'');  ////Uncomment for More data
    _checkIfLoggedIn();
    _getCat();
    _getCatProduct();

//    totalQuantity();
//    _quantityCount;
    super.initState();
    //_getCartItemCount();
    //_getMoreData(page);

    _isBottomBarVisible = true;
    // _scrollController = ScrollController();
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

  networkChecked() async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.mobile) {
      return 'No Network Connection! Connected to Mobile Network';
      print("Connected to Mobile Network");
    } else if (connectivityResult == ConnectivityResult.wifi) {
      print("Connected to WiFi");
      return 'No WiFi Connection! Please Connected to WiFi';
    } else {
      isOffline = false;
      showNoNetworkAlertDialog(context);
      print("Unable to connect. Please Check Internet Connection");
    }
  }

  Future<void> showNoNetworkAlertDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Connection Alert!'),
          content: Text('Unable to connect. Please Check Internet Connection'),
          actions: <Widget>[
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


  Future<dynamic>_getCat() async{
    // SharedPreferences saveBranchID = await SharedPreferences.getInstance();
    // var branchId = saveBranchID.getString('branchId');
    setState(() {
      isLoading = true;
    });
    //SharedPreferences localStorage = await SharedPreferences.getInstance();
    //var token = localStorage.getString('token');
    var url = APIConstants.API_BASE_URL_DEV + "/subcategories?CategoryId=${id}";
    print("Cat Url is --->> $url");
    Map<String, String> requestHeaders = {
      //'Accept': 'application/json',
      'x-api-key': '987654',
    };
    final response = await http.get(url, headers: requestHeaders);
    final catData = json.decode(response.body);
    print("Category data- $catData");
    final catsData = catData['Data'];
    //print("All category data ===========->>> $deptData");
    List dataCats = new List();
    var dataLength = catsData.length;
    for (int i = 0; i < dataLength; i++) {
      dataCats.add(catsData[i]);
    }
    setState(() {
      categoryData.addAll(dataCats);
      categoryList = categoryData;
      //_getTotal(cartData);
      isLoading = false;
    });

    if (categoryList == null) {
      return;
    }
  }
  //
  // Future getCategory() {
  //   var url = APIConstants.API_BASE_URL_DEV + "/categories?DepartmentId=$id";
  //   return http.get(url);
  // }
  // _getCat() {
  //   API.getCategory().then((response) {
  //     if(!mounted)return;
  //     setState(() {
  //       categoryList = json.decode(response.body);
  //       // category = list.map((model) => Category.fromJson(model)).toList();
  //
  //     });
  //   });
  // }

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


  Future<dynamic>_getCatProduct() async{
    // SharedPreferences saveBranchID = await SharedPreferences.getInstance();
    // var branchId = saveBranchID.getString('branchId');
    setState(() {
      isLoading = true;
    });
    //SharedPreferences localStorage = await SharedPreferences.getInstance();
    //var token = localStorage.getString('token');
    var url = APIConstants.API_BASE_URL_DEV + "/productsByCategory?CategoryId=${id}";
    print("Cat Url is --->> $url");
    Map<String, String> requestHeaders = {
      //'Accept': 'application/json',
      'x-api-key': '987654',
    };
    final response = await http.get(url, headers: requestHeaders);
    final catData = json.decode(response.body);
    print("All Product data- $catData");
    final catProductData = catData['Data'];
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
      isLoading = false;
      users.addAll(dataRes);
      //last_page = response.data["last_page"];
      filterName = users;
    });

    if (categoryList == null) {
      return;
    }
  }


//   void _getMoreData(int index,searchItem) async {
//     //print("cateid isss $categoryID");
//
//     String categoryCheck;
//     String branchCheck;
//     if(categoryID ==null){
//       categoryCheck = "&category_id=";
//     }else{
//       categoryCheck = "&category_id=${categoryID.toString()}";
//     }
//
//
//     SharedPreferences localStorage = await SharedPreferences.getInstance();
//     var selectedBranchId = localStorage.getString('branchId');
//     //branchName =localStorage.getString('branch');
//     var token = localStorage.getString('token');
//
//     if(selectedBranchId ==null){
//       branchCheck = "branch_id=";
//     }
//     else{
//       branchCheck = "branch_id=${selectedBranchId.toString()}";
//     }
//
//     if (!isLoading) {
//       setState(() {
//         isLoading = true;
//       });
//
//
//       var urlGuest =
//           "${APIConstants.API_BASE_URL_DEV}/api/product/?$branchCheck&page=${index.toString()}&search=$searchItem"+categoryCheck ;
//
//       var url =
//           "${APIConstants.API_BASE_URL_DEV}/api/auth/product?$branchCheck&page=${index.toString()}&search=$searchItem"+categoryCheck;
//       print(_isLoggedIn);
//       Dio dio = new Dio();
//       dio.options.headers = {'x-api-key': '987654',};
//
//       final response = await dio.get(token !=null ? url : urlGuest);
//       List dataRes = new List();
//       var dataLength=response.data['data'].length;
//       for (int i = 0; i <  dataLength; i++) {
//         dataRes.add(response.data['data'][i]);
//       }
//
//
//       //  var res = response.data['data'];
//       // var pId = res[index]['id'];
//       //  var allPriceTage = dataRes[index]["branches"][0]['price'][0];
//
// //      String sizeTypes = res[index]['size_type'];
// //      String oneSizeTypes = res[index]['size_type'];
//       if (!mounted) return;
//       //SharedPreferences name = await SharedPreferences.getInstunce();
//       // username= name.getString('name');
//       setState(() {
//         isLoading = false;
//         //isAdded = false;
//         users.addAll(dataRes);
//         last_page = response.data["last_page"];
//         filterName = users;
//         print("result iss ${filterName[0]["cart"]}");
// //        print("lnt iss ${filterName.length}");
//
//
// //if(page ==1){
// //  page++;
// //}
//         print("page number $page");
//         if( _isLoggedIn) {
//           //saveFcmToken();
//           //_getCartItemCount();
//
//         }
//       });
//     }
//   }

  // Future<void> _getData() async  {
  //   setState(() {
  //     _getMoreData(1, "");
  //   });
  // }


  //_CategoryScreenState(this.id);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).accentColor,
        appBar: AppBar(
          elevation: 0.0,
          // leading: new IconButton(
          //     icon: Platform.isIOS ? new Icon(Icons.arrow_back_ios) : new Icon(Icons.arrow_back),
          //     onPressed: (){
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(builder: (context) => MainScreen(0)),
          //       );
          //     }
          // ),
          title: Text(
            "SubCategory",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor:Theme.of(context).primaryColor,
          //elevation: 0.0,
          // centerTitle: true,
        ),
        body: Column(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: CustomScrollView(
//                  controller: _scrollController,
                  shrinkWrap: true,

                  slivers: <Widget>[
                    SliverToBoxAdapter( /// Search bar code start
                      child: Padding(
                        padding: const EdgeInsets.only(left:18.0,right: 18.0),
                        child: SizedBox(
                          height: 50.0,
                          child: Container(
                            child: TextField(
                              onChanged: (str){
                                setState(() {
                                  users.clear();

                                });
                                if(str.length>2){
                                  isLoading = false;
                                  print(str);
                                  categoryID=null;
                                  //_getMoreData(1, str);   ////Uncomment for More data
                                }else if(str.length==0){
                                  setState(() {
                                    users.clear();

                                  });
                                  // _getMoreData(1, ''); ///Uncomment for More data
                                }
                              },
                              decoration: InputDecoration(
                                //border:  InputBorder.none,
                                  border:  InputBorder.none,
                                  hintText: 'Search Your Items',
                                  icon: Icon(Icons.search)
                              ),
                            ),
                          ),
                        ),
                      ),
                    ), /// Search bar code End
                    SliverToBoxAdapter(
                        child: Divider(
                          height: 1.0, color: Colors.grey[500],
                          indent: 10.0,endIndent: 10.0,)),
                    categoryList == [] ? Text("No Sub Category"): SliverToBoxAdapter(/// Category code start
                      child: SizedBox(
                        height: 120.0,
                        width: 120.0,
                        child: Container(
                          child: categoryListView(),
                        ),
                      ),
                    ),/// Category code End
                    SliverToBoxAdapter(
                        child: Divider(
                          height: 2.0, color: Colors.grey[500],
                          indent: 10.0,endIndent: 10.0,thickness: 1.0,)),
                    SliverToBoxAdapter(child: productGridView())
//                   SliverToBoxAdapter(/// ListView code Start
//                     child: SizedBox(
//                       //height: Platform.isIOS ? 580.0 : 450.0,
//                       height: MediaQuery.of(context).size.height / 1.4,
//                       child: (filterName.length == 0 && isLoading == false)
//                           ? Center(child: Text('No Items Found'))
//                           : RefreshIndicator(
//                         onRefresh:_getData,
//                         child: ListView.builder(
//                           padding: EdgeInsets.only(bottom: 80), // if you have non-mini FAB else use 40
//
//
//                           itemCount: filterName.length + 1,
//                           //physics: const AlwaysScrollableScrollPhysics(),
//                           itemBuilder: (BuildContext context, int index) {
//                             if (!(_searchText.isEmpty)) {
//                               List tempList = new List();
//                               for (int i = 0;
//                               i < filterName.length;
//                               i++) {
//                                 if (filterName[i]['meta_title']
//                                     .toLowerCase()
//                                     .contains(
//                                     _searchText.toLowerCase())) {
//                                   tempList.add(filterName[i]);
//                                 }
//                               }
//                               filterName = tempList;
//                               //final pId = filterName[index]['id'];
//                             }
//                             if (index == filterName.length) {
//                               return Container(
//
//                                   child: Center(
//                                       child: Container(
//                                         child: _buildProgressIndicator(),
//                                       )));
//                             } else {
//                               return /*isLoading
//                                 ? Center(child: _buildProgressIndicator())
//                                 : */
//
//                                 Column(
//                                   children: <Widget>[
//                                     Row(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       mainAxisAlignment: MainAxisAlignment.start,
//                                       children: <Widget>[
//                                         Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: ClipRRect(
//                                             borderRadius: BorderRadius.circular(UIsizes.INPUT_BUTTON_BORDER_RADIUS),
//
//                                             child: Container(
//                                               width: 80.0,
//                                               height:90.0,
//                                               child:  filterName[index]["image"]
//                                                   .length != 0
//                                                   ? CachedNetworkImage(
//                                                 imageUrl: filterName[index]
//                                                 ["image"][0] !=
//                                                     []
//                                                     ? '${APIConstants.API_BASE_URL_DEV}/${filterName[index]["image"][0]['src']}'
//                                                     : Image.asset(
//                                                     'images/foodItem.jpeg'),
//                                                 fit: BoxFit.cover,
//                                                 placeholder: (context, url) =>
//                                                     Image.asset(
//                                                       'images/foodItem.jpeg',
//                                                       fit: BoxFit.cover,
//                                                     ),
//                                                 errorWidget:
//                                                     (context, url, error) =>
//                                                     Image.asset(
//                                                       'images/foodItem.jpeg',
//                                                       fit: BoxFit.cover,
//                                                     ), //new Icon(Icons.error),
//                                               )
//                                                   : Image.asset(
//                                                 'images/foodItem.jpeg',
//                                                 fit: BoxFit.cover,
//                                               ),
//                                               decoration: BoxDecoration(
//                                                 image: DecorationImage(
//                                                     image: filterName[index]["image"].length != 0? NetworkImage('${APIConstants.API_BASE_URL_DEV}/${filterName[index]["image"][0]['src']}') :
//                                                     AssetImage(
//                                                       'images/foodItem.jpeg',
//                                                       // fit: BoxFit.cover,
//                                                     ),
// //,
//                                                     fit: BoxFit.cover
//                                                 ),
//                                                 borderRadius: BorderRadius.all(Radius.circular(20.0)),
//                                               ),
//
//                                             ),
//                                           ),
//                                         ),
//                                         Container(
//                                           //  width: 210.0,
//                                           child: Row(
//                                             children: <Widget>[
//                                               Padding(
//                                                   padding:  EdgeInsets.only(top:12.0,left:10.0),
//                                                   child: Column(
//                                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                                     mainAxisAlignment: MainAxisAlignment.start,
//                                                     children: <Widget>[
//                                                       SizedBox(child: Text(filterName[index]["info"][0]['name'] != null ?  filterName[index]["info"][0]['name'].length >25? filterName[index]["info"][0]['name'].substring(0,25) :filterName[index]["info"][0]['name']     : 'No Name', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15.0),overflow: TextOverflow.ellipsis,)),
//                                                       SizedBox(height: 5.0,),
//                                                       Container(
//                                                           constraints: new BoxConstraints(
//                                                               maxWidth: MediaQuery.of(context).size.width/1.7),
//                                                           child: Text(filterName[index]["info"][0]['name'] != null ? filterName[index]["info"][0]['description']: 'No Name', style: TextStyle(fontSize: 12.0),softWrap: true)),
//
//
//                                                     ],
//                                                   )
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//
// //
//                                         Expanded(
//                                           child: Padding(
//                                             padding: const EdgeInsets.fromLTRB(0.0,5.0,15.0,0.0),
//                                             child: Column(
//                                               crossAxisAlignment: CrossAxisAlignment.end,
//                                               mainAxisAlignment: MainAxisAlignment.start,
//                                               children: <Widget>[
//                                                 favButton(index),
//                                                 SizedBox(height: 5.0,),
//
//
//                                                 SizedBox(height: 5.0,),
//
//                                               ],
//                                             ),
//                                           ),
//                                         )
//
//
//                                       ],
//                                     ),
//                                     Row(
//                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                       crossAxisAlignment :CrossAxisAlignment.center,
//                                       children: <Widget>[
//                                         Padding(
//                                           padding: const EdgeInsets.only(left:15.0),
//                                           child:_isLoggedIn? Text('QR ${filterName[index]["branch"]['price'][0]['price']}' ,style: TextStyle(fontWeight: FontWeight.bold, fontSize :18.0, color: Theme.of(context).primaryColor),) :
//                                           Text('QR ${filterName[index]["branches"][0]['price'][0]['price']}' ,style: TextStyle(fontWeight: FontWeight.bold, fontSize :18.0, color: Theme.of(context).primaryColor),) ,
//                                         ),
//                                         Padding(
//                                           padding: const EdgeInsets.all(4.0),
//                                           child: Align(
//                                             alignment: Alignment.centerRight,
//                                             child: SizedBox(
//                                               width: 150.0,
//                                               child:_isLoggedIn? filterName[index][ "branch"]["status"] == 0?
//                                               Chip(backgroundColor:Colors.grey[100], label:Text("NOT AVAILABLE",style: TextStyle(color: Colors.red,fontWeight: FontWeight.w700)), ) :
//                                               OutlineButton(
//                                                 // color: Colors.white,
//                                                   highlightColor: Theme.of(context).primaryColor,
//                                                   highlightedBorderColor: Theme.of(context).primaryColor,
//                                                   highlightElevation: 4.0,
//
//                                                   shape:RoundedRectangleBorder(borderRadius: new BorderRadius.circular(UIsizes.INPUT_BUTTON_BORDER_RADIUS)),
//
//                                                   color: Theme.of(context).primaryColor,
//                                                   borderSide: BorderSide(color: Theme.of(context).primaryColor),
//                                                   child:  showCounter(filterName[index]['size_type'],filterName[index]['cart']) ?  counterContainer(singleItemAddID,filterName[index]['cart'],index) :filterName[index]['size_type']=="single"? Text('ADD',): Text("SELECT"),
//                                                   onPressed: (){
//                                                     if(!showCounter(filterName[index]['size_type'],filterName[index]['cart'])) {
//                                                       var defaultQuantity = 1;
//                                                       if (_isLoggedIn ==
//                                                           true) {
//                                                         print(
//                                                             'User is Locked In!');
//                                                         if (filterName[index]['size_type'] ==
//                                                             'many') {
//                                                           setState(() {
//                                                             isAdded =
//                                                             false;
//                                                             filterName[index]['size_type'] ==
//                                                                 'single';
//                                                           });
//                                                           //isAdded = false;
//                                                           print(
//                                                               'Mutliple -${filterName[index]['id']}');
//                                                           print(
//                                                               'Multiple size Founded here!');
//                                                           print(
//                                                               'Multiple Id - ${filterName[index]['size_type']}');
//                                                           print(
//                                                               'Many size Founded here!');
//                                                           List<
//                                                               String> sizeData = new List();
//                                                           List<
//                                                               Map> prices = new List();
//                                                           print(
//                                                               "resssss - ${filterName[index]['branch']['price']}");
//                                                           for (int i = 0; i <
//                                                               filterName[index]['branch']['price']
//                                                                   .length; i++) {
//                                                             sizeData
//                                                                 .add(
//                                                                 "${ filterName[index]['branch']['price'][i]["tag"]} - ${filterName[index]['branch']['price'][i]['price']} QAR,"); //tttt
//
//                                                             prices.add({
//                                                               "price": filterName[index]['branch']['price'][i]['price'],
//                                                               "id": filterName[index]['branch']['price'][i]["id"]
//                                                             });
//
//                                                             ///------------------------------------------->>>>>>>
//                                                             print(
//                                                                 "Size List is ${sizeData[i]}");
//                                                           }
//                                                           setState(() {
//                                                             //filterName[index]['size_type'] == 'many';
//                                                             //isAdded = false;
//                                                             sizes =
//                                                                 sizeData;
//                                                             pricesId =
//                                                                 prices;
//                                                           });
//                                                           _addToCartBottomSheet(
//                                                               context,
//                                                               filterName[index]['id'],
//                                                               index,
//                                                               prices);
//                                                           print(
//                                                               "askfjaskdfaksdjfa - $sizes");
//                                                         }
//                                                         else {
//                                                           setState(() {
//                                                             selectedProductIndex =
//                                                                 index;
//                                                             isAdded =
//                                                             true;
//                                                             updateQuantity =
//                                                             1;
//                                                             //print('single size Founded here!');
//                                                             print(
//                                                                 'Single Id - ${filterName[index]['size_type']}');
//                                                             print(
//                                                                 'Single Id - ${filterName[index]['id']}');
//                                                             //bloc.addToCart(index);
//                                                             _postAddToCartData(
//                                                                 filterName[index]['id'],
//                                                                 filterName[index]['branch']['price'][0]["id"],
//                                                                 defaultQuantity,
//                                                                 index);
//
//                                                             ///UNCOMMENT IT
//                                                           });
//                                                         }
//                                                       } else {
//                                                         print(
//                                                             "Your are Not Logged In to add this item to cart ");
//                                                         _guestAlertForAddtoCart();
//                                                       }
//                                                     }
//                                                   }
//                                               ):OutlineButton(child: Text("ADD"),
//                                                 shape:RoundedRectangleBorder(borderRadius: new BorderRadius.circular(UIsizes.INPUT_BUTTON_BORDER_RADIUS)),
//                                                 color: Theme.of(context).primaryColor,
//                                                 onPressed: (){
//                                                   Navigator.pushReplacement(
//                                                     context,
//                                                     MaterialPageRoute(builder: (context) => LoginPage()),
//                                                   );
//                                                 },
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//
//
//                                       ],
//                                     ),
//
//
//                                   ],
//                                 );
//
//
//
//
//                             } //return MovieListTile(data: data[index]);
//                           },
//                           controller: _scrollController,
//                         ),
//                       ),
//                     ),
//                   ),/// ListView code End

                  ],
                ),
              ),

            ])
    );
  }


  /// Category List Code Start here
  Widget categoryListView(){
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 15, 15, 15),
      child: Container(
        height: 100.0,
        child: ListView.builder(
          itemCount: categoryList.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) => InkWell(
            onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SubCategoryScreen(id: categoryList[index]['Id']),
                  ));
            },
            child: Container(
              width: 100.0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ClipOval(
                    child: Container(
                      padding: const EdgeInsets.all(14.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,//Colors.grey[200],
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Theme.of(context).primaryColor,
                            blurRadius: 3.0,
                            spreadRadius: 2.0,
                          )
                        ],
                      ),
                      child: Image.network(
                        '${categoryList[index]["Photo"]}',
                        height: 45.0,
                        width: 45.0,
                        // fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Text(
                    categoryList[index]["NameEn"],
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(fontSize: 13.5),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
    // return Padding(
    //   padding: const EdgeInsets.all(6.0),
    //   child: Container(
    //       height: 100.0,
    //       width: 100.0,
    //       decoration: BoxDecoration(
    //         //shape: BoxShape.circle
    //         //color: Colors.grey,
    //         //borderRadius: BorderRadius.all(Radius.circular(30.0))
    //         //borderRadius: BorderRadius.circular(10.0),
    //       ),
    //       child:categoryList.length != []?ListView.builder(
    //         scrollDirection: Axis.horizontal,
    //         itemCount: categoryList.length,
    //         itemBuilder: (BuildContext context, int index) {
    //           if(categoryList.length == 0){
    //             Center(child: Text('No Items Found'),);
    //           }
    //           return InkWell(
    //             //borderRadius: BorderRadius.circular(50.0),
    //             onTap: (){
    //               Navigator.push(
    //                   context,
    //                   MaterialPageRoute(
    //                     builder: (context) =>
    //                         SubCategoryScreen(id: categoryList[index]['Id']),
    //                   ));
    //               users.clear();
    //               page=1;
    //               if(activeindex == index) {
    //                 setState(() {
    //                   activeindex = null;
    //                   categoryID = null;
    //                 });
    //                 //_getMoreData(page , ""); ///Uncomment for More data
    //
    //               }
    //               else{
    //                 setState(() {
    //                   activeindex = index;
    //                   categoryID = categoryList[index]["DepartmentId"];
    //                 });
    //                // _getMoreData(page , ""); ////Uncomment for More data
    //               }
    //             },
    //             child: Card(
    //                 elevation: 0,
    //                 shape: RoundedRectangleBorder(
    //                   borderRadius: BorderRadius.circular(50.0),
    //                 ),
    //                 color: activeindex ==index ? Theme.of(context).primaryColor : Theme.of(context).primaryColor,
    //                 child: Padding(
    //                   padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
    //                   child: Center(
    //                     child: activeindex ==index ? Row(
    //                       children: <Widget>[
    //                         Column(
    //                           children: [
    //                             Expanded(
    //                               child: Container(
    //                                 padding: EdgeInsets.all(10.0),
    //                                 // For  demo we use fixed height  and width
    //                                 // Now we dont need them
    //                                 height: 80,
    //                                 width: 80,
    //                                 // decoration: BoxDecoration(
    //                                 //   //color: product.color,
    //                                 //   borderRadius: BorderRadius.all(Radius.circular(50.0)),
    //                                 // ),
    //                                 child: Hero(
    //                                   tag: "'${categoryList[index]["Id"]}'",
    //                                   child: ClipRRect(
    //                                       borderRadius: BorderRadius.vertical(top: Radius.circular(20.0),/*bottom: Radius.circular(25.0),*/),
    //                                       child: Image.network('${categoryList[index]["Photo"]}')),
    //                                 ),
    //                               ),
    //                             ),
    //                             Text('${categoryList[index]["NameEn"]}',
    //                                 style: TextStyle( fontSize: 16.0, color: activeindex ==index ? Colors.white : Colors.white)
    //                             ),
    //                           ],
    //                         ),
    //                         SizedBox(width: 9),
    //                         Container(child: Icon(Icons.cancel,color: Colors.white,size: 22.0, ),) //color: Colors.white,
    //                       ],
    //                     )
    //                         :
    //                     Column(
    //                       children: [
    //                         Expanded(
    //                           child: Container(
    //                             padding: EdgeInsets.all(1.0),
    //                             // For  demo we use fixed height  and width
    //                             // Now we dont need them
    //                             height: 60,
    //                             width: 60,
    //                             // decoration: BoxDecoration(
    //                             //   //color: product.color,
    //                             //   borderRadius: BorderRadius.all(Radius.circular(50.0)),
    //                             // ),
    //                             child: Hero(
    //                               tag: "'${categoryList[index]["Id"]}'",
    //                               child: ClipRRect(
    //                                   borderRadius: BorderRadius.vertical(top: Radius.circular(30.0),bottom: Radius.circular(30.0),),
    //                                   child: Image.network('${categoryList[index]["Photo"]}')),
    //                             ),
    //                           ),
    //                         ),
    //                         Text('${categoryList[index]["NameEn"]}',
    //                             style: TextStyle( fontSize: 16.0, color: activeindex ==index ? Colors.white : Colors.white)
    //                         ),
    //                       ],
    //                     ),
    //
    //                   ),
    //                 )
    //               //catName: items[index].catName
    //               //imagePath: _categories[index].imagePath,
    //               //numberOfItems: _categories[index].numberOfItems,
    //             ),
    //           );
    //         },
    //       ): Center(child: Text('No Items Found'),)
    //   ),
    // );
  }


  ///

  Widget productGridView(){
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 8, 8),
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 2,
        mainAxisSpacing: 5.0,
        crossAxisSpacing: 2.0,
        childAspectRatio: 0.8,
        physics: NeverScrollableScrollPhysics(),
        children: List.generate(
          filterName.length,
              (index) => InkWell(
            onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ProductDetailScreen(id: filterName[index],),
                  ));
            },
            child: Container(
              margin: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20.0),bottom: Radius.circular(20.0),),
                    child: Image.network(
                      filterName[index]['Photo'],
                      height: 150.0,
                      width: 120.0,
                      fit: BoxFit.fill,
                    ),
                  ),
                  UIHelper.verticalSpaceExtraSmall(),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Text(
                      //   'BREAKFAST',
                      //   style: Theme.of(context).textTheme.bodyText1.copyWith(
                      //     fontSize: 10.0,
                      //     color: Colors.grey[700],
                      //   ),
                      // ),
                      UIHelper.verticalSpaceExtraSmall(),
                      Row(
                        children: <Widget>[
                          //VegBadgeView(),
                          UIHelper.horizontalSpaceExtraSmall(),
                          Flexible(
                            child: Text(
                              filterName[index]['NameEn'],
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2
                                  .copyWith(fontSize: 13.0),
                            ),
                          ),
                        ],
                      ),
                      UIHelper.verticalSpaceMedium(),
                      // Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("QAR - ${filterName[index]['Price'].toString()}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(fontSize: 14.0)),
                          AddBtnView()
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
    // return GridView.builder(
    //     shrinkWrap: true,
    //     physics: ClampingScrollPhysics(),
    //     itemCount: filterName.length,
    //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //       crossAxisCount: 2,
    //       mainAxisSpacing: 5.0,
    //       crossAxisSpacing: 2.0,
    //       childAspectRatio: 0.90,
    //     ),
    //     itemBuilder: (context, index) => ProductItems(
    //       image: filterName[index]['Photo'],
    //       title: filterName[index]['NameEn'],
    //       price: filterName[index]['Price'],
    //       Id: filterName[index]['Id'],
    //       press: () => Navigator.push(
    //           context,
    //           MaterialPageRoute(
    //             builder: (context) =>
    //                 DetailsScreen(filterName:filterName[index]),
    //           )),
    //     ));
  }

}

class AddBtnView extends StatelessWidget {
  const AddBtnView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 25.0),
      decoration: BoxDecoration(
        border: Border.all(color:Theme.of(context).primaryColor),
      ),
      child: Text(
        'ADD',
        style:
        Theme.of(context).textTheme.subtitle2.copyWith(color: Theme.of(context).primaryColor),
      ),
    );
  }
}


class VegBadgeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2.0),
      height: 15.0,
      width: 15.0,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green[800]),
      ),
      child: ClipOval(
        child: Container(
          height: 5.0,
          width: 5.0,
          color: Colors.green[800],
        ),
      ),
    );
  }
}



