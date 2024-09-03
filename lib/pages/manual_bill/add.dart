import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:blue_wash_web/config/config.dart';
import 'package:blue_wash_web/controller/package_controller.dart';
import 'package:blue_wash_web/utls/colors.dart';
import 'package:blue_wash_web/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get/route_manager.dart';

import '../../controller/purchase_controller.dart';

class PurchaseAddPage extends StatefulWidget {
  const PurchaseAddPage({super.key});

  @override
  State<PurchaseAddPage> createState() => _PurchaseAddPageState();
}

class _PurchaseAddPageState extends State<PurchaseAddPage> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _car_number = TextEditingController();
  final PackageController _pack = Get.put(PackageController());
  final InvoController _invo = Get.put(InvoController());
  final PurchaseController2 _purchase = Get.put(PurchaseController2());
  bool isLoading = false;
  int? checkedIndex;
  String? pName;
  String? price;
  String? carType;
  String? services;
  String? packageId;
  String? image;

  @override
  void initState() {
    super.initState();
    isLoading = true;
    _invo.fetchInvoice();
    _pack.fetchPackages();
    if (_pack.packages.isNotEmpty) {
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 800,
        height: 500,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Colors.black,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 400,
                      width: 300,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _field(_name, "User's Name", (p0) {
                            if (p0 == null || p0.isEmpty) {
                              return 'Please enter user\'s name';
                            }
                            return null;
                          }),
                          SizedBox(height: 10),
                          _field(_phone, "User's Phone", (p0) {
                            if (p0 == null || p0.isEmpty) {
                              return 'Please enter user\'s phone';
                            }
                            return null;
                          }),
                          SizedBox(height: 10),
                          _field(_email, "User's Email", (p0) {
                            if (p0 == null || p0.isEmpty) {
                              return 'Please enter user\'s email';
                            }
                            return null;
                          }),
                          SizedBox(height: 10),
                          _field(_car_number, "User's Car Number", (p0) {
                            if (p0 == null || p0.isEmpty) {
                              return 'Please enter user\'s carNumber';
                            }
                            return null;
                          }),
                          SizedBox(height: 10),
                          _field(_address, "Customer Address", (p0) {
                            if (p0 == null || p0.isEmpty) {
                              return 'Please enter car number';
                            }
                            return null;
                          }),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    flex: 1,
                    child: Container(
                      width: 300,
                      height: 400,
                      child: Obx(() {
                        if (_pack.packages.isEmpty) {
                          return Center(
                            child: Text(
                              "No Packages found",
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        }
                        return ListView.builder(
                          itemCount: _pack.packages.length,
                          itemBuilder: (context, index) {
                            final pack = _pack.packages;
                            return Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Container(
                                height: 70,
                                decoration: BoxDecoration(
                                  color: Ac.bNcolor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Image.network(
                                        height: 50,
                                        width: 50,
                                        fit: BoxFit.cover,
                                        "${config.base}${pack[index].image_path}",
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          pack[index].package_name,
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          pack[index].car_type,
                                          style: TextStyle(
                                            color: Colors.white70,
                                          ),
                                        ),
                                        Text(
                                          pack[index].price,
                                          style: TextStyle(
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    Checkbox(
                                      value: checkedIndex == index,
                                      onChanged: (val) {
                                        setState(() {
                                          if (val == true) {
                                            checkedIndex = index;
                                            pName = pack[index].package_name;
                                            price = pack[index].price;

                                            carType = pack[index].car_type;
                                            services = pack[index].service;
                                            packageId = pack[index].id;
                                            image = pack[index].image_path;
                                          } else {
                                            checkedIndex = null;
                                            pName = '';
                                            price = '';
                                            carType = '';
                                            services = '';
                                            packageId = '';
                                            image = '';
                                          }
                                          print('Package Name: $pName');
                                          print('Price: $price');
                                          print('Car Type: $carType');
                                          print('Services: $services');
                                          print('Package ID: $packageId');
                                          print('Image Path: $image');
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }),
                    ),
                  ),
                ],
              ),
              ButtonBlue2(
                text: "Submit",
                ontap: () async {
                  int ID = 0;
                  // Handle the submit action here
                  print('Selected Package: $pName');
                  if (_invo.Invoices.isEmpty) {
                    print("yes");
                    setState(() {
                      ID = 1;
                    });
                    print(ID);
                    final invoice = Invoice(
                      invoiceNumber: "BW00$ID",
                      customerName: _name.text,
                      date: DateTime.now(),
                      Cnumber: _phone.text,
                      customerAddress: _address.text,
                      items: [
                        InvoiceItem(
                            description: pName!,
                            quantity: 1,
                            price: double.parse(price!)),
                      ],
                    );
                    int? invoiceId = await SendPdf(invoice);
                    print(invoiceId);
                    if (invoiceId != null) {
                      SavePayment(invoiceId);
                    }
                  } else {
                    String id = _invo.Invoices.first.id;
                    print("NO");
                    setState(() {
                      ID = int.parse(id) + 1;
                    });
                    print(ID);
                    final invoice = Invoice(
                      invoiceNumber: "BW00$ID",
                      customerName: _name.text,
                      date: DateTime.now(),
                      Cnumber: _phone.text,
                      customerAddress: _address.text,
                      items: [
                        InvoiceItem(
                            description: pName!,
                            quantity: 1,
                            price: double.parse(price!)),
                      ],
                    );
                    int? invoiceId = await SendPdf(invoice);
                    print(invoiceId);
                    if (invoiceId != null) {
                      SavePayment(invoiceId);
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> SavePayment(int? invoiceId) async {
    print("start");
    var jsondata = jsonEncode({
      "name": _name.text,
      "phone": _phone.text,
      "email": _email.text,
      "package_name": pName,
      "car_number": _car_number.text.toUpperCase(),
      "price": price,
      "address": _address.text,
      "car_type": carType,
      "services": services,
      "image": image,
      "invoice_id": invoiceId
    });
    try {
      var response = await http
          .post(Uri.parse("${config.base}${config.purchase2}"), body: jsondata);
      var data = jsonDecode(response.body);
      print(data);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print(data);
        if (data['status'] == 'success') {
          print("ok");
          _purchase.Purchased2.clear();
          _purchase.fetchpurchase();
          Get.back();
        } else {
          print("not Ok");
        }
      } else {
        print("Server error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error :  $e");
    }
  }

  Widget _field(TextEditingController cont, String label,
      String? Function(String?)? validator) {
    return TextFormField(
      controller: cont,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white54),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white54),
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white54),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white54),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      style: const TextStyle(color: Colors.white),
      validator: validator,
    );
  }
}

class Invoice {
  final String invoiceNumber;
  final String customerName;
  final DateTime date;
  final String customerAddress;
  final String Cnumber;

  final List<InvoiceItem> items;

  Invoice({
    required this.invoiceNumber,
    required this.customerName,
    required this.date,
    required this.Cnumber,
    required this.customerAddress,
    required this.items,
  });
}

class InvoiceItem {
  String description;
  final int quantity;
  double price;

  InvoiceItem({
    required this.description,
    required this.quantity,
    required this.price,
  });
}

class Invo {
  final String id;
  final String token;
  final String path;

  Invo({required this.id, required this.token, required this.path});
  factory Invo.fromJson(Map<String, dynamic> json) {
    return Invo(id: json['id'], token: json['token'], path: json['path']);
  }
}

Future<Uint8List> _loadImage(String img) async {
  final ByteData image = await rootBundle.load(img);
  return image.buffer.asUint8List();
}
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;

Future<Uint8List> generateInvoice(Invoice invoice) async {
  final pdf = pw.Document();

  // Load custom font
  final font =
      pw.Font.ttf(await rootBundle.load('assets/fonts/NotoSans-Regular.ttf'));

  final Uint8List image = await _loadImage("assets/logo.png");

  pdf.addPage(
    pw.Page(
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('Invoice',
              style: pw.TextStyle(
                  fontSize: 40, fontWeight: pw.FontWeight.bold, font: font)),
          pw.SizedBox(height: 20),
          pw.Row(children: [
            pw.Expanded(
                flex: 1,
                child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('From:',
                          style: pw.TextStyle(
                              fontSize: 20,
                              fontWeight: pw.FontWeight.bold,
                              font: font)),
                      pw.Text(
                        'Blue Wash',
                        style: pw.TextStyle(font: font),
                      ),
                      pw.Text(
                        '9/5, Sbi Colony, \nContonement, Trichy',
                        style: pw.TextStyle(font: font),
                      ),
                      pw.Text(
                        'Invoice Date: ${DateFormat('yyyy/MM/dd').format(invoice.date)}',
                        style: pw.TextStyle(font: font),
                      ),
                      pw.SizedBox(
                        height: 25,
                      ),
                      pw.Text('To:',
                          style: pw.TextStyle(
                              fontSize: 20,
                              fontWeight: pw.FontWeight.bold,
                              font: font)),
                      pw.Text(
                        'Customer Name: ${invoice.customerName}',
                        style: pw.TextStyle(font: font),
                      ),
                      pw.Text(
                        'Phone Number: ${invoice.Cnumber}',
                        style: pw.TextStyle(font: font),
                      ),
                      pw.Text(
                        'Address: ${invoice.customerAddress}',
                        style: pw.TextStyle(font: font),
                      ),
                    ])),
            pw.Expanded(
                flex: 1,
                child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Container(
                          height: 100,
                          width: 100,
                          decoration: pw.BoxDecoration(
                              image: pw.DecorationImage(
                                  image: pw.MemoryImage(image),
                                  fit: pw.BoxFit.cover))),
                      pw.SizedBox(
                        height: 15,
                      ),
                      pw.Text(
                        "Invoice Number : ${invoice.invoiceNumber}",
                        style: pw.TextStyle(font: font),
                      ),
                      pw.Text(
                        "Invoice Date : ${DateFormat('yyyy/MM/dd').format(invoice.date)}",
                        style: pw.TextStyle(font: font),
                      ),
                      pw.Text(
                        "GST Number : 33ASUPH9037Q1ZU",
                        style: pw.TextStyle(font: font),
                      )
                    ]))
          ]),
          pw.SizedBox(height: 30),
          pw.Table.fromTextArray(
            headers: ['Description', 'Quantity', 'Price'],
            data: invoice.items.map((item) {
              return [item.description, item.quantity, item.price];
            }).toList(),
            headerStyle: pw.TextStyle(font: font),
            cellStyle: pw.TextStyle(font: font),
          ),
          pw.Spacer(),
          pw.Divider(),

          // GST Calculation Section
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            children: [
              pw.Text(
                'Subtotal: ₹${invoice.items.fold<double>(0, (total, item) => total + (item.quantity * item.price))}',
                style: pw.TextStyle(fontSize: 16, font: font),
              ),
            ],
          ),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            children: [
              pw.Text(
                'CGST (9%): ₹${(invoice.items.fold<double>(0, (total, item) => total + (item.quantity * item.price)) * 0.09).toStringAsFixed(2)}',
                style: pw.TextStyle(fontSize: 16, font: font),
              ),
            ],
          ),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            children: [
              pw.Text(
                'SGST (9%): ₹${(invoice.items.fold<double>(0, (total, item) => total + (item.quantity * item.price)) * 0.09).toStringAsFixed(2)}',
                style: pw.TextStyle(fontSize: 16, font: font),
              ),
            ],
          ),

          pw.Divider(),
          pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Text(
                  'Total Amount (Inclusive GST): ₹${(invoice.items.fold<double>(0, (total, item) => total + (item.quantity * item.price)) * 1.18).toStringAsFixed(2)}',
                  style: pw.TextStyle(
                      fontSize: 20, font: font, fontWeight: pw.FontWeight.bold),
                ),
              ]),
        ],
      ),
    ),
  );

  final pdfBytes = await pdf.save();

  return pdfBytes;
}

