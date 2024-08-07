import 'dart:convert';
import 'dart:io';

import 'package:blue_wash_web/config/config.dart';
import 'package:blue_wash_web/controller/Staffs_controller.dart';
import 'package:blue_wash_web/controller/purchase_controller.dart';
import 'package:blue_wash_web/model/staffs_model.dart';
import 'package:blue_wash_web/utls/colors.dart';
import 'package:blue_wash_web/widgets/button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:path_provider/path_provider.dart';
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

  Future<void> downloadPdf(String url, String fileName) async {
    try {
      // Get the document directory for storing the PDF file.
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
      String filePath = '${selectedDirectory}/$fileName';

      // Fetch the PDF file from the URL.
      http.Response response = await http.get(Uri.parse(url));

      // Write the PDF file to the local file system.
      File file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      print('PDF downloaded to $filePath');
    } catch (e) {
      print('Error downloading PDF: $e');
    }
  }

  Future<void> invoice(String id) async {
    var response = await http.post(
      Uri.parse("${config.base}${config.donwloadInvoice}"),
      body: jsonEncode({'id': id}),
    );
    var data = jsonDecode(response.body);
    print(data);
    if (data['status'] == 'success') {
      var dataa = data['invoice'];
      String url = dataa['path'];
      String rightUrl = "${config.base}$url";
      // Extract a meaningful filename from the URL or use a default name
      String fileName = url.split('/').last; // Extract filename from path
      downloadPdf(rightUrl, fileName);
    }
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

  Future<void> _sendData(String packageName, String token, String carNumber,
      String player_id) async {
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
        'player_id': player_id,
      }),
    );
    var data = jsonDecode(response.body);
    if (data['status'] == 'success') {
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Orders",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.white),
            ),
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Obx(() {
                    if (_purchase.Purchased.isEmpty) {
                      return Center(child: CircularProgressIndicator());
                    }

                    return ListView.builder(
                        itemCount: _purchase.Purchased.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 100,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  color: Ac.bNcolor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Container(
                                      height: 60,
                                      width: 60,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  "${config.base}${_purchase.Purchased[index].image}"))),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _purchase.Purchased[index].name,
                                            style: GoogleFonts.montserrat(
                                                fontSize: 15,
                                                color: Colors.white70,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            _purchase.Purchased[index].phone,
                                            style: GoogleFonts.montserrat(
                                                fontSize: 15,
                                                color: Colors.white70,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            _purchase.Purchased[index].email,
                                            style: GoogleFonts.montserrat(
                                                fontSize: 15,
                                                color: Colors.white70,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _purchase
                                                .Purchased[index].car_number,
                                            style: GoogleFonts.montserrat(
                                                fontSize: 15,
                                                color: Colors.white70,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            _purchase.Purchased[index].carType,
                                            style: GoogleFonts.montserrat(
                                                fontSize: 15,
                                                color: Colors.white70,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _purchase
                                                .Purchased[index].package_name,
                                            style: GoogleFonts.montserrat(
                                                fontSize: 15,
                                                color: Colors.white70,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            _purchase.Purchased[index].price,
                                            style: GoogleFonts.montserrat(
                                                fontSize: 15,
                                                color: Colors.white70,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _purchase.Purchased[index].name,
                                            style: GoogleFonts.montserrat(
                                                fontSize: 15,
                                                color: Colors.white70,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      tooltip: "Downlaod Invoice",
                                      onPressed: () {
                                        print(pur[index].InvoiceId);
                                        invoice(pur[index].InvoiceId);
                                      },
                                      icon: Icon(
                                        Icons.download_for_offline_outlined,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    ButtonBlue2(
                                        text: "Schedule",
                                        ontap: () async {
                                          await _selectDate(context);
                                          if (_selectedDate != null) {
                                            _sShowModel(
                                                pur[index].package_name,
                                                pur[index].token,
                                                pur[index].car_number,
                                                pur[index].player_id);
                                          }
                                        })
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  })),
            ),
          ],
        ),
      ),
    );
  }

  void _sShowModel(
    String pName,
    String token,
    String carNumber,
    String player_id,
  ) {
    showModalBottomSheet(
      backgroundColor: Colors.black,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text(
                    'Select Service',
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: DropdownButton<String>(
                    dropdownColor: Colors.black,
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
                      return DropdownMenuItem<String>(
                        value: value,
                        child:
                            Text(value, style: TextStyle(color: Colors.white)),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedService = newValue;
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                ListTile(
                  title: Text('Select Service',
                      style: TextStyle(color: Colors.white)),
                  trailing: DropdownButton<String>(
                    dropdownColor: Colors.black,
                    value: selectedStaff,
                    items: staff.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child:
                            Text(value, style: TextStyle(color: Colors.white)),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedStaff = newValue;
                        for (var sta in _staff.staffs) {
                          if (sta.name == newValue) {
                            selectedStaffToken = sta.token;
                            break;
                          }
                        }
                        print("Selected staff: $selectedStaff");
                        print("Selected staff token: $selectedStaffToken");
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                ButtonBlue2(
                    text: "Assign",
                    ontap: () {
                      Navigator.pop(context);
                      print(player_id);
                      _sendData(pName, token, carNumber, player_id);
                    })
                // ElevatedButton(
                //   onPressed: () {

                //   },
                //   child: Text('Send Data'),
                // ),
              ],
            );
          },
        );
      },
    );
  }
}


// await _selectDate(context);
//                                   if (_selectedDate != null) {
//                                     _sShowModel(
//                                         pur[index].package_name,
//                                         pur[index].token,
//                                         pur[index].car_number);
//                                   }