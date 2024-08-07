import 'package:blue_wash_web/model/vehiclesModel.dart';
import 'package:blue_wash_web/service/vehicleService.dart';
import 'package:get/get.dart';

class VehicleController extends GetxController {
  var vehicle = <Vehicles>[].obs;

  Future<void> fetch() async {
    var response = await VehicleService().fetchVehicles();
    if (response != null && response is List<Vehicles>) {
      vehicle.assignAll(response);
    } else {
      vehicle.assignAll([]);
    }
  }
}
