import 'dart:io';

import 'package:brqtrapp/screens/productcard.dart';
import 'package:brqtrapp/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animations/loading_animations.dart';
import 'package:loading_gifs/loading_gifs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'categoryrelatedproduct.dart';
import 'main_screen.dart';

class DepartmentCategories extends StatefulWidget {
  int id;
  DepartmentCategories({this.id});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _test();
  }
}

class _test extends State<DepartmentCategories> {
  int columnCount = 3;
  var lang;
  var langChanged;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Future getdepartmentCategories() async {
    // setState(() {
    //   _isLoading = true;
    // });

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    //var token = localStorage.getString('token');
    lang = localStorage.getString('selectedLanguage');
    langChanged = localStorage.getString('LangSelect');

    var url =
        "${APIConstants.API_BASE_URL_DEV + APIOperations.categorieslist}?DepartmentId=${widget.id}";
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text(
            "Department Categories",
          ),

          ///leading: Container(),
          leading: new IconButton(
              icon: Platform.isIOS
                  ? new Icon(Icons.arrow_back_ios)
                  : new Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          // actions: <Widget>[
          //   Stack(
          //     children: <Widget>[
          //       Column(
          //         children: [
          //           SizedBox(
          //             height: 10,
          //           ),
          //           Row(
          //             children: [
          //               GestureDetector(
          //                   onTap: () {
          //                     setState(() {
          //                       columnCount = 3;
          //                     });
          //                     print(columnCount);
          //                   },
          //                   child: Image.asset(
          //                     "images/grid.png",
          //                     color: Colors.white,
          //                     width: 30,
          //                     height: 30,
          //                     fit: BoxFit.cover,
          //                   )),
          //               SizedBox(
          //                 width: 10,
          //               ),
          //               GestureDetector(
          //                 onTap: () {
          //                   setState(() {
          //                     columnCount = 2;
          //                   });
          //                   print(columnCount);
          //                 },
          //                 child: Icon(
          //                   Icons.grid_view,
          //                   color: Colors.white,
          //                   size: 40,
          //                 ),
          //               ),
          //               SizedBox(
          //                 width: 10,
          //               ),
          //               GestureDetector(
          //                   onTap: () {
          //                     setState(() {
          //                       columnCount = 1;
          //                     });
          //                     print(columnCount);
          //                   },
          //                   child: Image.asset(
          //                     "images/list.png",
          //                     width: 30,
          //                     color: Colors.white,
          //                     height: 30,
          //                     fit: BoxFit.cover,
          //                   )),
          //               SizedBox(
          //                 width: 10,
          //               ),
          //             ],
          //           ),
          //         ],
          //       ),
          //     ],
          //   )

          // ],

          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0.0,
        ),
        body: FutureBuilder(
          future: getdepartmentCategories(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container(
                padding: EdgeInsets.all(10),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: GridView.builder(
                    itemCount: snapshot.data.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 2.0,
                      crossAxisSpacing: 8.0,
                      childAspectRatio: 1.5,
                      //childAspectRatio: 1 / 1,
                    ),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => CategoryProducts(
                                      id: snapshot.data[index]['CategoryId'],
                                      name: snapshot.data[index]['NameEn'],
                                      nameAr: snapshot.data[index]['NameAr'],
                                    )),
                          );
                        },
                        child: Container(
                            padding: EdgeInsets.all(2),
                            margin: EdgeInsets.only(top: 8, bottom: 10),
                            height: MediaQuery.of(context).size.height * .2,
                            width: MediaQuery.of(context).size.width * .32,
                            // height: MediaQuery.of(context).size.height *
                            //     .13,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                              image: DecorationImage(
                                image: snapshot.data[index]['Photo']
                                        .toString()
                                        .isNotEmpty
                                    ? NetworkImage(
                                        "${snapshot.data[index]['Photo']}")
                                    : AssetImage("images/women_shirt1.png"),
                                fit: BoxFit.cover,
                                colorFilter: new ColorFilter.mode(
                                    Colors.black.withOpacity(0.4),
                                    BlendMode.darken),
                              ),
                            ),
                            child: Center(
                                child: lang == "Ar" && langChanged != "English"
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
                                      ))),
                      );
                    }),
              );
            } else {
              return Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Center(
                    child: LoadingRotating.square(
                  borderColor: bluecolor,
                  backgroundColor: bluecolor,
                )),
              );
            }
          },
        ));
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
