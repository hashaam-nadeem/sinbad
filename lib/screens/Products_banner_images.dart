import 'dart:convert';
import 'package:brqtrapp/utils/constant.dart';
import 'package:brqtrapp/utils/zoomimage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:http/http.dart' as http;
//import 'package:Salwa_garden/utils/constant.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

    var url = APIConstants.API_BASE_URL_DEV + "productDetails?ProductId=$id";
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
    final bannerImgData = sliderData['Data']['Photo'];
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
      images = bannerData;
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
      child: isLoading
          ? _buildProgressIndicator()
          : Container(
              margin: const EdgeInsets.symmetric(vertical: 0.0),
              height: MediaQuery.of(context).size.height * .58,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Swiper(
                onTap: (index) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ZoomImage(image: images[index]['Photo'])));
                },
                itemHeight: MediaQuery.of(context).size.height * .3,
                duration: 1000,
                itemWidth: double.infinity,
                pagination: SwiperPagination(),
                itemCount: images?.length,
                itemBuilder: (BuildContext context, int index) => Image.network(
                  images[index]['Photo'],
                  fit: BoxFit.cover,
                ),
                autoplay: false,
                viewportFraction: 1.0,
                scale: 0.2,
              ),
            ),
      // onTap: () {
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => ZoomImage(
      //         image: images[index]['Photo'],
      //       ),
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
