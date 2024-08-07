import 'dart:convert';

import 'package:blue_wash_web/config/config.dart';
import 'package:blue_wash_web/controller/vehiclesController.dart';
import 'package:blue_wash_web/model/vehiclesModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../../utls/colors.dart';

class VehiclesPage extends StatefulWidget {
  const VehiclesPage({super.key});

  @override
  State<VehiclesPage> createState() => _VehiclesPageState();
}

class _VehiclesPageState extends State<VehiclesPage> {
  final VehicleController _v = Get.put(VehicleController());
  Map<String, Map<String, String>> carImages = {};
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _v.fetch();
    _getCarImages();
  }

  Future<void> _getCarImages() async {
    var response =
        await http.get(Uri.parse("${config.base}${config.getCarIage}"));
    var data = jsonDecode(response.body);
    if (data['status'] == "success") {
      print(data);
      for (var car in data['data']) {
        String model = car['model'];
        String color = car['color'];
        String imageUrl = car['image_url'];
        if (!carImages.containsKey(model)) {
          carImages[model] = {};
        }
        carImages[model]![color] = imageUrl;
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Vehicles> car = _v.vehicle;
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
                child: Text(
                  "Vehicles",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.white),
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
                          if (_v.vehicle.isEmpty) {
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
                                "Image",
                                style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.white70),
                              )),
                              DataColumn(
                                  label: Text(
                                "Owner",
                                style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.white70),
                              )),
                              DataColumn(
                                  label: Text(
                                "Brand & Model",
                                style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.white70),
                              )),

                              DataColumn(
                                  label: Text(
                                "Car Number",
                                style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.white70),
                              )),
                              DataColumn(
                                  label: Text(
                                "Color",
                                style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.white70),
                              )),
                              DataColumn(
                                  label: Text(
                                "Car Type",
                                style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.white70),
                              )),
                              // DataColumn(
                              //     label: Text(
                              //   "Action",
                              //   style: GoogleFonts.montserrat(
                              //       fontWeight: FontWeight.bold,
                              //       fontSize: 18,
                              //       color: Colors.white70),
                              // )),
                            ],
                            rows: car.map((s) {
                              return DataRow(cells: <DataCell>[
                                DataCell(Text(
                                  "${count++}",
                                  style: GoogleFonts.montserrat(
                                      color: Colors.white70),
                                )),
                                DataCell(
                                  carImages.containsKey(s.model) &&
                                          carImages[s.model]!
                                              .containsKey(s.color)
                                      ? SizedBox(
                                          width: 120,
                                          child: Image.network(
                                            "${config.base}/${carImages[s.model]![s.color]}",
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : SizedBox(
                                          width: 120,
                                          child: Image.asset(
                                            'assets/carred.png',
                                            fit: BoxFit.fitWidth,
                                          ),
                                        ),
                                ),
                                DataCell(Text(
                                  s.owner,
                                  style: GoogleFonts.montserrat(
                                      color: Colors.white70),
                                )),
                                DataCell(Text(
                                  "${s.brand}, ${s.model}",
                                  style: GoogleFonts.montserrat(
                                      color: Colors.white70),
                                )),
                                DataCell(Text(
                                  s.number,
                                  style: GoogleFonts.montserrat(
                                      color: Colors.white70),
                                )),
                                DataCell(Text(
                                  s.color,
                                  style: GoogleFonts.montserrat(
                                      color: Colors.white70),
                                )),
                                DataCell(Text(
                                  s.type,
                                  style: GoogleFonts.montserrat(
                                      color: Colors.white70),
                                )),
                                // DataCell(Row(
                                //   children: [
                                //     InkWell(
                                //       onTap: () {
                                //         showDialog(
                                //             context: context,
                                //             builder: (BuildContext context) {
                                //               return EditStaff(
                                //                 name: s.name,
                                //                 uName: s.uName,
                                //                 phone: s.phone,
                                //                 email: s.email,
                                //                 token: s.token,
                                //               );
                                //             }).then((value) {
                                //           // This function is called when the dialog is dismissed
                                //           if (value != null &&
                                //               value is String &&
                                //               value == 'update') {
                                //             // Call your function here after dialog is closed

                                //             _staff.fetchStaffs();
                                //             print("update");
                                //             //$2y$10$G3If41Js4bhsiwzgikTJGeC7pW7eW6KXkaFQ34KzrAiSUoV/JyL2O
                                //             //$2y$10$G3If41Js4bhsiwzgikTJGeC7pW7eW6KXkaFQ34KzrAiSUoV/JyL2O
                                //           }
                                //         });
                                //       },
                                //       child: const Icon(
                                //         Icons.edit,
                                //         color: Colors.blue,
                                //       ),
                                //     ),
                                //     const SizedBox(
                                //       width: 20,
                                //     ),
                                //     InkWell(
                                //       onTap: () async {
                                //         Delte(s.token);
                                //       },
                                //       child: const Icon(
                                //         Icons.delete,
                                //         color: Colors.red,
                                //       ),
                                //     ),
                                //   ],
                                // ))
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
}
