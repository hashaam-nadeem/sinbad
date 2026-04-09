import 'dart:ui';

import 'package:brqtrapp/screens/category_screen.dart';
import 'package:brqtrapp/screens/vendorsbydepart_screen.dart';
import 'package:brqtrapp/utils/constant.dart';
import 'package:brqtrapp/utils/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:localize_and_translate/localize_and_translate.dart';
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'departmentCategory.dart';

class DepartListView extends StatefulWidget {
  @override
  _DepartListViewState createState() => _DepartListViewState();
}

class _DepartListViewState extends State<DepartListView> {
  bool _isLoading = false;
  bool langArabic = false;
  var lang;
  var langChanged;
  var customerId;

  var placeholder = AssetImage("images/applogo.png");
  List departmentData = new List();
  List finalData = new List();

  var totalCount = '0';

  @override
  void initState() {
    // TODO: implement initState
    _getDepartmentData();
    _getCartQuantity();
    super.initState();
  }

  Future<dynamic> _getDepartmentData() async {
    setState(() {
      _isLoading = true;
    });

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    bool langArabic = localStorage.getBool('isLangArabic');
    lang = localStorage.getString('selectedLanguage');
    langChanged = localStorage.getString('LangSelect');

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

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        GridView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: finalData?.length,
          shrinkWrap: true,
          //  scrollDirection: Axis.horizontal,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 3,
              crossAxisSpacing: 0,
              childAspectRatio: 0.9),
          // Generate 100 widgets that display their index in the List.
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DepartmentCategories(id: finalData[index]['Id']),
                    ));
              },
              child: Container(
                margin: EdgeInsets.only(left: 5, right: 5),
                width: MediaQuery.of(context).size.width * .35,
                height: MediaQuery.of(context).size.height * .5,
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            width: MediaQuery.of(context).size.width * .28,
                            height: MediaQuery.of(context).size.height * .12,
                            margin: EdgeInsets.only(bottom: 5),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: finalData[index]['Photo'] != null
                                      ? NetworkImage(
                                          "${finalData[index]['Photo']}")
                                      : placeholder,
                                  fit: BoxFit.cover),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                            )),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: lang == "Ar" && langChanged != "English"
                              ? Text(
                                  finalData[index]['NameAr'],
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                    // fontWeight: FontWeight.bold,
                                  ),
                                  // style: Theme.of(context).textTheme.subtitle2.copyWith(
                                  //   fontSize: 14.0,
                                  //   fontWeight: FontWeight.w600,
                                  // ),
                                )
                              : Text("${finalData[index]['NameEn']}",
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                    //  fontWeight: FontWeight.bold,
                                  )),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Container(
              //   margin: const EdgeInsets.all(10.0),
              //   height: MediaQuery.of(context).size.height * .28,
              //   width: 150.0,
              //   child: Column(
              //     // mainAxisSize: MainAxisSize.min,
              //     // crossAxisAlignment: CrossAxisAlignment.start,
              //     children: <Widget>[
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: [
              //           Container(
              //             width: MediaQuery.of(context).size.width * .25,
              //             height: MediaQuery.of(context).size.height * .08,
              //             decoration: BoxDecoration(
              //                 image: DecorationImage(
              //                     image: finalData[index]['Photo'] != null
              //                         ? NetworkImage(
              //                             "${finalData[index]['Photo']}")
              //                         : placeholder)),
              //           ),
              //           // Container(
              //           //   decoration: BoxDecoration(
              //           //     //borderRadius: BorderRadius.circular(55.0),
              //           //     shape: BoxShape.circle,

              //           //     boxShadow: <BoxShadow>[
              //           //       BoxShadow(
              //           //           color: bluecolor,
              //           //           blurRadius: 2.0,
              //           //           spreadRadius: 1)
              //           //     ],
              //           //   ),
              //           //   child: finalData[index]['Photo'] == null
              //           //       ? placeholder
              //           //       : ClipRRect(
              //           //           borderRadius: BorderRadius.vertical(
              //           //             top: Radius.circular(85.0),
              //           //             bottom: Radius.circular(85.0),
              //           //           ),
              //           //           child: Image.network(
              //           //             finalData[index]['Photo'],
              //           //             width: 150.0,
              //           //             height: 150.0,
              //           //             fit: BoxFit.cover,
              //           //           ),
              //           //         ),
              //           // ),
              //         ],
              //       ),
              //       //  UIHelper.verticalSpaceSmall(),
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: [
              //           Flexible(
              //             child: lang == "Ar" && langChanged != "English"
              //                 ? Text(
              //                     finalData[index]['NameAr'],
              //                     textAlign: TextAlign.center,
              //                     maxLines: 1,
              //                     overflow: TextOverflow.clip,
              //                     style: TextStyle(
              //                       color: Colors.black,
              //                       fontSize: 16.0,
              //                       fontWeight: FontWeight.bold,
              //                     ),
              //                     // style: Theme.of(context).textTheme.subtitle2.copyWith(
              //                     //   fontSize: 14.0,
              //                     //   fontWeight: FontWeight.w600,
              //                     // ),
              //                   )
              //                 : Text("${finalData[index]['NameEn']}",
              //                     textAlign: TextAlign.center,
              //                     maxLines: 1,
              //                     overflow: TextOverflow.clip,
              //                     style: TextStyle(
              //                       color: Colors.black,
              //                       fontSize: 16.0,
              //                       fontWeight: FontWeight.bold,
              //                     )),
              //           ),
              //         ],
              //       ),
              //       // UIHelper.verticalSpaceExtraSmall(),
              //       // Text(
              //       //   foods[index].minutes,
              //       //   style: Theme.of(context).textTheme.bodyText1.copyWith(
              //       //     color: Colors.grey[700],
              //       //     fontSize: 13.0,
              //       //   ),
              //       // )
              //     ],
              //   ),
              // ),
            );
          },
        )
      ],
    );

    // Container(
    //     //   padding: EdgeInsets.all(6),
    //     height: MediaQuery.of(context).size.height * .35,
    //     width: MediaQuery.of(context).size.width,
    //     child:

    //     //  ListView.builder(
    //     //   shrinkWrap: true,
    //     //   scrollDirection: Axis.horizontal,
    //     //   itemCount: finalData?.length,
    //     //   itemBuilder: (context, index) =>
    //     //   InkWell(
    //     //     onTap: () {
    //     //       Navigator.push(
    //     //           context,
    //     //           MaterialPageRoute(
    //     //             builder: (context) => VendorsByDepartmentScreen(
    //     //                 id: finalData[index]['Id']),
    //     //           ));
    //     //     },
    //     //     child: Container(
    //     //       margin: const EdgeInsets.all(10.0),
    //     //       height: MediaQuery.of(context).size.height * .28,
    //     //       width: 150.0,
    //     //       child: Column(
    //     //         // mainAxisSize: MainAxisSize.min,
    //     //         // crossAxisAlignment: CrossAxisAlignment.start,
    //     //         children: <Widget>[
    //     //           Row(
    //     //             mainAxisAlignment: MainAxisAlignment.center,
    //     //             children: [
    //     //               Container(
    //     //                 decoration: BoxDecoration(
    //     //                   //borderRadius: BorderRadius.circular(55.0),
    //     //                   shape: BoxShape.circle,

    //     //                   boxShadow: <BoxShadow>[
    //     //                     BoxShadow(
    //     //                         color: bluecolor,
    //     //                         blurRadius: 2.0,
    //     //                         spreadRadius: 1)
    //     //                   ],
    //     //                 ),
    //     //                 child: finalData[index]['Photo'] == null
    //     //                     ? placeholder
    //     //                     : ClipRRect(
    //     //                         borderRadius: BorderRadius.vertical(
    //     //                           top: Radius.circular(85.0),
    //     //                           bottom: Radius.circular(85.0),
    //     //                         ),
    //     //                         child: Image.network(
    //     //                           finalData[index]['Photo'],
    //     //                           width: 150.0,
    //     //                           height: 150.0,
    //     //                           fit: BoxFit.cover,
    //     //                         ),
    //     //                       ),
    //     //               ),
    //     //             ],
    //     //           ),
    //     //           UIHelper.verticalSpaceSmall(),
    //     //           Row(
    //     //             mainAxisAlignment: MainAxisAlignment.center,
    //     //             children: [
    //     //               Flexible(
    //     //                 child: lang == "Ar" && langChanged != "English"
    //     //                     ? Text(
    //     //                         finalData[index]['NameAr'],
    //     //                         textAlign: TextAlign.center,
    //     //                         maxLines: 1,
    //     //                         overflow: TextOverflow.clip,
    //     //                         style: TextStyle(
    //     //                           color: Colors.black,
    //     //                           fontSize: 16.0,
    //     //                           fontWeight: FontWeight.bold,
    //     //                         ),
    //     //                         // style: Theme.of(context).textTheme.subtitle2.copyWith(
    //     //                         //   fontSize: 14.0,
    //     //                         //   fontWeight: FontWeight.w600,
    //     //                         // ),
    //     //                       )
    //     //                     : Text("${finalData[index]['NameEn']}",
    //     //                         textAlign: TextAlign.center,
    //     //                         maxLines: 1,
    //     //                         overflow: TextOverflow.clip,
    //     //                         style: TextStyle(
    //     //                           color: Colors.black,
    //     //                           fontSize: 16.0,
    //     //                           fontWeight: FontWeight.bold,
    //     //                         )),
    //     //               ),
    //     //             ],
    //     //           ),
    //     //           // UIHelper.verticalSpaceExtraSmall(),
    //     //           // Text(
    //     //           //   foods[index].minutes,
    //     //           //   style: Theme.of(context).textTheme.bodyText1.copyWith(
    //     //           //     color: Colors.grey[700],
    //     //           //     fontSize: 13.0,
    //     //           //   ),
    //     //           // )
    //     //         ],
    //     //       ),
    //     //     ),
    //     //   ),
    //     // ),

    //     );

    // return Container(
    //   margin: const EdgeInsets.all(10.0),
    //   width: double.infinity,
    //   child: Column(
    //     children: <Widget>[
    //       // Row(
    //       //   children: <Widget>[
    //       //     Icon(
    //       //       Icons.home_work,
    //       //       size: 28.0,
    //       //       color: Theme.of(context).primaryColor,
    //       //     ),
    //       //     UIHelper.horizontalSpaceSmall(),
    //       //     Text(
    //       //       translator.translate('Top Departments'),
    //       //       style: TextStyle(
    //       //         color: Colors.black,
    //       //         fontSize: 18.0,
    //       //         //fontWeight: FontWeight.bold,
    //       //       ),
    //       //       // style: Theme.of(context)
    //       //       //     .textTheme
    //       //       //     .headline4
    //       //       //     .copyWith(fontSize: 20.0,fontWeight: FontWeight.bold,),
    //       //     )
    //       //   ],
    //       // ),

    //       // UIHelper.verticalSpaceLarge(),
    //     ],
    //   ),
    // );
  }
}
