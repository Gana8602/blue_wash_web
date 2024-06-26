import 'package:blue_wash_web/controller/upcomingControler.dart';
import 'package:blue_wash_web/model/upcomingModel.dart';
import 'package:blue_wash_web/service/upcomingService.dart';
import 'package:blue_wash_web/utls/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class UpcomingPage extends StatefulWidget {
  const UpcomingPage({super.key});

  @override
  State<UpcomingPage> createState() => _UpcomingPageState();
}

class _UpcomingPageState extends State<UpcomingPage> {
  final UpcomingController _upcom = Get.put(UpcomingController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _upcom.fetchUpcoming();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        List<UpcomingModel> list = _upcom.upcomings;
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
                    height: 120,
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
                            "Pending Task",
                            style: GoogleFonts.montserrat(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                list[index].date,
                                style: GoogleFonts.montserrat(
                                  color: Ac.DTcolor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                "Assigned to -> ${list[index].staff_name}",
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
