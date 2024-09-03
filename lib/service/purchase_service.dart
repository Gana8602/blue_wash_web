import 'dart:convert';

import 'package:blue_wash_web/config/config.dart';
import 'package:blue_wash_web/model/purchase_model.dart';
import 'package:http/http.dart' as http;

class PurchaseServce {
  Future<dynamic> fetchPurchased() async {
    var response =
        await http.get(Uri.parse("${config.base}${config.get_Purchase}"));
    var data = jsonDecode(response.body);
    if (data['status'] == "success") {
      print(data);
      print("purchased");
      List<dynamic> list = data['data'];
      List<PurchaseModel> purchaseData =
          list.map((e) => PurchaseModel.fromJson(e)).toList();
      return purchaseData;
    }
  }
}

class PurchaseServce2 {
  Future<dynamic> fetchPurchased() async {
    var response =
        await http.get(Uri.parse("${config.base}${config.get_Purchase2}"));
    var data = jsonDecode(response.body);
    if (data['status'] == "success") {
      print(data);
      print("purchased");
      List<dynamic> list = data['data'];
      List<PurchaseModel2> purchaseData =
          list.map((e) => PurchaseModel2.fromJson(e)).toList();
      return purchaseData;
    }
  }
}
