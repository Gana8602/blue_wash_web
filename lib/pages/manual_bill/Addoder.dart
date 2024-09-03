import 'dart:convert';
import 'dart:io';

import 'package:blue_wash_web/config/config.dart';
import 'package:blue_wash_web/controller/package_controller.dart';
import 'package:blue_wash_web/controller/purchase_controller.dart';
import 'package:blue_wash_web/pages/manual_bill/add.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../../utls/colors.dart';
import '../../widgets/button.dart';
import '../Add_package/add_package.dart';

class OrderPageManual extends StatefulWidget {
  const OrderPageManual({super.key});

  @override
  State<OrderPageManual> createState() => _OrderPageManualState();
}

class _OrderPageManualState extends State<OrderPageManual> {
  final PurchaseController2 _purchase = Get.put(PurchaseController2());
  DateTime? _selectedDate;
  String? _selectedService;
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _purchase.fetchpurchase();
  }

  @override
  Widget build(BuildContext context) {
    final pur = _purchase.Purchased2;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Orders manual",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.white),
                ),
                Spacer(),
                ButtonBlue2(
                    text: "Add Order ",
                    ontap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return PurchaseAddPage();
                          });
                    })
              ],
            ),
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Obx(() {
                    if (_purchase.Purchased2.isEmpty) {
                      return Center(child: CircularProgressIndicator());
                    }

                    return ListView.builder(
                        itemCount: _purchase.Purchased2.length,
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
                                                  "${config.base}${_purchase.Purchased2[index].image}"))),
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
                                            _purchase.Purchased2[index].name,
                                            style: GoogleFonts.montserrat(
                                                fontSize: 15,
                                                color: Colors.white70,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            _purchase.Purchased2[index].phone,
                                            style: GoogleFonts.montserrat(
                                                fontSize: 15,
                                                color: Colors.white70,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            _purchase.Purchased2[index].email,
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
                                            _purchase.Purchased2[index].address,
                                            style: GoogleFonts.montserrat(
                                                fontSize: 15,
                                                color: Colors.white70,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            _purchase.Purchased2[index].carType,
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
                                                .Purchased2[index].package_name,
                                            style: GoogleFonts.montserrat(
                                                fontSize: 15,
                                                color: Colors.white70,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            _purchase.Purchased2[index].price,
                                            style: GoogleFonts.montserrat(
                                                fontSize: 15,
                                                color: Colors.white70,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            _purchase
                                                .Purchased2[index].carNumber,
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
                                            _purchase.Purchased2[index].name,
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
                                    // ButtonBlue2(
                                    //     text: "Schedule",
                                    //     ontap: () async {
                                    //       await _selectDate(context);
                                    //       if (_selectedDate != null) {
                                    //         _sShowModel(
                                    //             pur[index].package_name,
                                    //             pur[index].token,
                                    //             pur[index].car_number,
                                    //             pur[index].player_id);
                                    //       }
                                    //     })
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
}
