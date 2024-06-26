import 'package:blue_wash_web/config/config.dart';
import 'package:blue_wash_web/controller/completedControlelr.dart';
import 'package:blue_wash_web/model/completedModel.dart';
import 'package:blue_wash_web/service/completedService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utls/colors.dart';

class CompletedPage extends StatefulWidget {
  const CompletedPage({super.key});

  @override
  State<CompletedPage> createState() => _CompletedPageState();
}

class _CompletedPageState extends State<CompletedPage> {
  final CompletedController _comp = Get.put(CompletedController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _comp.fetchCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        List<CompletedModel> list = _comp.completed;
        if (list.isEmpty) {
          return Center(
              child: Text(
            "No Task Assigned yet",
            style: TextStyle(color: Colors.white),
          ));
        }
        return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  child: Container(
                    height: 170,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      color: Ac.bNcolor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Completed Task",
                            style: GoogleFonts.montserrat(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                list[index].completedDate,
                                style: GoogleFonts.montserrat(
                                  color: Ac.DTcolor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                "Completed by -> ${list[index].staff_name}",
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                "Service : ${list[index].service}/08",
                                style: GoogleFonts.montserrat(
                                  color: Colors.white70,
                                ),
                              ),
                              SizedBox(width: 15),
                              Text(
                                list[index].packageName,
                                style: GoogleFonts.montserrat(
                                  color: Colors.white70,
                                ),
                              ),
                              SizedBox(width: 15),
                              Text(
                                list[index].car_number,
                                style: GoogleFonts.montserrat(
                                  color: Colors.white70,
                                ),
                              ),
                              Spacer(),
                              Image.network(
                                "${config.base}${list[index].img1}",
                                height: 80,
                                width: 80,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Image.network(
                                "${config.base}${list[index].img2}",
                                height: 80,
                                width: 80,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Image.network(
                                "${config.base}${list[index].img3}",
                                height: 80,
                                width: 80,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            });
      }),
    );
  }
}
