import 'dart:ui';

import 'package:brqtrapp/screens/category_screen.dart';
import 'package:brqtrapp/screens/myprofile.dart';
import 'package:brqtrapp/screens/product_detail_screen.dart';
import 'package:brqtrapp/utils/constant.dart';
import 'package:brqtrapp/utils/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AllProductList extends StatefulWidget {
  int page;
  AllProductList({this.page});
  @override
  _VendorsListViewState createState() => _VendorsListViewState();
}

class _VendorsListViewState extends State<AllProductList> {
  bool _isLoading = false;
  List vendorData = new List();
  List finalData = new List();
  var lang;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  var langChanged;
  int length;
  @override
  void initState() {
    // TODO: implement initState
    _getVendorsData();
    super.initState();
  }

  Future<dynamic> _getVendorsData() async {
    // setState(() {
    //   _isLoading = true;
    // });

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    //var token = localStorage.getString('token');
    lang = localStorage.getString('selectedLanguage');
    langChanged = localStorage.getString('LangSelect');
    print("page no: ${widget.page}");
    var url =
        "${APIConstants.API_BASE_URL_DEV}${APIOperations.allProductList}?CurrentPage=0&NextPage=${widget.page}";
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

  Future _loadData() async {
    // perform fetching data delay
    await new Future.delayed(new Duration(seconds: 2));

    print("load more");
    // update data and loading status
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
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
                            description: finalData[index]['DescriptionEn'],
                            descriptionAr: finalData[index]['DescriptionAr'],
                            shortDes: finalData[index]['ShortDescriptionEn'],
                            shortDesAr: finalData[index]['ShortDescriptionAr'],
                            userId: customerId,
                            vendorId: finalData[index]['VendorId'],
                            inStock: finalData[index]['StockStatus'],
                            // nameEN: finalData[index]['NameEn'],
                            // nameAR: finalData[index]['NameAr'],
                            // vendorLogo: finalData[index]['Photo'],
                          )));
            },
            child: Container(
                margin: const EdgeInsets.only(top: 10, left: 15, right: 15),
                //   padding: EdgeInsets.all(4),
                width: MediaQuery.of(context).size.width * .4,
                height: MediaQuery.of(context).size.height * .32,
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * .4,
                          height: MediaQuery.of(context).size.height * .22,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
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
                                  colorFilter: new ColorFilter.mode(
                                      Colors.grey.withOpacity(0.4),
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: lang == "Ar" && langChanged != "English"
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: lang == "Ar" && langChanged != "English"
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
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200.0,
        mainAxisSpacing: 2.0,
        crossAxisSpacing: 2.0,
        childAspectRatio: 0.75,
      ),
    );

    SliverList(
        delegate: SliverChildBuilderDelegate(
      (context, int index) {
        return AnimationConfiguration.staggeredGrid(
          position: index,
          duration: const Duration(milliseconds: 180),
          columnCount: 2,
          child: ScaleAnimation(
            scale: 12,
            child: FadeInAnimation(
                child: GestureDetector(
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
                              description: finalData[index]['DescriptionEn'],
                              descriptionAr: finalData[index]['DescriptionAr'],
                              shortDes: finalData[index]['ShortDescriptionEn'],
                              shortDesAr: finalData[index]
                                  ['ShortDescriptionAr'],
                              userId: customerId,
                              vendorId: finalData[index]['VendorId'],
                              inStock: finalData[index]['StockStatus'],
                              // nameEN: finalData[index]['NameEn'],
                              // nameAR: finalData[index]['NameAr'],
                              // vendorLogo: finalData[index]['Photo'],
                            )));
              },
              child: Container(
                  margin: const EdgeInsets.only(top: 10, left: 15, right: 15),
                  //   padding: EdgeInsets.all(4),
                  width: MediaQuery.of(context).size.width * .8,
                  height: MediaQuery.of(context).size.height * .4,
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * .8,
                            height: MediaQuery.of(context).size.height * .28,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16)),
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
                                    colorFilter: new ColorFilter.mode(
                                        Colors.grey.withOpacity(0.4),
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: lang == "Ar" && langChanged != "English"
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: lang == "Ar" && langChanged != "English"
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
            )),
          ),
        );
      },
      childCount: finalData.length,
    ));

    // Container(
    //     width: MediaQuery.of(context).size.width,
    //     height: MediaQuery.of(context).size.height * .5,
    //     child: SmartRefresher(
    //         controller: _refreshController,
    //         enablePullUp: true,
    //         onLoading: () {
    //           print("hellow testing 123");
    //           _refreshController.loadComplete();
    //         },
    //         child: Column(
    //           children: [
    //             Wrap(
    //               children: [
    //                 AnimationLimiter(
    //                   child: NotificationListener<ScrollNotification>(
    //                       onNotification: (ScrollNotification scrollInfo) {
    //                         if (!isLoading &&
    //                             scrollInfo.metrics.pixels ==
    //                                 scrollInfo.metrics.maxScrollExtent) {
    //                           _loadData();
    //                           // start loading data
    //                           setState(() {
    //                             isLoading = true;
    //                           });
    //                         }
    //                       },
    //                       child: GridView.count(
    //                         crossAxisCount: 2,
    //                         shrinkWrap: true,
    //                         childAspectRatio: 0.62,
    //                         physics: BouncingScrollPhysics(),
    //                         //childAspectRatio: 1 / 1,
    //                         children: List.generate(
    //                           finalData.length,
    //                           (int index) {
    //                             return
    //                              AnimationConfiguration.staggeredGrid(
    //                               position: index,
    //                               duration: const Duration(milliseconds: 180),
    //                               columnCount: 2,
    //                               child: ScaleAnimation(
    //                                 scale: 12,
    //                                 child: FadeInAnimation(
    //                                     child: GestureDetector(
    //                                   onTap: () async {
    //                                     SharedPreferences localStorage =
    //                                         await SharedPreferences
    //                                             .getInstance();

    //                                     var customerId =
    //                                         localStorage.getString('userID');
    //                                     Navigator.push(
    //                                         context,
    //                                         MaterialPageRoute(
    //                                             builder: (context) =>
    //                                                 ProductDetailScreen(
    //                                                   id: finalData[index]
    //                                                       ['Id'],
    //                                                   titleAr: finalData[index]
    //                                                       ['NameAr'],
    //                                                   title: finalData[index]
    //                                                       ['NameEn'],
    //                                                   price: finalData[index]
    //                                                       ['Price'],
    //                                                   description:
    //                                                       finalData[index]
    //                                                           ['DescriptionEn'],
    //                                                   descriptionAr:
    //                                                       finalData[index]
    //                                                           ['DescriptionAr'],
    //                                                   shortDes: finalData[index]
    //                                                       [
    //                                                       'ShortDescriptionEn'],
    //                                                   shortDesAr: finalData[
    //                                                           index][
    //                                                       'ShortDescriptionAr'],
    //                                                   userId: customerId,
    //                                                   vendorId: finalData[index]
    //                                                       ['VendorId'],
    //                                                   inStock: finalData[index]
    //                                                       ['StockStatus'],
    //                                                   // nameEN: finalData[index]['NameEn'],
    //                                                   // nameAR: finalData[index]['NameAr'],
    //                                                   // vendorLogo: finalData[index]['Photo'],
    //                                                 )));
    //                                   },
    //                                   child: Container(
    //                                       margin: const EdgeInsets.all(8.0),
    //                                       //   padding: EdgeInsets.all(4),
    //                                       width: MediaQuery.of(context)
    //                                               .size
    //                                               .width *
    //                                           .45,
    //                                       height: MediaQuery.of(context)
    //                                               .size
    //                                               .height *
    //                                           .2,
    //                                       decoration: BoxDecoration(
    //                                           borderRadius:
    //                                               BorderRadius.circular(20),
    //                                           color: Colors.white,
    //                                           //  border: Border.all(color: bluecolor, width: 1)
    //                                           boxShadow: [
    //                                             BoxShadow(
    //                                                 color: Colors.black
    //                                                     .withOpacity(0.3),
    //                                                 blurRadius: 1,
    //                                                 spreadRadius: 0.2)
    //                                           ]),
    //                                       child: Column(
    //                                         children: [
    //                                           Row(
    //                                             mainAxisAlignment:
    //                                                 MainAxisAlignment.center,
    //                                             children: [
    //                                               Container(
    //                                                 width:
    //                                                     MediaQuery.of(context)
    //                                                             .size
    //                                                             .width *
    //                                                         .45,
    //                                                 height:
    //                                                     MediaQuery.of(context)
    //                                                             .size
    //                                                             .height *
    //                                                         .28,
    //                                                 decoration: BoxDecoration(
    //                                                     borderRadius:
    //                                                         BorderRadius.all(
    //                                                             Radius.circular(
    //                                                                 16)),
    //                                                     // boxShadow: <BoxShadow>[
    //                                                     //   BoxShadow(
    //                                                     //     color: Colors.black12,
    //                                                     //     blurRadius: 2.0,
    //                                                     //   ),
    //                                                     // ],
    //                                                     image: DecorationImage(
    //                                                         image: NetworkImage(
    //                                                           "${finalData[index]['Photo']}",
    //                                                         ),
    //                                                         colorFilter:
    //                                                             new ColorFilter
    //                                                                     .mode(
    //                                                                 Colors
    //                                                                     .grey
    //                                                                     .withOpacity(
    //                                                                         0.4),
    //                                                                 BlendMode
    //                                                                     .darken),
    //                                                         fit: BoxFit.cover)),
    //                                                 // child: Center(
    //                                                 //   child: Image.network(

    //                                                 //     width:
    //                                                 //         MediaQuery.of(context).size.width * .29,
    //                                                 //     height:
    //                                                 //         MediaQuery.of(context).size.height * .14,
    //                                                 //     fit: BoxFit.contain,
    //                                                 //   ),
    //                                                 // )
    //                                               ),
    //                                             ],
    //                                           ),
    //                                           SizedBox(
    //                                             height: 5,
    //                                           ),
    //                                           Row(
    //                                             mainAxisAlignment:
    //                                                 MainAxisAlignment.center,
    //                                             children: [
    //                                               Flexible(
    //                                                 child: lang == "Ar" &&
    //                                                         langChanged !=
    //                                                             "English"
    //                                                     ? Text(
    //                                                         finalData[index]
    //                                                             ['NameAr'],
    //                                                         maxLines: 1,
    //                                                         textAlign: TextAlign
    //                                                             .center,
    //                                                         overflow:
    //                                                             TextOverflow
    //                                                                 .clip,
    //                                                         style: TextStyle(
    //                                                           color:
    //                                                               Colors.black,
    //                                                           fontSize: 16.0,
    //                                                           //     fontWeight: FontWeight.bold,
    //                                                         ),
    //                                                         // style: Theme.of(context).textTheme.subtitle2.copyWith(
    //                                                         //   fontSize: 14.0,
    //                                                         //   fontWeight: FontWeight.w600,
    //                                                         // ),
    //                                                       )
    //                                                     : Text(
    //                                                         finalData[index]
    //                                                             ['NameEn'],
    //                                                         textAlign: TextAlign
    //                                                             .center,
    //                                                         maxLines: 1,
    //                                                         overflow:
    //                                                             TextOverflow
    //                                                                 .clip,
    //                                                         style: TextStyle(
    //                                                           color:
    //                                                               Colors.black,
    //                                                           fontSize: 16.0,
    //                                                           //    fontWeight: FontWeight.bold,
    //                                                         ),
    //                                                         // style: Theme.of(context).textTheme.subtitle2.copyWith(
    //                                                         //   fontSize: 14.0,
    //                                                         //   fontWeight: FontWeight.w600,
    //                                                         // ),
    //                                                       ),
    //                                               )
    //                                             ],
    //                                           ),
    //                                           Row(
    //                                             mainAxisAlignment:
    //                                                 MainAxisAlignment.center,
    //                                             children: [
    //                                               Flexible(
    //                                                 child: lang == "Ar" &&
    //                                                         langChanged !=
    //                                                             "English"
    //                                                     ? Text(
    //                                                         "${translator.translate('Price')}: ${finalData[index]['Price']}",
    //                                                         maxLines: 1,
    //                                                         textAlign: TextAlign
    //                                                             .center,
    //                                                         overflow:
    //                                                             TextOverflow
    //                                                                 .clip,
    //                                                         style: TextStyle(
    //                                                           color:
    //                                                               Colors.black,
    //                                                           fontSize: 14.0,
    //                                                           //    fontWeight: FontWeight.bold,
    //                                                         ),
    //                                                         // style: Theme.of(context).textTheme.subtitle2.copyWith(
    //                                                         //   fontSize: 14.0,
    //                                                         //   fontWeight: FontWeight.w600,
    //                                                         // ),
    //                                                       )
    //                                                     : Text(
    //                                                         "${translator.translate('Price')}: ${finalData[index]['Price']}",
    //                                                         textAlign: TextAlign
    //                                                             .center,
    //                                                         maxLines: 1,
    //                                                         overflow:
    //                                                             TextOverflow
    //                                                                 .clip,
    //                                                         style: TextStyle(
    //                                                           color:
    //                                                               Colors.black,
    //                                                           fontSize: 14.0,
    //                                                           //      fontWeight: FontWeight.bold,
    //                                                         ),
    //                                                       ),
    //                                               )
    //                                             ],
    //                                           ),
    //                                         ],
    //                                       )),
    //                                 )),
    //                               ),
    //                             );
    //                           },
    //                         ),
    //                       )),
    //                 ),

    //                 ///    isLoading == true ? _buildBody : Container()
    //               ],
    //             ),

    //             // Container(
    //             //   height: isLoading ? 50.0 : 50,
    //             //   color: Colors.transparent,
    //             //   child: Center(
    //             //     child: new CircularProgressIndicator(),
    //             //   ),
    //             // )
    //           ],
    //         )));
  }

  Widget _buildBody() {
    if (isLoading) {
      return new Center(
        child: new CircularProgressIndicator(),
      );
    }
    setState(() {
      widget.page = widget.page + 1;
    });
    print(widget.page);
    // _getVendorsData();
  }
}
