import 'package:brqtrapp/utils/constant.dart';
import 'package:brqtrapp/utils/ui_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:jiffy/jiffy.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;

class NewsDetailScreen extends StatefulWidget {
  final newId;
  final title;
  final titleAr;
  final des;
  final desAr;
  final img;
  final date;

  const NewsDetailScreen({Key key, this.newId, this.title, this.titleAr, this.des, this.desAr, this.img, this.date}) : super(key: key);

  @override
  _NewsDetailScreenState createState() => _NewsDetailScreenState(newId,title,titleAr,des,desAr,img,date);
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  final newId;
  final title;
  final titleAr;
  final des;
  final desAr;
  final img;
  final date;
  var lang;
  var langChanged;
  bool _isLoggedIn = false;

  _NewsDetailScreenState(this.newId, this.title, this.titleAr, this.des, this.desAr, this.img, this.date);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkIfLoggedIn();
    //_getCartQuantity();
  }

  void _checkIfLoggedIn() async {
    // check if token is there
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    //customerId = localStorage.getString('userID');
    lang = localStorage.getString('selectedLanguage');
    langChanged = localStorage.getString('LangSelect');
    //print("Logged in customer id is =======>>>>>>$customerId");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
//             Padding(
//                 padding: const EdgeInsets.all(10),
//                 child: Container(
//                     height: 150.0,
//                     width: 30.0,
//                     child: GestureDetector(
//                         onTap: () {
// //                  _isLoggedIn? Navigator.of(context).push(new MaterialPageRoute(
// //                      builder: (BuildContext context) => CartPage()
// //                  )) : null;
//                           if (_isLoggedIn == true) {
//                             Navigator.of(context).push(MaterialPageRoute(
//                                 builder: (BuildContext context) => CartScreen()));
//                           } else {
//                             //_guestAlertForAddtoCart();
//                           }
//                         },
//
//                         /// badge on Cart code --
//                         child: new Stack(
//                           children: <Widget>[
//                             new IconButton(
//                               icon: new Icon(
//                                 Icons.shopping_basket_rounded,
//                                 color: Colors.white,
//                               ),
//                               onPressed: null,
//                               iconSize: 27,
//                             ),
//                             totalCount == ""
//                                 ? new Container()
//                                 : new Positioned(
//                                 left: 3,
//                                 child: _isLoggedIn
//                                     ? new Stack(
//                                   children: <Widget>[
// //                                new Icon(Icons.brightness_1,
// //                                    size: 19.0,
// //                                    color: Theme.of(context).accentColor),
//                                     Container(
//                                       height: 20.0,
//                                       width: 20.0,
//                                       child: Align(
//                                         alignment:
//                                         Alignment.center,
//                                         child: new Center(
//                                             child: _isLoggedIn
//                                                 ? new Text(
//                                               "${totalCount}",
//                                               style: new TextStyle(
//                                                   color: Colors
//                                                       .white,
//                                                   fontSize:
//                                                   11.0,
//                                                   fontWeight:
//                                                   FontWeight.w500),
//                                             )
//                                                 : null),
//                                       ),
//                                       decoration: BoxDecoration(
//                                           borderRadius:
//                                           BorderRadius.all(
//                                               Radius.circular(
//                                                   100.0)),
//                                           color: Colors.red),
//                                     ),
//                                   ],
//                                 )
//                                     : null),
//                           ],
//                         )))
//
//               // OutlineButton(
//               //   child: Text("LOGIN"),
//               //   shape: RoundedRectangleBorder(
//               //       borderRadius: new BorderRadius.circular(
//               //           UIsizes.INPUT_BUTTON_BORDER_RADIUS)),
//               //   color: Theme.of(context).primaryColor,
//               //   onPressed: () {
//               //     Navigator.pushReplacement(
//               //       context,
//               //       MaterialPageRoute(builder: (context) => LoginPage()),
//               //     );
//               //   },
//               // ),
//             ),
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
                      _singleImageView(),
                      SizedBox(height: 20.0,),
                      Divider(height: 1,thickness: 1,indent: 10,),
                      _productTitlePrice(),
                      SizedBox(height: 15,),
                      Divider(height: 1,thickness: 1,indent: 10,endIndent: 10,),
                      _longDescription(),
                      SizedBox(height: 10,),
                      ProductsBannerImages(id:newId),
                      // VendorsListView(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _singleImageView(){
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Container(
        height: 350.0,
        width: 420.0,
        child: Column(
          //mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              //padding: const EdgeInsets.all(14.0),
              decoration: BoxDecoration(
                //color: Theme.of(context).primaryColor,//Colors.grey[200],
                boxShadow: <BoxShadow>[
                  // BoxShadow(
                  //   color: Theme.of(context).primaryColor,
                  //   blurRadius: 3.0,
                  //   spreadRadius: 2.0,
                  // )
                ],
              ),
              child: Image.network(img,
                height: 350.0,
                width: 420,
                 fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _productTitlePrice(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
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
                      color: Colors.black,fontSize: 20.0,fontWeight: FontWeight.bold
                  ),
                ):Text(
                  title,
                  style: TextStyle(
                      color: Colors.black,fontSize: 20.0,fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ],
          ),
          UIHelper.verticalSpaceMedium(),
          Row(
            children: [
              Icon(Icons.calendar_today_rounded,size: 18,color: Theme.of(context).primaryColor,),
              SizedBox(width: 10,),
              Text("${Jiffy("${date}").yMMMMd}",style: TextStyle(
                  fontSize: 13.0,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold),),
            ],
          ),
          // Row(
          //   children: <Widget>[
          //     //VegBadgeView(),
          //     UIHelper.horizontalSpaceExtraSmall(),
          //     Flexible(
          //       child: lang == "Ar" && langChanged != "English" ?Text(
          //         shortDesAr,
          //         style: TextStyle(
          //             color: Colors.black,fontSize: 14.0,fontWeight: FontWeight.normal
          //         ),
          //       ):Text(
          //         shortDes,
          //         style: TextStyle(
          //             color: Colors.black,fontSize: 14.0,fontWeight: FontWeight.normal
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          // // Spacer(),
          // SizedBox(height: 10,),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: <Widget>[
          //     Text("QAR - ${price.toString()}",
          //       style: TextStyle(
          //           color: Colors.red,fontSize: 20.0,fontWeight: FontWeight.bold
          //       ),
          //     ),
          //     //AddBtnView()
          //   ],
          // )
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
          //Text(translator.translate('Details:'),style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
            child: Container(
              child: RichText(
                text: lang == "Ar" && langChanged != "English" ? TextSpan(
                    text: desAr,
                    style: TextStyle(color: Colors.black)
                ):TextSpan(
                    text: des,
                    style: TextStyle(color: Colors.black)
                ),
              ),),
          ),
        ],
      ),
    );
  }
}

