import 'package:blue_wash_web/config/config.dart';
import 'package:blue_wash_web/controller/user_controller.dart';
import 'package:blue_wash_web/utls/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../model/user_model.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final UserController userController = Get.put(UserController());

  @override
  void initState() {
    super.initState();
    userController.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Users",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.white),
                ),
              ),
              Expanded(
                child: Obx(() {
                  if (userController.users.isEmpty) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    // UserDataSource _dataSource =
                    //     UserDataSource(userController.users);
                    // return PaginatedDataTable(
                    //   header: Text('User Data'),
                    //   columns: [
                    //     DataColumn(label: Text('Username')),
                    //     DataColumn(label: Text('Phone Number')),
                    //     DataColumn(label: Text('Email')),
                    //     DataColumn(label: Text('Address')),
                    //   ],
                    //   source: _dataSource,
                    //   rowsPerPage: 10,
                    //   showCheckboxColumn: false,
                    // );
                    return Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Ac.bNcolor),
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
                            DataColumn(
                                label: Text(
                              "Action",
                              style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.white70),
                            )),
                          ],
                          rows: userController.users
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
                                    DataCell(Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ))
                                  ]))
                              .toList()),
                    );
                  }
                }),
              ),
            ],
          ),
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

class UserDataSource extends DataTableSource {
  final List<Users> _users;
  UserDataSource(this._users);

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= _users.length) {
      return null;
    }
    final user = _users[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(user.name)),
        DataCell(Text(user.phone)),
        DataCell(Text(user.email)),
        DataCell(Text(user.address, softWrap: true)),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _users.length;

  @override
  int get selectedRowCount => 0;
}
