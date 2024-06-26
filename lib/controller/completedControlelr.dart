import 'package:blue_wash_web/model/completedModel.dart';
import 'package:blue_wash_web/service/completedService.dart';
import 'package:get/get.dart';

class CompletedController extends GetxController {
  var completed = <CompletedModel>[].obs;

  Future<void> fetchCompleted() async {
    var response = await CompletedService().getCompleted();
    if (response != null && response is List<CompletedModel>) {
      completed.assignAll(response.reversed);
    } else {
      completed.assignAll([]);
    }
  }
}
