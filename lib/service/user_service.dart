import 'dart:convert';

import 'package:blue_wash_web/config/config.dart';
import 'package:http/http.dart' as http;

import '../model/user_model.dart';

class UserService {
  Future<dynamic> fetchUsers() async {
    var url = Uri.parse("${config.base}${config.users}");

    var response = await http.get(url);
    print(response.body);
    var data = jsonDecode(response.body);

    List<dynamic> list = data;
    List<Users> users = list.map((e) => Users.fromJson(e)).toList();
    return users;
  }
}
