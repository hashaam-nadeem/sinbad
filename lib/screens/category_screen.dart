import 'dart:convert';
import 'package:brqtrapp/components/description.dart';
import 'package:brqtrapp/screens/cart_screen.dart';
import 'package:brqtrapp/screens/product_detail_screen.dart';
import 'package:brqtrapp/screens/product_items.dart';
import 'package:brqtrapp/screens/subcategory_screen.dart';
import 'package:brqtrapp/screens/vendorsbydepart_screen.dart';
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
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;

class CategoryScreen extends StatefulWidget {
  final id;
  final nameEN;
  final nameAR;
  final vendorLogo;

  const CategoryScreen({Key key, this.id, this.nameEN, this.nameAR, this.vendorLogo}) : super(key: key);
  @override
  _CategoryScreenState createState() => _CategoryScreenState(id,nameEN,nameAR,vendorLogo);
}

class _CategoryScreenState extends State<CategoryScreen> {
  final id;
  final nameEN;
  final nameAR;
  final vendorLogo;
  List categoryList = new List();
  List categoryData = new List();
  var lang;
  var langChanged;
  var customerId;
  var totalCount = "";


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
  //int totalCount = 0;
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
  Widget _appBarTitle = new Text('');
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List sizes = new List();
  List pricesId = new List();
  var singleItemAddID;

  @override
  void initState() {
    users.clear();
    networkChecked();
    _getCartQuantity();
    //this._getMoreData(1,'');  ////Uncomment for More data
    _checkIfLoggedIn();
    _getCat();
    _getDeptProduct(1);
    print('Vendors Detail screen loaded  ====>CategoryScreen>>>');
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
    var url = APIConstants.API_BASE_URL_DEV + "/categoriesByVendor?VendorId=$id";
    print("Categories by vendors Url is --->> $url");
    Map<String, String> requestHeaders = {
      //'Accept': 'application/json',
      'x-api-key': '987654',
    };
    final response = await http.get(url, headers: requestHeaders);
    final catData = json.decode(response.body);
    print("Categories by vendors data- $catData");
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


  Future<dynamic>_getDeptProduct(int index) async{
    // SharedPreferences saveBranchID = await SharedPreferences.getInstance();
    // var branchId = saveBranchID.getString('branchId');

    String catId;
    String branchCheck;
    if (categoryID == null) {
      catId = "&CategoryId=";
    } else {
      catId = "&CategoryId=${categoryID.toString()}";
    }
    setState(() {
      isLoading = true;
    });
    //SharedPreferences localStorage = await SharedPreferences.getInstance();
    //var token = localStorage.getString('token');
    var url = APIConstants.API_BASE_URL_DEV + "/productsByVendor?VendorId=$id&Page=$page" + catId;
    print("Product by Vendors is --->> $url");
    Map<String, String> requestHeaders = {
      //'Accept': 'application/json',
      'x-api-key': '987654',
    };
    final response = await http.get(url, headers: requestHeaders);
    final catData = json.decode(response.body);
    print("All Product Vendors data- $catData");
    final catProductData = catData['Data'];
    print('Mazeed is printing here!');
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
      print("in stock available ${filterName[index]['StockStatus']}");
    });

