import 'dart:convert';

import 'package:blue_wash_web/config/config.dart';
import 'package:blue_wash_web/controller/Staffs_controller.dart';
import 'package:blue_wash_web/controller/purchase_controller.dart';
import 'package:blue_wash_web/model/staffs_model.dart';
import 'package:blue_wash_web/utls/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class PurchasedPage extends StatefulWidget {
  const PurchasedPage({super.key});

  @override
  State<PurchasedPage> createState() => _PurchasedPageState();
}

class _PurchasedPageState extends State<PurchasedPage> {
  final PurchaseController _purchase = Get.put(PurchaseController());
  final StaffController _staff = Get.put(StaffController());
  DateTime? _selectedDate;
  String? _selectedService;
  List<String> staff = [];
  String? selectedStaff;
  String? selectedStaffToken;

  @override
  void initState() {
    super.initState();

    _purchase.fetchpurchase();
    _staff.fetchStaffs();
  }

  Future<void> _selectDate(BuildContext context) async {
    List<StaffModel> staffs = _staff.staffs;
    staff.clear();
    for (var sta in staffs) {
      staff.add(sta.name);
    }
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  Future<void> _sendData(
      String packageName, String token, String carNumber) async {
    if (_selectedDate == null || _selectedService == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Please select a date and a service"),
      ));
      return;
    }

    String formattedDate = DateFormat('dd MMMM yyyy').format(_selectedDate!);

    var response = await http.post(
      Uri.parse('${config.base}${config.schedule}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'package_name': packageName,
        'selected_date': formattedDate,
        'token': token,
        'staff_name': selectedStaff!,
        'staff_token': selectedStaffToken!,
        'service': _selectedService!,
        'car_number': carNumber,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Data sent successfully"),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to send data"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final pur = _purchase.Purchased;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Obx(() {
            if (_purchase.Purchased.isEmpty) {
              return Center(child: CircularProgressIndicator());
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "User Purchased",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: pur.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Card(
                          color: Ac.bNcolor,
                          child: ListTile(
                            title: Text(
                              pur[index].name,
                              style:
                                  GoogleFonts.montserrat(color: Colors.white),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  pur[index].package_name,
                                  style: GoogleFonts.montserrat(
                                      color: Colors.white),
                                ),
                                Text(
                                  pur[index].car_number,
                                  style: GoogleFonts.montserrat(
                                      color: Colors.white),
                                ),
                                Text(
                                  pur[index].phone,
                                  style: GoogleFonts.montserrat(
                                      color: Colors.white),
                                ),
                              ],
                            ),
                            trailing: TextButton(
                              child: Text("Schedule"),
                              onPressed: () async {
                                await _selectDate(context);
                                if (_selectedDate != null) {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return StatefulBuilder(
                                        builder: (BuildContext context,
                                            StateSetter setState) {
                                          return Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ListTile(
                                                title: Text('Select Service'),
                                                trailing:
                                                    DropdownButton<String>(
                                                  value: _selectedService,
                                                  items: <String>[
                                                    '01',
                                                    '02',
                                                    '03',
                                                    "04",
                                                    "05",
                                                    "06",
                                                    "07",
                                                    "08"
                                                  ].map((String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Text(value),
                                                    );
                                                  }).toList(),
                                                  onChanged:
                                                      (String? newValue) {
                                                    setState(() {
                                                      _selectedService =
                                                          newValue;
                                                    });
                                                  },
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              ListTile(
                                                title: Text('Select Service'),
                                                trailing:
                                                    DropdownButton<String>(
                                                  value: selectedStaff,
                                                  items:
                                                      staff.map((String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Text(value),
                                                    );
                                                  }).toList(),
                                                  onChanged:
                                                      (String? newValue) {
                                                    setState(() {
                                                      selectedStaff = newValue;
                                                      for (var sta
                                                          in _staff.staffs) {
                                                        if (sta.name ==
                                                            newValue) {
                                                          selectedStaffToken =
                                                              sta.token;
                                                          break;
                                                        }
                                                      }
                                                      print(
                                                          "Selected staff: $selectedStaff");
                                                      print(
                                                          "Selected staff token: $selectedStaffToken");
                                                    });
                                                  },
                                                ),
                                              ),
                                              SizedBox(
                                                height: 30,
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);

                                                  _sendData(
                                                      pur[index].package_name,
                                                      pur[index].token,
                                                      pur[index].car_number);
                                                },
                                                child: Text('Send Data'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          })),
    );
  }
}
