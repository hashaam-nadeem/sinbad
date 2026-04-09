import 'package:brqtrapp/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class API {
  static Future getCategory() {
    var url = APIConstants.API_BASE_URL_DEV + "/categories?DepartmentId=2";
    return http.get(url);
  }
}

// _getCat() {
//   API.getCategory().then((response) {
//     if(!mounted)return;
//     setState(() {
//       category = json.decode(response.body);
//       // category = list.map((model) => Category.fromJson(model)).toList();
//
//     });
//   });
// }