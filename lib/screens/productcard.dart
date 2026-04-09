import 'package:brqtrapp/screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Product extends StatelessWidget {
  int index;
  var lang;
  int columnCount;
  var langChanged;
  AsyncSnapshot snapshot;
  Product(
      {this.index,
      this.columnCount,
      this.snapshot,
      this.lang,
      this.langChanged});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: () async {
        SharedPreferences localStorage = await SharedPreferences.getInstance();

        var customerId = localStorage.getString('userID');
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetailScreen(
                      id: snapshot.data[index]['Id'],
                      titleAr: snapshot.data[index]['NameAr'],
                      title: snapshot.data[index]['NameEn'],
                      price: snapshot.data[index]['Price'],
                      description: snapshot.data[index]['DescriptionEn'],
                      descriptionAr: snapshot.data[index]['DescriptionAr'],
                      shortDes: snapshot.data[index]['ShortDescriptionEn'],
                      shortDesAr: snapshot.data[index]['ShortDescriptionAr'],
                      userId: customerId,
                      vendorId: snapshot.data[index]['VendorId'],
                      inStock: snapshot.data[index]['StockStatus'],
                      // nameEN: finalData[index]['NameEn'],
                      // nameAR: finalData[index]['NameAr'],
                      // vendorLogo: finalData[index]['Photo'],
                    )));
      },
      child: Container(
          margin: EdgeInsets.all(12),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * .15,
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
                    width: columnCount == 2
                        ? MediaQuery.of(context).size.width * .42
                        : MediaQuery.of(context).size.width * .9,
                    height: columnCount == 2
                        ? MediaQuery.of(context).size.height * .25
                        : MediaQuery.of(context).size.height * .19,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        // boxShadow: <BoxShadow>[
                        //   BoxShadow(
                        //     color: Colors.black12,
                        //     blurRadius: 2.0,
                        //   ),
                        // ],
                        image: DecorationImage(
                            image: NetworkImage(
                              "${snapshot.data[index]['Photo']}",
                            ),
                            colorFilter: new ColorFilter.mode(
                                Colors.grey.withOpacity(0.4), BlendMode.darken),
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
                height: 3,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: lang == "Ar" && langChanged != "English"
                        ? Text(
                            snapshot.data[index]['NameAr'],
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                              //  fontWeight: FontWeight.bold,
                            ),
                            // style: Theme.of(context).textTheme.subtitle2.copyWith(
                            //   fontSize: 14.0,
                            //   fontWeight: FontWeight.w600,
                            // ),
                          )
                        : Text(
                            snapshot.data[index]['NameEn'],
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                              //   fontWeight: FontWeight.bold,
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
                            "${translator.translate('Price')}: ${snapshot.data[index]['Price']}",
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                              //   fontWeight: FontWeight.bold,
                            ),
                            // style: Theme.of(context).textTheme.subtitle2.copyWith(
                            //   fontSize: 14.0,
                            //   fontWeight: FontWeight.w600,
                            // ),
                          )
                        : Text(
                            "${translator.translate('Price')}: ${snapshot.data[index]['Price']}",
                            textAlign: TextAlign.center,
                            maxLines: 2,
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
                          ),
                  )
                ],
              ),
            ],
          )

          // Column(
          //   mainAxisSize: MainAxisSize.min,
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: <Widget>[
          //     Row(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         Container(
          //           width: MediaQuery.of(context).size.width * .25,
          //           height: MediaQuery.of(context).size.height * .12,
          //           decoration: BoxDecoration(
          //               borderRadius:
          //                   BorderRadius.all(Radius.circular(16)),
          //               boxShadow: <BoxShadow>[
          //                 BoxShadow(
          //                   color: Colors.black12,
          //                   blurRadius: 2.0,
          //                 ),
          //               ],
          //               image: DecorationImage(
          //                   image: NetworkImage(
          //                     "${finalData[index]['Photo']}",
          //                   ),
          //                   fit: BoxFit.fitWidth)),
          //           // child: Center(
          //           //   child: Image.network(

          //           //     width:
          //           //         MediaQuery.of(context).size.width * .29,
          //           //     height:
          //           //         MediaQuery.of(context).size.height * .14,
          //           //     fit: BoxFit.contain,
          //           //   ),
          //           // )
          //         ),
          //       ],
          //     ),
          //     UIHelper.verticalSpaceSmall(),
          //     Row(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         Flexible(
          //           child: lang == "Ar" && langChanged != "English"
          //               ? Text(
          //                   finalData[index]['NameAr'],
          //                   maxLines: 2,
          //                   textAlign: TextAlign.center,
          //                   overflow: TextOverflow.clip,
          //                   style: TextStyle(
          //                     color: Colors.white,
          //                     fontSize: 20.0,
          //                     fontWeight: FontWeight.bold,
          //                   ),
          //                   // style: Theme.of(context).textTheme.subtitle2.copyWith(
          //                   //   fontSize: 14.0,
          //                   //   fontWeight: FontWeight.w600,
          //                   // ),
          //                 )
          //               : Text(
          //                   finalData[index]['NameEn'],
          //                   textAlign: TextAlign.center,
          //                   maxLines: 2,
          //                   overflow: TextOverflow.clip,
          //                   style: TextStyle(
          //                     color: Colors.white,
          //                     fontSize: 18.0,
          //                     fontWeight: FontWeight.bold,
          //                   ),
          //                   // style: Theme.of(context).textTheme.subtitle2.copyWith(
          //                   //   fontSize: 14.0,
          //                   //   fontWeight: FontWeight.w600,
          //                   // ),
          //                 ),
          //         ),
          //       ],
          //     ),
          //     UIHelper.verticalSpaceExtraSmall(),
          //     // Text(
          //     //   foods[index].minutes,
          //     //   style: Theme.of(context).textTheme.bodyText1.copyWith(
          //     //     color: Colors.grey[700],
          //     //     fontSize: 13.0,
          //     //   ),
          //     // )
          //   ],
          // ),
          ),
    );

    // Container(
    //     margin: EdgeInsets.all(12),
    //     width: MediaQuery.of(context).size.width,
    //     height: MediaQuery.of(context).size.height * .15,
    //     decoration: BoxDecoration(
    //       color: Colors.white,
    //       borderRadius: BorderRadius.all(Radius.circular(12)),
    //       image: DecorationImage(
    //         image: snapshot.data[index]['Photo'] != null
    //             ? NetworkImage(snapshot.data[index]['Photo'])
    //             : AssetImage("images/women_shirt1.png"),
    //         fit: BoxFit.cover,
    //         colorFilter: new ColorFilter.mode(
    //             Colors.black.withOpacity(0.4), BlendMode.darken),
    //       ),
    //     ),
    //     child: Center(
    //         child: lang == "Ar" && langChanged != "English"
    //             ? Text(
    //                 "${snapshot.data[index]['NameAr']}",
    //                 overflow: TextOverflow.clip,
    //                 textAlign: TextAlign.center,
    //                 maxLines: 2,
    //                 style: TextStyle(
    //                   color: Colors.white,
    //                   fontSize: 14,
    //                 ),
    //               )
    //             : Text(
    //                 "${snapshot.data[index]['NameEn']}",
    //                 overflow: TextOverflow.clip,
    //                 textAlign: TextAlign.center,
    //                 maxLines: 2,
    //                 style: TextStyle(
    //                   color: Colors.white,
    //                   fontSize: 14,
    //                 ),
    //               ))));
  }
}
