import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Menus extends StatelessWidget {
  final void Function(int) ontap;
  final int currentPage;
  const Menus({super.key, required this.ontap, required this.currentPage});

  @override
  Widget build(BuildContext context) {
    List<String> menu = ['One', 'Two', 'Three', 'Four'];
    return ListView(
      children: [
        DrawerHeader(
            child: Icon(
          Icons.person,
          size: 30,
        )),
        for (int i = 0; i < menu.length; i++)
          InkWell(
            onTap: () => ontap(i),
            child: MenuContents(
              title: menu[i],
              selected: i == currentPage,
            ),
          ),
      ],
    );
  }
}

class controller1 extends GetxController {
  int number = 0;
  void changeNum(String name) {
    if (name == 'One') {
      number = 0;
      update();
    } else if (name == 'Two') {
      number = 1;
      update();
    } else if (name == 'Three') {
      number = 2;
      update();
    } else if (name == 'Four') {
      number = 3;
    }
  }
}

class MenuContents extends StatelessWidget {
  final String title;
  final bool selected;
  const MenuContents({super.key, required this.title, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
            color: selected ? Colors.red : Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: Center(
          child: ListTile(
            title: Text(
              title,
              style: GoogleFonts.montserrat(
                  fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
