import 'package:blue_wash_web/model/staffs_model.dart';
import 'package:blue_wash_web/service/staff_service.dart';
import 'package:get/get.dart';

class StaffController extends GetxController {
  var staffs = <StaffModel>[].obs;

  Future<void> fetchStaffs() async {
    var responsee = await StaffService().fetchStaff();

    if (responsee != null && responsee is List<StaffModel>) {
      return staffs.assignAll(responsee);
    } else {
      return staffs.assignAll([]);
    }
  }
}
