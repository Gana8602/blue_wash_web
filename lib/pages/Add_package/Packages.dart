import 'dart:convert';

import 'package:blue_wash_web/config/config.dart';
import 'package:blue_wash_web/controller/package_controller.dart';
import 'package:blue_wash_web/pages/Add_package/add_package.dart';
import 'package:blue_wash_web/utls/colors.dart';
import 'package:blue_wash_web/widgets/button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';

class PackagesPage extends StatefulWidget {
  const PackagesPage({super.key});

  @override
  State<PackagesPage> createState() => _PackagesPageState();
}

class _PackagesPageState extends State<PackagesPage> {
  final PackageController _pack = Get.put(PackageController());
  List<String> services = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pack.fetchPackages();
  }

  Future<void> deltPak(String id) async {
    var response = await http
        .post(Uri.parse("${config.base}${config.deltPack}"), body: {'id': id});
    var data = jsonDecode(response.body);
    if (data['status'] == 'success') {
      print(data);
      setState(() {
        _pack.packages.clear();
      });
      _pack.fetchPackages();
    } else {
      print("Error : $data");
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  "Packages",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.white),
                ),
                Spacer(),
                ButtonBlue2(
                    text: "Add Package",
                    ontap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return PackageAdd();
                          });
                    })
              ],
            ),
            Expanded(
              child: Center(child: Obx(() {
                if (_pack.packages.isEmpty) {
                  return CircularProgressIndicator();
                }
                return ListView.builder(
                  itemCount: _pack.packages.length,
                  itemBuilder: (context, index) {
                    final pack = _pack.packages;
                    services = pack[index]
                        .service
                        .split(',')
                        .map((e) => e.trim())
                        .toList();
                    return Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: Container(
                        height: 130,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Ac.bNcolor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 15,
                            ),
                            Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          "${config.base}${pack[index].image_path}"))),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    pack[index].package_name,
                                    style: GoogleFonts.montserrat(
                                        fontSize: 15,
                                        color: Colors.white70,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    pack[index].price,
                                    style: GoogleFonts.montserrat(
                                        fontSize: 15,
                                        color: Colors.white70,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    pack[index].real_price,
                                    style: GoogleFonts.montserrat(
                                        fontSize: 15,
                                        color: Colors.white70,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    for (int i = 0; i < services.length; i++)
                                      Text(
                                        services[i],
                                        style: GoogleFonts.montserrat(
                                            fontSize: 15,
                                            color: Colors.white70,
                                            fontWeight: FontWeight.bold),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    pack[index].car_type,
                                    style: GoogleFonts.montserrat(
                                        fontSize: 15,
                                        color: Colors.white70,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 50.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      deltPak(pack[index].id);
                                    },
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              })),
            ),
          ],
        ),
      ),
    );
  }
}
