import 'dart:convert';

import 'package:blue_wash_web/config/config.dart';
import 'package:blue_wash_web/model/packages_model.dart';
import 'package:http/http.dart' as http;

class PackageService {
  Future<dynamic> getPackages() async {
    var response =
        await http.get(Uri.parse("${config.base}${config.packages}"));

    var data = jsonDecode(response.body);
    if (data['status'] == 'success') {
      List<dynamic> list = data['data'];
      List<Packages> PAck = list.map((e) => Packages.fromJson(e)).toList();
      return PAck;
    } else {
      return null;
    }
  }
}
