import 'package:blue_wash_web/model/purchase_model.dart';
import 'package:blue_wash_web/service/purchase_service.dart';
import 'package:get/get.dart';

class PurchaseController extends GetxController {
  var Purchased = <PurchaseModel>[].obs;

  Future<void> fetchpurchase() async {
    var response = await PurchaseServce().fetchPurchased();
    if (response != null && response is List<PurchaseModel>) {
      Purchased.assignAll(response.reversed);
    } else {
      Purchased.assignAll([]);
    }
  }
}
