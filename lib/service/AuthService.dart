import 'dart:convert';

import 'package:blue_wash_web/config/config.dart';
import 'package:blue_wash_web/config/value.dart';
import 'package:http/http.dart' as http;

class AuthService {
  Future<bool> login(String identify, String pass) async {
    var response = await http.post(Uri.parse("${config.base}${config.login}"),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'username_or_email': identify, 'password': pass}));
    var data = jsonDecode(response.body);
    print(data);
    if (response.statusCode == 200) {
      var user = data['user'];
      Valuess.username = user['username'];
      Valuess.email = user['email'];
      Valuess.Name = user['name'];
      Valuess.phone = user['phone_number'];
      Valuess.role = user['role'];
      Valuess.token = user['token'];
      Valuess.image = user['profile'];
      return data['status'];
    } else {
      return false;
    }
  }

  Future<bool> reg(String name, String email, String pass, String uname,
      String phone, String role) async {
    var response = await http.post(Uri.parse("${config.base}${config.reg}"),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': uname,
          'password': pass,
          'name': name,
          'phone_number': phone,
          'email': email,
          'role': role,
        }));
    var data = jsonDecode(response.body);
    print(data);
    if (response.statusCode == 200) {
      return data['status'];
    } else {
      return false;
    }
  }
}