Future<int?> SendPdf(Invoice invoice) async {
  final pdf = await generateInvoice(invoice);
  const url = '${config.base}${config.savePdf}'; // Replace with your server URL
  final request = http.MultipartRequest('POST', Uri.parse(url))
    ..fields['token'] = "667d169e69e56"
    ..files.add(http.MultipartFile.fromBytes('pdf_file', pdf,
        filename: '${invoice.customerName}_${invoice.invoiceNumber}.pdf'));

  try {
    final response = await request.send();

    if (response.statusCode == 200) {
      final responseString = await response.stream.bytesToString();

      final Map<String, dynamic> data = jsonDecode(responseString);
      Map<String, dynamic> json = data['data'];
      int Iid = json['id'];
      String path = json['path'];
      // Data.path = path;

      return Iid;
    } else {}
  } catch (e) {}
  return null;
}

// Future<void> sendInvoice() async {
//   final invoiceUrl = '${config.base}${Data.path}';
//   final response = await http.post(
//     Uri.parse("${config.base}${config.sendInvoice}"),
//     // headers: {
//     //   'Content-Type': 'application/x-www-form-urlencoded',
//     // },
//     body: {
//       'email': Data.user!.email,
//       'invoice_url': invoiceUrl,
//       //https://bluewash.in/api/invoices/Hariiii_package for MUV2.pdf
//     },
//   );

//   if (response.statusCode == 200) {
//   } else {}
// }

class INVOService {
  Future<dynamic> getInvoice() async {
    try {
      var response =
          await http.get(Uri.parse("${config.base}${config.invoices}"));
      var data = jsonDecode(response.body);

      if (data['status'] == 'success') {
        // Convert List<dynamic> to List<Invo>
        List<Invo> invoices =
            (data['data'] as List).map((item) => Invo.fromJson(item)).toList();
        return invoices;
      } else {
        return null;
      }
    } catch (e) {}
  }
}

class InvoController {
  var Invoices = <Invo>[].obs;

  Future<void> fetchInvoice() async {
    var response = await INVOService().getInvoice();
    if (response != null && response is List<Invo>) {
      Invoices.assignAll(response.reversed);
    }
  }
}
