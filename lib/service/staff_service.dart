import 'dart:convert';

import 'package:blue_wash_web/config/config.dart';
import 'package:blue_wash_web/model/staffs_model.dart';
import 'package:http/http.dart' as http;

class StaffService {
  Future<dynamic> fetchStaff() async {
    var response = await http.get(Uri.parse("${config.base}${config.staffs}"));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List<dynamic> list = data['data'];
      List<StaffModel> Staff = list.map((e) => StaffModel.fromJson(e)).toList();
      return Staff;
    }
  }
}