    if (categoryList == null) {
      return;
    }
  }

  // Future<dynamic> _getCartQuantity() async {
  //
  //   SharedPreferences localStorage = await SharedPreferences.getInstance();
  //   var token = localStorage.getString('token');
  //   customerId = localStorage.getString('userID');
  //
  //   var url = APIConstants.API_BASE_URL_DEV + "/addToCart?UserId=$customerId";
  //   Map<String, String> requestHeaders = {
  //     //'Content-type': 'application/json',
  //     //'Accept': 'application/json',
  //     'x-api-key': '987654',
  //     //'Authorization': 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjZmMjc2ZGU3YTI1YWE3MDlmOTdiYjcwZDllODY3ZGNjNzllNWRjMzJmOGZlZjNlNWQ1YzhlMzM5YTU5ZjMyNTU2YWNlZWM1YTdlZDc3MjY0In0.eyJhdWQiOiIyIiwianRpIjoiNmYyNzZkZTdhMjVhYTcwOWY5N2JiNzBkOWU4NjdkY2M3OWU1ZGMzMmY4ZmVmM2U1ZDVjOGUzMzlhNTlmMzI1NTZhY2VlYzVhN2VkNzcyNjQiLCJpYXQiOjE1ODA1NDM5ODUsIm5iZiI6MTU4MDU0Mzk4NSwiZXhwIjoxNjEyMTY2Mzg1LCJzdWIiOiIxMzIiLCJzY29wZXMiOltdfQ.h33_EIU37oXVwrBR3bU6Y7NzyoM4m1wue-09NkDOh4AEimZ9mjjoqxU2fvGEZ_Bo-o6sE5hNg_84bJ-WctedsnoEdwNSPt1O_1SWIrIFhyU5vvv1i9HyBIKx_l4uZLcC-C52TxxvO2awQrrDHPxcbAsyqqa7Z3jh02dAN91r-6Oe0XaH6OV-FabwSMdsWh028GxuIzJwATfHA_zPfDtIquG1TBLc7Q9cFOzlio7IOy3tOLCxVL4f_vt-aOwVF0C0M_eTgk8znI7nTpWk3TgKN_OjRegxbkSGXrS59SIMNZUhMBI1j1vmzSFmRlpEZ8vj5csFxnmTv9oT5tLviD06y8TIISHifpUMI4z2o4rg_qFQbHTAkf37pw2TCfsbzL5sIWMFwWNvbpeKmplurcsnqbzcXl7STqrHftWEwxz6a4Cjrt2fCcxWAkS3CzraANhMkDFuS9oaRqLGfGsZytOZVLTYzQi3HanEip_NqhtEDLhkiEZ6LSJg9CSkk9q9gjruM3zs-l_GijkwJZpdgHwb06SXQb1hF8sS-pcXMwKHU-nF9zKoYZYjodSLaawFtNleylQqZO1mg9gK0XEoMHqm1NXdJH54mqSjoIKmDtKPbmGINzERRB6Cls0pHjC5Z82JBZ9g7xwmOJbMGdN7i2rZhOzs4Mq-eT85nsP2-SNPiJE'
  //   };
  //   final response = await http.get(url, headers: requestHeaders);
  //   //final List<FavoriteItem> favProducts = [];
  //   final sliderData = json.decode(response.body);
  //   print("Numbers of items in cart are->>>>>> $sliderData");
  //   final qauntityData = sliderData['CartQuantity'];
  //   //List dataBanner = new List();
  //   //var dataLength = bannerImgData.length;
  //   // for (int i = 0; i < dataLength; i++) {
  //   //   dataBanner.add(bannerImgData[i]);
  //   // }
  //   //var favProd = favData['product'];
  //   // print('favorite Product Name - $favProd');
  //
  //   if (!mounted) return;
  //   setState(() {
  //     totalCount = qauntityData;
  //     // bannerData.addAll(dataBanner);
  //     // images = bannerData;
  //     // isLoading = false;
  //   });
  //
  //   //print('data isss $favData["data"]');
  //   // if (totalCount == null) {
  //   //   return;
  //   // }
  //   // _favorite = favProducts;
  // }


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


  _CategoryScreenState(this.id, this.nameEN, this.nameAR, this.vendorLogo);


  @override
  Widget build(BuildContext context) {
    _getCartQuantity();
    return Scaffold(
      //backgroundColor: Theme.of(context).accentColor,
      appBar: AppBar(
        elevation: 0.0,
        // leading: new IconButton(
        //     icon: Platform.isIOS ? new Icon(Icons.arrow_back_ios) : new Icon(Icons.arrow_back),
        //     onPressed: (){
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(builder: (context) => VendorsByDepartmentScreen()),
        //       );
        //     }
        // ),
        title:lang == "Ar" && langChanged != "English" ? Text(
          nameAR,
          style: TextStyle(
            color: Colors.white,
          ),
        ): Text(
          nameEN,
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
      body: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: CustomScrollView(
                  controller: _scrollController,
                  shrinkWrap: true,
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: 200.0,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ClipOval(
                              child: Container(
                                //padding: const EdgeInsets.all(14.0),
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
                                  vendorLogo,
                                  height: 120.0,
                                  width: 120.0,
                                  // fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            lang == "Ar" && langChanged != "English" ? Text(
                              nameAR,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,fontSize: 18,fontWeight: FontWeight.bold
                              ),
                              // style: Theme.of(context)
                              //     .textTheme
                              //     .bodyText1
                              //     .copyWith(fontSize: 18),
                            ):Text(
                              nameEN,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,fontSize: 18,fontWeight: FontWeight.bold
                              ),
                              // style: Theme.of(context)
                              //     .textTheme
                              //     .bodyText1
                              //     .copyWith(fontSize: 18),
                            )
                          ],
                        ),
                      ),
                    ),
                    // child: Padding(
                    //   padding: const EdgeInsets.all(10.0),
                    //   child: SizedBox(
                    //     child: Container(
                    //       height: 120,
                    //       width: 64,
                    //       child: Image.network(
                    //         vendorLogo,
                    //         //height: 80.0,
                    //         //width: 80.0,
                    //         fit: BoxFit.fill,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ),/// Vendor's Logo
                  // SliverToBoxAdapter( /// Search bar code start
                  //   child: Padding(
                  //     padding: const EdgeInsets.only(left:18.0,right: 18.0),
                  //     child: SizedBox(
                  //       height: 50.0,
                  //       child: Container(
                  //         child: TextField(
                  //           onChanged: (str){
                  //             setState(() {
                  //               users.clear();
                  //
                  //             });
                  //             if(str.length>2){
                  //               isLoading = false;
                  //               print(str);
                  //               categoryID=null;
                  //               //_getMoreData(1, str);   ////Uncomment for More data
                  //             }else if(str.length==0){
                  //               setState(() {
                  //                 users.clear();
                  //
                  //               });
                  //              // _getMoreData(1, ''); ///Uncomment for More data
                  //             }
                  //           },
                  //           decoration: InputDecoration(
                  //             //border:  InputBorder.none,
                  //               border:  InputBorder.none,
                  //               hintText: 'Search Your Items',
                  //               icon: Icon(Icons.search)
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ), /// Search bar code End
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          //Icon(Icons.list, size: 30.0,color: Theme.of(context).primaryColor,),
                          //UIHelper.horizontalSpaceSmall(),
                          Text(
                            translator.translate('Category'),
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,fontSize: 16.0, fontWeight: FontWeight.bold,
                            ),
                            // style: Theme.of(context)
                            //     .textTheme
                            //     .headline4
                            //     .copyWith(fontSize: 20.0,fontWeight: FontWeight.bold,),
                          ),
                          SizedBox(child: Divider(height: 2,thickness: 2,),width: MediaQuery.of(context).size.width*.77,),


                        ],
                      ),
                    ),
                      // child: Divider(
                      //   height: 1.0, color: Colors.grey[500],
                      //   indent: 10.0,endIndent: 10.0,)
                     ), /// Category divider
                  SliverToBoxAdapter(/// Category code start
                    child: SizedBox(
                      height: 120.0,
                      width: 120.0,
                      child: Container(
                        child: categoryListView(),
                      ),
                    ),
                  ),/// Category code End
                  // SliverToBoxAdapter(
                  //     child: Divider(
                  //       height: 2.0, color: Colors.grey[500],
                  //       indent: 10.0,endIndent: 10.0,thickness: 1.0,)),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            translator.translate('Products'),
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,fontSize: 17.0, fontWeight: FontWeight.bold,
                            ),
                            // style: Theme.of(context)
                            //     .textTheme
                            //     .headline4
                            //     .copyWith(fontSize: 20.0,fontWeight: FontWeight.bold,),
                          ),

                          //UIHelper.horizontalSpaceSmall(),

                          SizedBox(child: Divider(height: 2,thickness: 2,),width: MediaQuery.of(context).size.width*.65,),
                          Icon(Icons.list, size: 30.0,color: Theme.of(context).primaryColor,),

                        ],
                      ),
                    ),
                  ), /// Products divider
                  SliverToBoxAdapter(child: productGridView()) /// GridView Code starts
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
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 120.0,
        child: ListView.builder(
          itemCount: categoryList.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, int index) {
            if (categoryList.length == 0) {
              Center(
                child: Text('No Items Found'),
              );
            }
            return InkWell(
              onTap: (){
                print("Category $categoryID is Tapped");
                users.clear();
                page = 1;
                if (activeindex == index) {
                  setState(() {
                    activeindex = null;
                    categoryID = null;
                  });
                  _getDeptProduct(page,);
                  //_getMoreData(page, "");
                } else {
                  setState(() {
                    activeindex = index;
                    categoryID = categoryList[index]["Id"];
                  });
                  _getDeptProduct(page,);
                  //_getMoreData(page, "");
                }
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) =>
                //           SubCategoryScreen(id: categoryList[index]['Id']),
                //     ));
              },
              child: Container(
                width: 100.0,
                //height: 100.0,
                child: Column(

                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[

                    ClipOval(
                      child: Container(
                        //padding: const EdgeInsets.all(1.0),
                        decoration: BoxDecoration(
                          borderRadius: new BorderRadius.all(new Radius.circular(50.0)),
                          border: new Border.all(
                            color: activeindex == index ? Colors.red : Theme.of(context).primaryColor,
                            width: 2.0,
                          ),
                          color: Theme.of(context).primaryColor,//Colors.grey[200],
                          boxShadow: <BoxShadow>[
                            // BoxShadow(
                            //   color: Theme.of(context).primaryColor,
                            //   blurRadius: 3.0,
                            //   spreadRadius: 2.0,
                            // )
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(50.0),bottom: Radius.circular(50.0),),
                          child: Image.network(
                            '${categoryList[index]["Photo"]}',
                            height: 75.0,
                            width: 75.0,
                            // fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    lang == "Ar" && langChanged != "English" ? Text(categoryList[index]["NameAr"],
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,fontSize: 14,fontWeight: FontWeight.bold
                      ),
                      // style: Theme.of(context)
                      //     .textTheme
                      //     .bodyText1
                      //     .copyWith(fontSize: 13.5),
                    ): Text(categoryList[index]["NameEn"],
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,fontSize: 14,fontWeight: FontWeight.bold
                      ),
                      // style: Theme.of(context)
                      //     .textTheme
                      //     .bodyText1
                      //     .copyWith(fontSize: 13.5),
                    )
                  ],
                ),
              ),
            );
          },

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
                            ProductDetailScreen(id: filterName[index]['Id'],
                              title: filterName[index]['NameEn'],
                              titleAr: filterName[index]['NameAr'],
                              price: filterName[index]['Price'],
                              shortDes: filterName[index]['ShortDescriptionEn'],
                              shortDesAr: filterName[index]['ShortDescriptionAr'],
                              description: filterName[index]['DescriptionEn'],
                              descriptionAr: filterName[index]['DescriptionAr'],
                              userId: filterName[index]['UserId'],
                              vendorId: filterName[index]['VendorId'],
                              inStock: filterName[index]['StockStatus'],

                            ),
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
                      height: 130.0,
                      width: 110.0,
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
                            child: lang == "Ar" && langChanged != "English" ? Text(filterName[index]["NameAr"],
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,fontSize: 14,fontWeight: FontWeight.bold
                              ),
                              // style: Theme.of(context)
                              //     .textTheme
                              //     .bodyText1
                              //     .copyWith(fontSize: 13.5),
                            ): Text(filterName[index]["NameEn"],
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,fontSize: 14,fontWeight: FontWeight.bold
                              ),
                              // style: Theme.of(context)
                              //     .textTheme
                              //     .bodyText1
                              //     .copyWith(fontSize: 13.5),
                            )
                          ),
                        ],
                      ),
                      //UIHelper.verticalSpaceMedium(),
                      // Spacer(),
                      //SizedBox(height: 5,),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("QAR - ${filterName[index]['Price'].toString()}",
                              style: TextStyle(
                                color: Colors.red, fontSize: 15
                              ),
                                // style: Theme.of(context)
                                //     .textTheme
                                //     .bodyText1
                                //     .copyWith(fontSize: 14.0)
                            ),
                            //AddBtnView()
                          ],
                        ),
                      )
                    ],
                  )
                ],
            ),
          ),
              ),
          //controller: _scrollController,
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



