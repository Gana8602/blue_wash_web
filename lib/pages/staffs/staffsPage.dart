import 'dart:convert';

import 'package:blue_wash_web/config/config.dart';
import 'package:blue_wash_web/controller/Staffs_controller.dart';
import 'package:blue_wash_web/model/staffs_model.dart';
import 'package:blue_wash_web/pages/staffs/edit_staff.dart';
import 'package:blue_wash_web/pages/staffs/staffs_add.dart';
import 'package:blue_wash_web/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../../utls/colors.dart';

class StaffsPage extends StatefulWidget {
  const StaffsPage({super.key});

  @override
  State<StaffsPage> createState() => _StaffsPageState();
}

class _StaffsPageState extends State<StaffsPage> {
  StaffController _staff = Get.put(StaffController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _staff.fetchStaffs();
  }

  @override
  Widget build(BuildContext context) {
    List<StaffModel> staffs = _staff.staffs;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      "Staffs",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.white),
                    ),
                    Spacer(),
                    ButtonBlue2(
                        text: "Add Staff",
                        ontap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AddStaffPage();
                              });
                        })
                  ],
                ),
              ),
              Expanded(
                  child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Ac.bNcolor),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: LayoutBuilder(builder:
                      (BuildContext context, BoxConstraints constraints) {
                    return Container(
                        width: constraints.maxWidth * 2.3,
                        child: Obx(() {
                          if (_staff.staffs.isEmpty) {
                            return Center(child: CircularProgressIndicator());
                          }
                          int count = 1;
                          return DataTable(
                            dataRowHeight: 60,
                            columns: [
                              DataColumn(
                                  label: Text(
                                "ID",
                                style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.white70),
                              )),
                              DataColumn(
                                  label: Text(
                                "Profile",
                                style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.white70),
                              )),
                              DataColumn(
                                  label: Text(
                                "Name",
                                style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.white70),
                              )),
                              DataColumn(
                                  label: Text(
                                "Username",
                                style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.white70),
                              )),
                              DataColumn(
                                  label: Text(
                                "Phone Number",
                                style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.white70),
                              )),
                              DataColumn(
                                  label: Text(
                                "Email",
                                style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.white70),
                              )),
                              DataColumn(
                                  label: Text(
                                "Action",
                                style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.white70),
                              )),
                            ],
                            rows: staffs.map((s) {
                              return DataRow(cells: <DataCell>[
                                DataCell(Text(
                                  "${count++}",
                                  style: GoogleFonts.montserrat(
                                      color: Colors.white70),
                                )),
                                DataCell(_iamgeBox(s.image)),
                                DataCell(Text(
                                  s.name,
                                  style: GoogleFonts.montserrat(
                                      color: Colors.white70),
                                )),
                                DataCell(Text(
                                  s.uName,
                                  style: GoogleFonts.montserrat(
                                      color: Colors.white70),
                                )),
                                DataCell(Text(
                                  s.phone,
                                  style: GoogleFonts.montserrat(
                                      color: Colors.white70),
                                )),
                                DataCell(Text(
                                  s.email,
                                  style: GoogleFonts.montserrat(
                                      color: Colors.white70),
                                )),
                                DataCell(Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return EditStaff(
                                                name: s.name,
                                                uName: s.uName,
                                                phone: s.phone,
                                                email: s.email,
                                                token: s.token,
                                              );
                                            }).then((value) {
                                          // This function is called when the dialog is dismissed
                                          if (value != null &&
                                              value is String &&
                                              value == 'update') {
                                            // Call your function here after dialog is closed

                                            _staff.fetchStaffs();
                                            print("update");
                                            //$2y$10$G3If41Js4bhsiwzgikTJGeC7pW7eW6KXkaFQ34KzrAiSUoV/JyL2O
                                            //$2y$10$G3If41Js4bhsiwzgikTJGeC7pW7eW6KXkaFQ34KzrAiSUoV/JyL2O
                                          }
                                        });
                                      },
                                      child: const Icon(
                                        Icons.edit,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        Delte(s.token);
                                      },
                                      child: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ))
                              ]);
                            }).toList(),
                          );
                        }));
                  }),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> Delte(String token) async {
    var response = await http.post(
      Uri.parse("${config.base}${config.deleteStaff}"),
      body: jsonEncode({'token': token}),
    );
    var data = jsonDecode(response.body);
    if (data['status'] == 'success') {
      print(data);

      _staff.fetchStaffs();
    }
  }

  Widget _iamgeBox(String path) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          image: DecorationImage(
              image: NetworkImage("${config.base}$path"), fit: BoxFit.cover)),
    );
  }
}
