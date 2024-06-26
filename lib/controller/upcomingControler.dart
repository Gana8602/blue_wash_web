import 'package:blue_wash_web/model/upcomingModel.dart';
import 'package:blue_wash_web/service/upcomingService.dart';
import 'package:get/get.dart';

class UpcomingController extends GetxController {
  var upcomings = <UpcomingModel>[].obs;

  Future<void> fetchUpcoming() async {
    var response = await UpcomingService().getupcoming();
    if (response != null && response is List<UpcomingModel>) {
      upcomings.assignAll(response.reversed);
    } else {
      upcomings.assignAll([]);
    }
  }
}
