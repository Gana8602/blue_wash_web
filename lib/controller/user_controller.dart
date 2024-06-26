import 'dart:convert';

import 'package:blue_wash_web/config/config.dart';
import 'package:blue_wash_web/model/user_model.dart';
import 'package:blue_wash_web/service/user_service.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class UserController extends GetxController {
  var users = <Users>[].obs;

  Future<void> getData() async {
    var response = await UserService().fetchUsers();
    if (response != null && response is List<Users>) {
      users.assignAll(response);
    } else {
      users.assignAll([]);
    }
  }
}
