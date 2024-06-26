import 'package:blue_wash_web/utls/colors.dart';
import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final Color? topColor;
  final bool isActive;
  final Function() onTap;

  const InfoCard(
      {Key? key,
      required this.title,
      required this.value,
      this.isActive = false,
      required this.onTap,
      this.topColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 136,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Ac.bNcolor,
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 6),
                color: Ac.lightGrey.withOpacity(.1),
                blurRadius: 12,
              ),
            ],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: Container(
                    color: topColor,
                    height: 5,
                  ))
                ],
              ),
              Expanded(child: Container()),
              RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(children: [
                    TextSpan(
                        text: "$title\n",
                        style: TextStyle(fontSize: 16, color: Colors.white70)),
                    TextSpan(
                        text: value,
                        style: TextStyle(fontSize: 40, color: Colors.white)),
                  ])),
              Expanded(child: Container()),
            ],
          ),
        ),
      ),
    );
  }
}
