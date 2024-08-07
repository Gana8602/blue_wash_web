import 'dart:convert';

import 'package:blue_wash_web/config/config.dart';
import 'package:blue_wash_web/model/vehiclesModel.dart';
import 'package:http/http.dart' as http;

class VehicleService {
  Future<dynamic> fetchVehicles() async {
    var response = await http.get(Uri.parse("${config.base}${config.cars}"));
    var data = jsonDecode(response.body);
    if (data['status'] == 'success') {
      List<dynamic> list = data['data'];
      List<Vehicles> vehicle = list.map((e) => Vehicles.fromJson(e)).toList();
      return vehicle;
    } else {
      return null;
    }
  }
}
