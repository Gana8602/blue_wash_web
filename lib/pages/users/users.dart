import 'package:blue_wash_web/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Users",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.white),
            ),
            Expanded(
              child: Obx(() {
                if (userController.users.isEmpty) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  UserDataSource _dataSource =
                      UserDataSource(userController.users);
                  return PaginatedDataTable(
                    header: Text('User Data'),
                    columns: [
                      DataColumn(label: Text('Username')),
                      DataColumn(label: Text('Phone Number')),
                      DataColumn(label: Text('Email')),
                      DataColumn(label: Text('Address')),
                    ],
                    source: _dataSource,
                    rowsPerPage: 10,
                    showCheckboxColumn: false,
                  );
                }
              }),
            ),
          ],
        ),
      ),
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
