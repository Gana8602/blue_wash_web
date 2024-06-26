import 'dart:convert';

import 'package:blue_wash_web/config/config.dart';
import 'package:blue_wash_web/model/purchase_model.dart';
import 'package:http/http.dart' as http;

class PurchaseServce {
  Future<dynamic> fetchPurchased() async {
    var response =
        await http.get(Uri.parse("${config.base}${config.get_Purchase}"));
    var data = jsonDecode(response.body);
    print(data);
    if (data['status'] == "success") {
      List<dynamic> list = data['data'];
      List<PurchaseModel> purchaseData =
          list.map((e) => PurchaseModel.fromJson(e)).toList();
      return purchaseData;
    }
  }
}
