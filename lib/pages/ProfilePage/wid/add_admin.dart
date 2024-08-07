import 'package:blue_wash_web/config/config.dart';
import 'package:blue_wash_web/config/value.dart';
import 'package:flutter/material.dart';

class CreateAdmin extends StatefulWidget {
  const CreateAdmin({super.key});

  @override
  State<CreateAdmin> createState() => _CreateAdminState();
}

class _CreateAdminState extends State<CreateAdmin> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      width: MediaQuery.of(context).size.width / 3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                image: DecorationImage(
                    image: NetworkImage("${config.base}${Valuess.image}"),
                    fit: BoxFit.cover)),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            // crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "        ${Valuess.Name}",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    color: Colors.amberAccent,
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                child: Center(
                  child: Text(
                    Valuess.role,
                    style: TextStyle(color: Colors.black, fontSize: 7),
                  ),
                ),
              )
            ],
          ),
          Text(
            "@${Valuess.username}",
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
          SizedBox(
            height: 10,
          ),
          Text(Valuess.phone,
              style: TextStyle(color: Colors.white, fontSize: 15)),
          SizedBox(
            height: 10,
          ),
          Text(Valuess.email,
              style: TextStyle(color: Colors.white, fontSize: 15))
        ],
      ),
    );
  }
}
