import 'package:blue_wash_web/config/config.dart';
import 'package:blue_wash_web/controller/purchase_controller.dart';
import 'package:blue_wash_web/pages/home/widget/card.dart';
import 'package:blue_wash_web/pages/home/widget/infoCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../controller/Staffs_controller.dart';
import '../../controller/upcomingControler.dart';
import '../../controller/user_controller.dart';
import '../../utls/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ChartData> chartData = [];
  final PurchaseController _pu = Get.put(PurchaseController());
  final UserController userController = Get.put(UserController());
  StaffController _staff = Get.put(StaffController());
  final UpcomingController _upcom = Get.put(UpcomingController());
  bool isLoading = true;
  String? revenue;
  String? todayRevenue;
  String? weekRevenue;
  String? monthRevenue;
  String? yearRevenue;
  String? userCount;
  String? staffCount;
  String? pendingtask;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    await _pu.fetchpurchase();
    await userController.getData();
    await _staff.fetchStaffs();
    await _upcom.fetchUpcoming();
    await fillDate();
  }

  Future<void> fillDate() async {
    chartData = _pu.Purchased.map((data) {
      DateTime date = DateTime.parse(data.date);
      String formattedDate = DateFormat('yyyy-MM-dd').format(date);
      return ChartData(
        date: DateTime.parse(formattedDate),
        price: double.parse(data.price),
      );
    }).toList();

    double totalSum =
        _pu.Purchased.fold(0, (sum, item) => sum + double.parse(item.price));
    double todaySum =
        _pu.Purchased.where((item) => isToday(DateTime.parse(item.date)))
            .fold(0, (sum, item) => sum + double.parse(item.price));
    double weekSum =
        _pu.Purchased.where((item) => isThisWeek(DateTime.parse(item.date)))
            .fold(0, (sum, item) => sum + double.parse(item.price));
    double monthSum =
        _pu.Purchased.where((item) => isThisMonth(DateTime.parse(item.date)))
            .fold(0, (sum, item) => sum + double.parse(item.price));
    double yearSum =
        _pu.Purchased.where((item) => isThisYear(DateTime.parse(item.date)))
            .fold(0, (sum, item) => sum + double.parse(item.price));

    setState(() {
      revenue =
          NumberFormat.currency(locale: 'en_IN', symbol: '\₹').format(totalSum);
      todayRevenue =
          NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(todaySum);
      weekRevenue =
          NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(weekSum);
      monthRevenue =
          NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(monthSum);
      yearRevenue =
          NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(yearSum);
      userCount = userController.users.length.toString();
      staffCount = _staff.staffs.length.toString();
      pendingtask = _upcom.upcomings.length.toString();
      isLoading = false;
    });
  }

  bool isToday(DateTime date) {
    DateTime now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  bool isThisWeek(DateTime date) {
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    DateTime endOfWeek = startOfWeek.add(Duration(days: 6));
    return date.isAfter(startOfWeek.subtract(Duration(days: 1))) &&
        date.isBefore(endOfWeek.add(Duration(days: 1)));
  }

  bool isThisMonth(DateTime date) {
    DateTime now = DateTime.now();
    return date.year == now.year && date.month == now.month;
  }

  bool isThisYear(DateTime date) {
    DateTime now = DateTime.now();
    return date.year == now.year;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: isLoading
            ? Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Shimmer.fromColors(
                    baseColor: Colors.white12,
                    highlightColor: Colors.black38,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Container(
                              height: 136,
                              width: MediaQuery.of(context).size.width / 4,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                color: Colors.grey[300],
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Container(
                              height: 136,
                              width: MediaQuery.of(context).size.width / 4,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                color: Colors.grey[300],
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Container(
                              height: 136,
                              width: MediaQuery.of(context).size.width / 4,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                color: Colors.grey[300],
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Container(
                              height: 136,
                              width: MediaQuery.of(context).size.width / 4,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                color: Colors.grey[300],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Expanded(
                            flex: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  color: Colors.grey[300]),
                            )),
                        SizedBox(
                          height: 20,
                        ),
                        Expanded(
                            flex: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  color: Colors.grey[300]),
                            ))
                      ],
                    ),
                  ),
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      InfoCard(
                          title: "No.of Users",
                          value: userCount!,
                          onTap: () {}),
                      SizedBox(
                        width: 15,
                      ),
                      InfoCard(
                          title: "No.of Staffs",
                          value: staffCount!,
                          onTap: () {}),
                      SizedBox(
                        width: 15,
                      ),
                      InfoCard(
                          title: "Pending Tasks",
                          value: pendingtask!,
                          onTap: () {}),
                      SizedBox(
                        width: 15,
                      ),
                      InfoCard(
                          title: "Total Revenue", value: revenue!, onTap: () {})
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Ac.bNcolor,
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: SfCartesianChart(
                              primaryXAxis: DateTimeAxis(
                                dateFormat: DateFormat("yyy-MM-dd"),
                              ),
                              primaryYAxis: NumericAxis(
                                interval: 10000,
                              ),
                              series: <StackedColumnSeries>[
                                StackedColumnSeries<ChartData, DateTime>(
                                  name: "Purchased",
                                  dataSource: chartData,
                                  trackBorderColor: Colors.red,
                                  // borderColor: Colors.red,
                                  borderWidth: 1,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(1.9)),
                                  xValueMapper: (ChartData data, _) =>
                                      data.date,
                                  yValueMapper: (ChartData data, _) =>
                                      data.price,
                                )
                              ],
                              tooltipBehavior: TooltipBehavior(
                                  enable: true,
                                  activationMode: ActivationMode.singleTap),
                            ),
                          ),
                          Divider(
                            color: Colors.white,
                          ),
                          Expanded(
                              flex: 1,
                              child: Container(
                                width: MediaQuery.of(context).size.width / 2,
                                // color: Colors.white,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              "Todays Revenue",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Text(
                                              "$todayRevenue",
                                              style: GoogleFonts.montserrat(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 25,
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              "This Month",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Text(
                                              "$monthRevenue",
                                              style: GoogleFonts.montserrat(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 25,
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              "This Week",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Text(
                                              "$weekRevenue",
                                              style: GoogleFonts.montserrat(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 25,
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              "This Year",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Text(
                                              "$yearRevenue",
                                              style: GoogleFonts.montserrat(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 25,
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Obx(() {
                        if (userController.users.isEmpty) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          return Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                color: Ac.bNcolor),
                            child: SingleChildScrollView(
                              child: DataTable(
                                  columnSpacing: 30,
                                  dataRowHeight: 70,
                                  columns: [
                                    DataColumn(
                                        label: Text(
                                      "Id",
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

                                    // DataColumn(label: Text("Name")),
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
                                      "Email",
                                      style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Colors.white70),
                                    )),
                                    DataColumn(
                                        label: Text(
                                      "Address",
                                      style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Colors.white70),
                                    )),
                                  ],
                                  rows: userController.users
                                      .take(4)
                                      .map((e) => DataRow(cells: [
                                            DataCell(Text(
                                              e.id.toString(),
                                              style: GoogleFonts.montserrat(
                                                  color: Colors.white70),
                                            )),
                                            DataCell(_iamgeBox(e.image)),
                                            DataCell(Text(
                                              e.name.toString(),
                                              style: GoogleFonts.montserrat(
                                                  color: Colors.white70),
                                            )),
                                            DataCell(Text(
                                              e.email.toString(),
                                              style: GoogleFonts.montserrat(
                                                  color: Colors.white70),
                                            )),
                                            DataCell(Text(
                                              e.address.toString(),
                                              softWrap: true,
                                              style: GoogleFonts.montserrat(
                                                  color: Colors.white70),
                                            )),
                                          ]))
                                      .toList()),
                            ),
                          );
                        }
                      }),
                    ),
                  )
                ],
              ),
      ),
    );
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

class ChartData {
  final DateTime date;
  final double price;
  ChartData({required this.date, required this.price});
}

class ChartWidget extends GetxController {
  final toolTip =
      TooltipBehavior(enable: true, activationMode: ActivationMode.singleTap);
  final title = const ChartTitle(text: 'Tide');
  final x = const NumericAxis(
    interval: 1,
    labelRotation: -47,
    enableAutoIntervalOnZooming: true,
  );
  final y = const NumericAxis(
    title: AxisTitle(
      text: 'm',
      alignment: ChartAlignment.center, // Align the title to the far end
      textStyle: TextStyle(
        fontSize: 12, // Adjust the font size as needed
      ),
    ),
    isVisible: true,
    interval: 0.5,
    majorGridLines: MajorGridLines(width: 0),
    minorGridLines: MinorGridLines(width: 0),
  );
  final zoom = ZoomPanBehavior(
      enableMouseWheelZooming: false,
      enablePinching: true,
      enablePanning: true,
      enableDoubleTapZooming: true,
      enableSelectionZooming: false);
}
