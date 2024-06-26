import 'dart:convert';

import 'package:blue_wash_web/config/config.dart';
import 'package:blue_wash_web/controller/Staffs_controller.dart';
import 'package:blue_wash_web/model/staffs_model.dart';
import 'package:blue_wash_web/pages/staffs/staffs_add.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart' as http;

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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Staffs",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 1.8,
                child: AddStaffPage(),
              ),
              Expanded(
                  child: Align(
                alignment: Alignment.topCenter,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text("ID")),
                    DataColumn(label: Text("Name")),
                    DataColumn(label: Text("Username")),
                    DataColumn(label: Text("Phone Number"))
                  ],
                  rows: staffs.map((s) {
                    return DataRow(cells: <DataCell>[
                      DataCell(Text(s.id)),
                      DataCell(Text(s.name)),
                      DataCell(Text(s.uName)),
                      DataCell(Text(s.phone))
                    ]);
                  }).toList(),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