class ProductsBannerImages extends StatefulWidget {
  final id;

  const ProductsBannerImages({Key key, this.id}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _ProductsBannerImagesState(id);
  }
}

class _ProductsBannerImagesState extends State<ProductsBannerImages> {
  final id;
  int _current = 0;
  bool isLoading = false;
  List bannerData = new List();
  List images;

  _ProductsBannerImagesState(this.id);

//  final List<String> images = [
//    'https://images.unsplash.com/photo-1586882829491-b81178aa622e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2850&q=80',
//    'https://images.unsplash.com/photo-1586871608370-4adee64d1794?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2862&q=80',
//    'https://images.unsplash.com/photo-1586901533048-0e856dff2c0d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1650&q=80',
//    'https://images.unsplash.com/photo-1586902279476-3244d8d18285?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2850&q=80',
//    'https://images.unsplash.com/photo-1586943101559-4cdcf86a6f87?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1556&q=80',
//    'https://images.unsplash.com/photo-1586951144438-26d4e072b891?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1650&q=80',
//    'https://images.unsplash.com/photo-1586953983027-d7508a64f4bb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1650&q=80',
//  ];

  @override
  void initState() {
print('News id is ====>>>$id');
//    WidgetsBinding.instance.addPostFrameCallback((_) {
//      images.forEach((imageUrl) {
//        precacheImage(NetworkImage(imageUrl), context);
//      });
//    });
    super.initState();
    _getBannerImagesData();
  }

