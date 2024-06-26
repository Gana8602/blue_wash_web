import 'package:blue_wash_web/pages/tasks/tabs/complted.dart';
import 'package:blue_wash_web/pages/tasks/tabs/upcoming.dart';
import 'package:blue_wash_web/utls/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage>
    with SingleTickerProviderStateMixin {
  late TabController _controller = TabController(length: 2, vsync: this);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        title: Text(
          "SERVICES",
          style: GoogleFonts.montserrat(
              fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              height: 30,
              color: Colors.black,
              child: TabBar(
                  dividerColor: Colors.black,
                  indicatorWeight: 2.0,
                  indicatorPadding: EdgeInsets.zero,
                  indicatorColor: Ac.Tcolor,
                  controller: _controller,
                  tabs: [
                    Text(
                      "Task List",
                      style: GoogleFonts.montserrat(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Completed",
                      style: GoogleFonts.montserrat(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    )
                  ]),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: TabBarView(
                  controller: _controller,
                  children: [UpcomingPage(), CompletedPage()]),
            ),
          ],
        ),
      ),
    );
  }
}
