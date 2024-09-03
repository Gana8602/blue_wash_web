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

class PurchaseController2 extends GetxController {
  var Purchased2 = <PurchaseModel2>[].obs;

  Future<void> fetchpurchase() async {
    var response = await PurchaseServce2().fetchPurchased();
    if (response != null && response is List<PurchaseModel2>) {
      Purchased2.assignAll(response.reversed);
    } else {
      Purchased2.assignAll([]);
    }
  }
}
