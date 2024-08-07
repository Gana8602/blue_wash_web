import 'dart:convert';

import 'package:blue_wash_web/config/config.dart';
import 'package:blue_wash_web/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class EditStaff extends StatefulWidget {
  final String name;
  final String uName;
  final String email;
  final String phone;
  final String token;

  const EditStaff(
      {super.key,
      required this.name,
      required this.uName,
      required this.email,
      required this.token,
      required this.phone});

  @override
  State<EditStaff> createState() => _EditStaffState();
}

class _EditStaffState extends State<EditStaff> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _uname = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  bool isPass = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _name.text = widget.name;
    _uname.text = widget.uName;
    _email.text = widget.email;
    _phone.text = widget.phone;
    print(widget.token);
  }

  Future<void> _editStaff() async {
    var response =
        await http.post(Uri.parse("${config.base}${config.editStaff}"),
            body: jsonEncode({
              "token": widget.token,
              "name": _name.text,
              "username": _uname.text,
              "email": _email.text,
              "phone_number": _phone.text,
              "password": _pass.text,
            }));
    var data = jsonDecode(response.body);
    if (data["status"] == "success") {
      Navigator.pop(context, "update");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: 600,
        width: 550,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.black),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "Edit ${widget.name} Details",
                style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _textFil("Name", _name, false),
                  SizedBox(
                    height: 15,
                  ),
                  _textFil("User name", _uname, false),
                  SizedBox(
                    height: 15,
                  ),
                  _textFil("Phone number", _phone, false),
                  SizedBox(
                    height: 15,
                  ),
                  _textFil("Email", _email, false),
                  SizedBox(
                    height: 15,
                  ),
                  _textFil("Password", _pass, true),
                  SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                      width: 100,
                      child: ButtonBlue2(
                          text: "Update",
                          ontap: () {
                            _editStaff();
                          }))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _textFil(String title, TextEditingController cont, bool ispass) {
    return TextFormField(
      controller: cont,
      style: TextStyle(color: Colors.white),
      obscureText: ispass && isPass,
      decoration: InputDecoration(
        suffixIcon: ispass
            ? InkWell(
                onTap: () {
                  setState(() {
                    isPass = !isPass;
                    print("object");
                  });
                },
                child: Icon(
                  isPass ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white,
                ),
              )
            : null,
        label: Text(title),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white70),
          borderRadius: BorderRadius.circular(20),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white54),
          borderRadius: BorderRadius.circular(20.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white54),
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
    );
  }
}
