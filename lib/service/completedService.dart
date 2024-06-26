import 'dart:convert';

import 'package:blue_wash_web/config/config.dart';
import 'package:blue_wash_web/model/completedModel.dart';
import 'package:http/http.dart' as http;

class CompletedService {
  Future<dynamic> getCompleted() async {
    var response =
        await http.get(Uri.parse("${config.base}${config.completed}"));
    var data = jsonDecode(response.body);
    print(data);
    if (data['status'] == 'success') {
      List<dynamic> list = data['data'];
      List<CompletedModel> complete =
          list.map((e) => CompletedModel.fromJson(e)).toList();
      return complete;
    } else {
      return null;
    }
  }
}
