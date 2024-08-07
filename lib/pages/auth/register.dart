import 'package:blue_wash_web/pages/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controller/AuthController.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthController authController = Get.put(AuthController());
  final TextEditingController _name = TextEditingController();
  final TextEditingController _uname = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  bool isinventorychecked = false;
  bool isproManagechecked = false;
  String? inventory;
  String? project;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: Colors.black),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            constraints: const BoxConstraints(maxWidth: 400, maxHeight: 700),
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: SizedBox(
                        height: 70,
                        child: Image.asset(
                          'assets/logo.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Text(
                      'Register',
                      style: GoogleFonts.roboto(
                          fontSize: 30, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Row(
                  children: [
                    CustomText(
                      text: "Enter Your Details Please",
                      color: Color(0xFFA4A6B3),
                    )
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                TextField(
                  controller: _name,
                  decoration: InputDecoration(
                      labelText: "Name",
                      hintText: "John",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextField(
                  controller: _uname,
                  decoration: InputDecoration(
                      labelText: "userName",
                      hintText: "John Rick",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextField(
                  controller: _phone,
                  decoration: InputDecoration(
                      labelText: "Phone",
                      hintText: "9876543210",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextField(
                  controller: _email,
                  decoration: InputDecoration(
                      labelText: "Email",
                      hintText: "abc@domain.com",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
                const SizedBox(
                  height: 15,
                ),
                Obx(
                  () => TextField(
                    obscureText: !authController.isPasswordVisible.value,
                    controller: _password,
                    decoration: InputDecoration(
                      labelText: "Password",
                      hintText: "Case Sensitive",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      suffixIcon: IconButton(
                        icon: Icon(
                          color: Colors.grey,
                          authController.isPasswordVisible.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          authController.isPasswordVisible.value =
                              !authController.isPasswordVisible.value;
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const SizedBox(
                  height: 15,
                ),
                InkWell(
                  onTap: () {
                    if (_name.text.isNotEmpty &&
                        _uname.text.isNotEmpty &&
                        _email.text.isNotEmpty &&
                        _password.text.isNotEmpty &&
                        _phone.text.isNotEmpty) {
                      authController.register(_name.text, _email.text,
                          _password.text, _uname.text, _phone.text, "Admin");
                    } else {
                      Get.snackbar("Error", "Please fill all data");
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 33, 181, 250),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.center,
                    width: double.maxFinite,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: const CustomText(
                      text: "Create Account",
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text(
                      "Back to Login",
                      style: GoogleFonts.roboto(color: Colors.blueAccent),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
