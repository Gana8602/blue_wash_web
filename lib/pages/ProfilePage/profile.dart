import 'package:blue_wash_web/pages/ProfilePage/wid/add_admin.dart';
import 'package:flutter/material.dart';

class Profilepgae extends StatefulWidget {
  const Profilepgae({super.key});

  @override
  State<Profilepgae> createState() => _ProfilepgaeState();
}

class _ProfilepgaeState extends State<Profilepgae> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.black,
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 1.6,
            child: Row(
              children: [
                CreateAdmin(),
                Expanded(
                    child: Container(
                  color: Colors.black,
                  // width: MediaQuery.of(context).size.width / 1.6,
                ))
              ],
            ),
          ),
          Expanded(child: Container(color: Colors.black))
        ],
      ),
    );
  }
}
