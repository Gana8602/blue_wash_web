import 'package:blue_wash_web/utls/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ButtonBlue2 extends StatelessWidget {
  final String text;
  final void Function()? ontap;
  const ButtonBlue2({super.key, required this.text, required this.ontap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Container(
        // height: 80,
        // color: Colors.amber,
        child: Center(
          child: Container(
            // height: 50,
            // width: 300,
            decoration: BoxDecoration(
                gradient: Ac.bbg,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      text,
                      style: GoogleFonts.openSans(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),

                    // Text(
                    //   ">",
                    //   style: TextStyle(
                    //       color: Colors.white,
                    //       fontSize: 23,
                    //       fontWeight: FontWeight.bold),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
