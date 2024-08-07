class PurchaseModel {
  String id;
  String name;
  String phone;
  String email;
  String package_name;
  String car_number;
  String carType;
  String price;
  String token;
  String image;
  String player_id;
  String InvoiceId;
  String date;

  PurchaseModel(
      {required this.id,
      required this.name,
      required this.phone,
      required this.email,
      required this.car_number,
      required this.package_name,
      required this.carType,
      required this.price,
      required this.token,
      required this.image,
      required this.player_id,
      required this.InvoiceId,
      required this.date});

  factory PurchaseModel.fromJson(Map<String, dynamic> json) {
    return PurchaseModel(
        id: json['id'],
        name: json['name'],
        phone: json['phone'],
        email: json['email'],
        car_number: json['car_number'],
        carType: json['car_type'],
        package_name: json['package_name'],
        price: json['price'],
        token: json['token'],
        image: json['image'] ?? "",
        player_id: json['player_id'] ?? "",
        InvoiceId: json['invoice_id'] ?? "",
        date: json['created_at'] ?? "");
  }
}
