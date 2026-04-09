import 'dart:io';

import 'package:brqtrapp/screens/productcard.dart';
import 'package:brqtrapp/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animations/loading_animations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'main_screen.dart';

class CategoryProducts extends StatefulWidget {
  int id;
  String name;
  int page = 1;
  String nameAr;
  CategoryProducts({this.id, this.nameAr, this.name});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _test();
  }
}

class _test extends State<CategoryProducts> {
  int columnCount = 2;
  var lang;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  int subId;
  int page = 1;
  bool filter = false;
  bool subCategory = false;
  var langChanged;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Future getSubCategories() async {
    // setState(() {
    //   _isLoading = true;
    // });

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    //var token = localStorage.getString('token');
    lang = localStorage.getString('selectedLanguage');
    langChanged = localStorage.getString('LangSelect');

    var url =
        "${APIConstants.API_BASE_URL_DEV + APIOperations.subCategoryList}?CategoryId=${widget.id}";
    Map<String, String> requestHeaders = {
      //'Content-type': 'application/json',
      //'Accept': 'application/json',
      'x-api-key': '987654',
      //'Authorization': 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjZmMjc2ZGU3YTI1YWE3MDlmOTdiYjcwZDllODY3ZGNjNzllNWRjMzJmOGZlZjNlNWQ1YzhlMzM5YTU5ZjMyNTU2YWNlZWM1YTdlZDc3MjY0In0.eyJhdWQiOiIyIiwianRpIjoiNmYyNzZkZTdhMjVhYTcwOWY5N2JiNzBkOWU4NjdkY2M3OWU1ZGMzMmY4ZmVmM2U1ZDVjOGUzMzlhNTlmMzI1NTZhY2VlYzVhN2VkNzcyNjQiLCJpYXQiOjE1ODA1NDM5ODUsIm5iZiI6MTU4MDU0Mzk4NSwiZXhwIjoxNjEyMTY2Mzg1LCJzdWIiOiIxMzIiLCJzY29wZXMiOltdfQ.h33_EIU37oXVwrBR3bU6Y7NzyoM4m1wue-09NkDOh4AEimZ9mjjoqxU2fvGEZ_Bo-o6sE5hNg_84bJ-WctedsnoEdwNSPt1O_1SWIrIFhyU5vvv1i9HyBIKx_l4uZLcC-C52TxxvO2awQrrDHPxcbAsyqqa7Z3jh02dAN91r-6Oe0XaH6OV-FabwSMdsWh028GxuIzJwATfHA_zPfDtIquG1TBLc7Q9cFOzlio7IOy3tOLCxVL4f_vt-aOwVF0C0M_eTgk8znI7nTpWk3TgKN_OjRegxbkSGXrS59SIMNZUhMBI1j1vmzSFmRlpEZ8vj5csFxnmTv9oT5tLviD06y8TIISHifpUMI4z2o4rg_qFQbHTAkf37pw2TCfsbzL5sIWMFwWNvbpeKmplurcsnqbzcXl7STqrHftWEwxz6a4Cjrt2fCcxWAkS3CzraANhMkDFuS9oaRqLGfGsZytOZVLTYzQi3HanEip_NqhtEDLhkiEZ6LSJg9CSkk9q9gjruM3zs-l_GijkwJZpdgHwb06SXQb1hF8sS-pcXMwKHU-nF9zKoYZYjodSLaawFtNleylQqZO1mg9gK0XEoMHqm1NXdJH54mqSjoIKmDtKPbmGINzERRB6Cls0pHjC5Z82JBZ9g7xwmOJbMGdN7i2rZhOzs4Mq-eT85nsP2-SNPiJE'
    };
    final response = await http.get(url, headers: requestHeaders);
    //final List<FavoriteItem> favProducts = [];
    print("all category Productlist: ${json.decode(response.body)}");
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

  Future getdepartmentCategories() async {
    // setState(() {
    //   _isLoading = true;
    // });

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    //var token = localStorage.getString('token');
    lang = localStorage.getString('selectedLanguage');
    langChanged = localStorage.getString('LangSelect');
    var url = subCategory == true
        ? "${APIConstants.API_BASE_URL_DEV + APIOperations.categoriesProductlist}?SubCategoryId=$subId&CurrentPage=0&NextPage=$page"
        : "${APIConstants.API_BASE_URL_DEV + APIOperations.categoriesProductlist}?CategoryId=${widget.id}&CurrentPage=0&NextPage=$page";
    print("url called: $url");
    Map<String, String> requestHeaders = {
      //'Content-type': 'application/json',
      //'Accept': 'application/json',
      'x-api-key': '987654',
      //'Authorization': 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjZmMjc2ZGU3YTI1YWE3MDlmOTdiYjcwZDllODY3ZGNjNzllNWRjMzJmOGZlZjNlNWQ1YzhlMzM5YTU5ZjMyNTU2YWNlZWM1YTdlZDc3MjY0In0.eyJhdWQiOiIyIiwianRpIjoiNmYyNzZkZTdhMjVhYTcwOWY5N2JiNzBkOWU4NjdkY2M3OWU1ZGMzMmY4ZmVmM2U1ZDVjOGUzMzlhNTlmMzI1NTZhY2VlYzVhN2VkNzcyNjQiLCJpYXQiOjE1ODA1NDM5ODUsIm5iZiI6MTU4MDU0Mzk4NSwiZXhwIjoxNjEyMTY2Mzg1LCJzdWIiOiIxMzIiLCJzY29wZXMiOltdfQ.h33_EIU37oXVwrBR3bU6Y7NzyoM4m1wue-09NkDOh4AEimZ9mjjoqxU2fvGEZ_Bo-o6sE5hNg_84bJ-WctedsnoEdwNSPt1O_1SWIrIFhyU5vvv1i9HyBIKx_l4uZLcC-C52TxxvO2awQrrDHPxcbAsyqqa7Z3jh02dAN91r-6Oe0XaH6OV-FabwSMdsWh028GxuIzJwATfHA_zPfDtIquG1TBLc7Q9cFOzlio7IOy3tOLCxVL4f_vt-aOwVF0C0M_eTgk8znI7nTpWk3TgKN_OjRegxbkSGXrS59SIMNZUhMBI1j1vmzSFmRlpEZ8vj5csFxnmTv9oT5tLviD06y8TIISHifpUMI4z2o4rg_qFQbHTAkf37pw2TCfsbzL5sIWMFwWNvbpeKmplurcsnqbzcXl7STqrHftWEwxz6a4Cjrt2fCcxWAkS3CzraANhMkDFuS9oaRqLGfGsZytOZVLTYzQi3HanEip_NqhtEDLhkiEZ6LSJg9CSkk9q9gjruM3zs-l_GijkwJZpdgHwb06SXQb1hF8sS-pcXMwKHU-nF9zKoYZYjodSLaawFtNleylQqZO1mg9gK0XEoMHqm1NXdJH54mqSjoIKmDtKPbmGINzERRB6Cls0pHjC5Z82JBZ9g7xwmOJbMGdN7i2rZhOzs4Mq-eT85nsP2-SNPiJE'
    };
    final response = await http.get(url, headers: requestHeaders);
    //final List<FavoriteItem> favProducts = [];
    print("all category Productlist: ${json.decode(response.body)}");
    var jsonData = json.decode(response.body);
    _refreshController.loadComplete();
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        key: _scaffoldKey,
        bottomSheet: filter == true ? customSheet() : null,
        appBar: filter == true
            ? AppBar(
                centerTitle: true,
                automaticallyImplyLeading: false,
                title: Text(
                  "Filter",
                ),

                ///leading: Container(),
                leading: new IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      setState(() {
                        filter = false;
                      });
                    }),
                // actions: <Widget>[
                //   Row(
                //     mainAxisAlignment: MainAxisAlignment.end,
                //     children: [
                //       GestureDetector(
                //           onTap: () {
                //             setState(() {
                //               columnCount = 3;
                //               filter = false;
                //             });
                //             print(columnCount);
                //           },
                //           child: Image.asset(
                //             "images/grid.png",
                //             color: Colors.white,
                //             width: 30,
                //             height: 30,
                //             fit: BoxFit.cover,
                //           )),
                //       SizedBox(
                //         width: 10,
                //       ),
                //       GestureDetector(
                //         onTap: () {
                //           setState(() {
                //             columnCount = 2;
                //             filter = false;
                //           });
                //           print(columnCount);
                //         },
                //         child: Icon(
                //           Icons.grid_view,
                //           color: Colors.white,
                //           size: 40,
                //         ),
                //       ),
                //       SizedBox(
                //         width: 10,
                //       ),
                //       GestureDetector(
                //           onTap: () {
                //             setState(() {
                //               columnCount = 1;
                //               filter = false;
                //             });

                //             print(columnCount);
                //           },
                //           child: Image.asset(
                //             "images/list.png",
                //             width: 30,
                //             color: Colors.white,
                //             height: 30,
                //             fit: BoxFit.cover,
                //           )),
                //     ],
                //   ),
                // ],

                backgroundColor: lightblue,
                elevation: 0.0,
              )
            : AppBar(
                centerTitle: true,
                automaticallyImplyLeading: false,
                title: Text(
                  "",
                ),

                ///leading: Container(),
                leading: new IconButton(
                    icon: Platform.isIOS
                        ? new Icon(Icons.arrow_back_ios)
                        : new Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                actions: <Widget>[
                  Stack(
                    children: <Widget>[
                      Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    columnCount = 2;
                                    filter = false;
                                  });
                                  print(columnCount);
                                },
                                child: Icon(
                                  Icons.grid_view,
                                  color: Colors.white,
                                  size: 40,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      columnCount = 1;
                                      filter = false;
                                    });

                                    print(columnCount);
                                  },
                                  child: Image.asset(
                                    "images/list.png",
                                    width: 30,
                                    color: Colors.white,
                                    height: 30,
                                    fit: BoxFit.cover,
                                  )),
                              SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      filter = true;
                                    });
                                    print(columnCount);
                                  },
                                  child: Icon(FontAwesomeIcons.filter)),
                              SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  )
                ],

                backgroundColor: Theme.of(context).primaryColor,
                elevation: 0.0,
              ),
        body: FutureBuilder(
            future: getdepartmentCategories(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: SmartRefresher(
                    controller: _refreshController,
                    enablePullUp: true,
                    enablePullDown: false,
                    onLoading: () {
                      print("hellow testing 123");
                      setState(() {
                        page = page + 1;
                      });
                      print("Page Increment: $page");
                      getdepartmentCategories();
                    },
                    child: AnimationLimiter(
                        child: GridView.count(
                      crossAxisCount: columnCount,
                      shrinkWrap: true,
                      childAspectRatio: columnCount == 1 ? 1.6 : 0.65,
                      physics: BouncingScrollPhysics(),
                      //childAspectRatio: 1 / 1,
                      children: List.generate(
                        snapshot.data.length,
                        (int index) {
                          return AnimationConfiguration.staggeredGrid(
                            position: index,
                            duration: const Duration(milliseconds: 180),
                            columnCount: columnCount,
                            child: ScaleAnimation(
                              scale: 12,
                              child: FadeInAnimation(
                                child: Product(
                                  index: index,
                                  snapshot: snapshot,
                                  columnCount: columnCount,
                                  lang: lang,
                                  langChanged: langChanged,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )),
                  ),
                );
                ;
              } else {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * .8,
                  child: Center(
                      child: LoadingRotating.square(
                    borderColor: bluecolor,
                    backgroundColor: bluecolor,
                  )),
                );
              }
            }));
  }

  Widget customSheet() {
    return FutureBuilder(
        future: getSubCategories(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.all(10),
              color: bluecolor,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              filter = false;
                              subCategory = false;
                              //subId = snapshot.data[index]['SubCategoryId'];
                            });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * .9,
                            height: MediaQuery.of(context).size.height * .08,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    lang == "Ar" && langChanged != "English"
                                        ? Text(
                                            "${widget.nameAr}",
                                            overflow: TextOverflow.clip,
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          )
                                        : Text(
                                            "${widget.name}",
                                            overflow: TextOverflow.clip,
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                    Icon(
                                      FontAwesomeIcons.arrowDown,
                                      color: Colors.black,
                                      size: 20,
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Divider(
                                  color: orangecolor,
                                  height: 1,
                                  thickness: 6,
                                ),
                              ],
                            ),
                          ))
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                              onTap: () {
                                setState(() {
                                  page = 1;
                                  filter = false;
                                  subCategory = true;
                                  subId = snapshot.data[index]['SubCategoryId'];
                                });
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * .08,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        lang == "Ar" && langChanged != "English"
                                            ? Text(
                                                "${snapshot.data[index]['NameAr']}",
                                                overflow: TextOverflow.clip,
                                                textAlign: TextAlign.center,
                                                maxLines: 2,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                ),
                                              )
                                            : Text(
                                                "${snapshot.data[index]['NameEn']}",
                                                overflow: TextOverflow.clip,
                                                textAlign: TextAlign.center,
                                                maxLines: 2,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                ),
                                              ),
                                        // Icon(
                                        //   Icons.arrow_forward_ios,
                                        //   color: Colors.white,
                                        //   size: 20,
                                        // )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Divider(
                                      color: orangecolor,
                                      height: 1,
                                      thickness: 3,
                                    ),
                                  ],
                                ),
                              ));
                        }),
                  ),
                ],
              ),
            );
          } else {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Center(
                  child: LoadingRotating.square(
                borderColor: bluecolor,
                backgroundColor: bluecolor,
              )),
            );
          }
        });
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.music_note),
                    title: new Text('Music'),
                    onTap: () => {}),
                new ListTile(
                  leading: new Icon(Icons.videocam),
                  title: new Text('Video'),
                  onTap: () => {},
                ),
              ],
            ),
          );
        });
  }
}