  Future<dynamic> _getBannerImagesData() async {
    setState(() {
      isLoading = true;
    });

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');

    var url = APIConstants.API_BASE_URL_DEV + "getNewsPhotos?NewsId=$id";
    Map<String, String> requestHeaders = {
      //'Content-type': 'application/json',
      //'Accept': 'application/json',
      'x-api-key': '987654',
      //'Authorization': 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjZmMjc2ZGU3YTI1YWE3MDlmOTdiYjcwZDllODY3ZGNjNzllNWRjMzJmOGZlZjNlNWQ1YzhlMzM5YTU5ZjMyNTU2YWNlZWM1YTdlZDc3MjY0In0.eyJhdWQiOiIyIiwianRpIjoiNmYyNzZkZTdhMjVhYTcwOWY5N2JiNzBkOWU4NjdkY2M3OWU1ZGMzMmY4ZmVmM2U1ZDVjOGUzMzlhNTlmMzI1NTZhY2VlYzVhN2VkNzcyNjQiLCJpYXQiOjE1ODA1NDM5ODUsIm5iZiI6MTU4MDU0Mzk4NSwiZXhwIjoxNjEyMTY2Mzg1LCJzdWIiOiIxMzIiLCJzY29wZXMiOltdfQ.h33_EIU37oXVwrBR3bU6Y7NzyoM4m1wue-09NkDOh4AEimZ9mjjoqxU2fvGEZ_Bo-o6sE5hNg_84bJ-WctedsnoEdwNSPt1O_1SWIrIFhyU5vvv1i9HyBIKx_l4uZLcC-C52TxxvO2awQrrDHPxcbAsyqqa7Z3jh02dAN91r-6Oe0XaH6OV-FabwSMdsWh028GxuIzJwATfHA_zPfDtIquG1TBLc7Q9cFOzlio7IOy3tOLCxVL4f_vt-aOwVF0C0M_eTgk8znI7nTpWk3TgKN_OjRegxbkSGXrS59SIMNZUhMBI1j1vmzSFmRlpEZ8vj5csFxnmTv9oT5tLviD06y8TIISHifpUMI4z2o4rg_qFQbHTAkf37pw2TCfsbzL5sIWMFwWNvbpeKmplurcsnqbzcXl7STqrHftWEwxz6a4Cjrt2fCcxWAkS3CzraANhMkDFuS9oaRqLGfGsZytOZVLTYzQi3HanEip_NqhtEDLhkiEZ6LSJg9CSkk9q9gjruM3zs-l_GijkwJZpdgHwb06SXQb1hF8sS-pcXMwKHU-nF9zKoYZYjodSLaawFtNleylQqZO1mg9gK0XEoMHqm1NXdJH54mqSjoIKmDtKPbmGINzERRB6Cls0pHjC5Z82JBZ9g7xwmOJbMGdN7i2rZhOzs4Mq-eT85nsP2-SNPiJE'
    };
    final response = await http.get(url, headers: requestHeaders);
    //final List<FavoriteItem> favProducts = [];
    final sliderData = json.decode(response.body);
    //print("Banner slider images- $sliderData");
    final bannerImgData = sliderData['Data'];
    print("Banner images##########- $bannerImgData");
    List dataBanner = new List();
    var dataLength = bannerImgData.length;
    for (int i = 0; i < dataLength; i++) {
      dataBanner.add(bannerImgData[i]);
    }
    //var favProd = favData['product'];
    // print('favorite Product Name - $favProd');

    if (!mounted) return;
    setState(() {

      bannerData.addAll(dataBanner);
      if(bannerData != null){
        images = bannerData;
      }

      isLoading = false;
    });

    //print('data isss $favData["data"]');
    if (images == null) {
      return;
    }
    // _favorite = favProducts;
  }

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
    return InkWell(
      child: images?.length == null? Container():isLoading ? _buildProgressIndicator():Container(
        margin: const EdgeInsets.symmetric(vertical: 0.0),
        height: 280.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Swiper(
          itemHeight: 100,
          duration: 1000,
          itemWidth: double.infinity,
          pagination: SwiperPagination(),
          itemCount: images?.length,
          itemBuilder: (BuildContext context, int index) => Image.network(
            images[index]['Image'],
            fit: BoxFit.cover,
          ),
          autoplay: false,
          viewportFraction: 1.0,
          scale: 0.9,
        ),
      ),
      // onTap: () {
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => null,
      //     ),
      //   );
      // },
    );
  }
//   Widget build(BuildContext context) {
//     return Scaffold(
//       //appBar: AppBar(title: Text('Prefetch image slider demo')),
//       body: isLoading
//           ? _buildProgressIndicator()
//           : images.isEmpty
//           ? Center(
//         child: Image(
//           image: AssetImage(
//             'images/default-banner.jpg',
//           ),
//           width: MediaQuery.of(context).size.width,
//         ),
//       )
//           : Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: <Widget>[
//           Container(
//               height: 180.0,
//               width: 1000.0,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.all(Radius.circular(20.0)),
//               ),
//               child: CarouselSlider.builder(
//                 itemCount: images?.length,
//                 options: CarouselOptions(
//                     autoPlay: true,
//                     aspectRatio: 2.0,
//                     enlargeCenterPage: true,
//                     onPageChanged: (index, reason) {
//                       setState(() {
//                         _current = index;
//                       });
//                     }),
//                 itemBuilder: (context, index) {
//                   return Container(
//                     decoration: BoxDecoration(
//                       borderRadius:
//                       BorderRadius.all(Radius.circular(20.0)),
//                     ),
//                     child: Center(
//                         child: Image.network(
//                           '${images[index]['Image']}',
//                           fit: BoxFit.cover,
//                           width: 1000,
//                           height: 160,
//                         )),
//                   );
//                 },
//               )),
// //          Row(
// //            mainAxisAlignment: MainAxisAlignment.center,
// //            children: images.map((url) {
// //              int index = images.length;
// //              return Container(
// //                width: 8.0,
// //                height: 8.0,
// //                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
// //                decoration: BoxDecoration(
// //                  shape: BoxShape.circle,
// //                  color: _current == index
// //                      ? Color.fromRGBO(0, 0, 0, 0.9)
// //                      : Color.fromRGBO(0, 0, 0, 0.4),
// //                ),
// //              );
// //            }).toList(),
// //          ),
//         ],
//       ),
//     );
//   }
}
