import 'package:blue_wash_web/config/config.dart';
import 'package:blue_wash_web/controller/Staffs_controller.dart';
import 'package:blue_wash_web/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddStaffPage extends StatefulWidget {
  const AddStaffPage({super.key});
  @override
  _AddStaffPageState createState() => _AddStaffPageState();
}

class _AddStaffPageState extends State<AddStaffPage> {
  StaffController _staff = Get.put(StaffController());
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String username = '';
  String password = '';
  String phoneNumber = '';
  String email = "";
  bool visible = true;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Generate a token (example: using a simple UUID for demo purposes)
      String token = DateTime.now().millisecondsSinceEpoch.toString();

      // Create the payload for the API
      Map<String, String> payload = {
        'name': name,
        'username': username,
        'password': password,
        'token': token,
        'phone_number': phoneNumber,
        'email': email
      };

      // Send the data to the API
      final response = await http.post(
        Uri.parse('${config.base}${config.staffsAdd}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        _staff.staffs.clear();
        // Handle success
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Staff added successfully')),
          );
          _formKey.currentState!.reset();
          Get.back();
          _staff.fetchStaffs();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text('Failed to add staff: ${responseData['message']}')),
          );
        }
      } else {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add staff')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 500,
        height: 550,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.white24, offset: Offset(0, 3), blurRadius: 3),
            ],
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.black),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Staff Add Form",
                  style: GoogleFonts.montserrat(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: _decoration("Staff Name"),
                  style: TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    name = value!;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: _decoration('Username'),
                  style: TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a username';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    username = value!;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: _decoration2('Password'),
                  style: TextStyle(color: Colors.white),
                  obscureText: visible,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    password = value!;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: _decoration('Phone Number'),
                  style: TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a phone number';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    phoneNumber = value!;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: _decoration('email'),
                  style: TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a email';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    email = value!;
                  },
                ),
                SizedBox(height: 20),
                ButtonBlue2(
                  ontap: _submitForm,
                  text: "Add Staff",
                )
                // ElevatedButton(
                //   onPressed: _submitForm,
                //   child: Text('Add Staff'),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _decoration(String name) {
    return InputDecoration(
        labelText: name,
        labelStyle: TextStyle(color: Colors.white54),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white54),
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white54),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white54),
          borderRadius: BorderRadius.circular(10.0),
        ));
  }

  InputDecoration _decoration2(String name) {
    return InputDecoration(
        suffixIcon: IconButton(
          icon: Icon(!visible ? Icons.visibility_off : Icons.visibility),
          onPressed: () {
            setState(() {
              visible = !visible;
            });
          },
        ),
        labelText: name,
        labelStyle: TextStyle(color: Colors.white54),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white54),
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white54),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white54),
          borderRadius: BorderRadius.circular(10.0),
        ));
  }
}
