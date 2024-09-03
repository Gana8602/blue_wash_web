// ignore_for_file: file_names

import 'package:blue_wash_web/pages/auth/login.dart';
import 'package:blue_wash_web/pages/home.dart';
import 'package:blue_wash_web/service/AuthService.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  var isPasswordVisible = false.obs;
  RxString userName = ''.obs;
  RxBool isLoading = false.obs;

  Future<void> login(String ident, String pass) async {
    var response = await AuthService().login(ident, pass);
    if (response == true) {
      Get.to(() => const MainPage());
    } else {
      Get.snackbar("Error", "Please Enter Correct Credentials");
    }
  }

  Future<void> register(String name, String email, String pass, String uname,
      String phone, String role) async {
    var response =
        await AuthService().reg(name, email, pass, uname, phone, role);
    if (response == true) {
      Get.to(() => const Login());
    } else {
      Get.snackbar("Error", "Something Went Wrong");
    }
  }
}
