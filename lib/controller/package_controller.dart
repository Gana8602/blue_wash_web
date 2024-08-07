import 'package:blue_wash_web/model/packages_model.dart';
import 'package:blue_wash_web/service/packages_service.dart';
import 'package:get/get.dart';

class PackageController extends GetxController {
  var packages = <Packages>[].obs;
  Future<void> fetchPackages() async {
    var response = await PackageService().getPackages();
    if (response != null && response is List<Packages>) {
      packages.assignAll(response);
    } else {
      packages.assignAll([]);
    }
  }
}
