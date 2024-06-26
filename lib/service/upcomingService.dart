import 'dart:convert';

import 'package:blue_wash_web/config/config.dart';
import 'package:blue_wash_web/model/upcomingModel.dart';
import 'package:http/http.dart' as http;

class UpcomingService {
  Future<dynamic> getupcoming() async {
    var response =
        await http.get(Uri.parse("${config.base}${config.upcomings}"));
    var data = jsonDecode(response.body);
    if (data['status'] == 'success') {
      List<dynamic> list = data['data'];
      List<UpcomingModel> upcoming =
          list.map((e) => UpcomingModel.fromJson(e)).toList();
      return upcoming;
    } else {
      return null;
    }
  }
}
