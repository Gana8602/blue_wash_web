class PurchaseModel {
  String id;
  String name;
  String phone;
  String package_name;
  String car_number;
  String price;
  String token;

  PurchaseModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.car_number,
    required this.package_name,
    required this.price,
    required this.token,
  });

  factory PurchaseModel.fromJson(Map<String, dynamic> json) {
    return PurchaseModel(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      car_number: json['car_number'],
      package_name: json['package_name'],
      price: json['price'],
      token: json['token'],
    );
  }
}
