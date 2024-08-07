class Packages {
  String id;
  String package_name;
  String service;
  String price;
  String real_price;
  String car_type;
  String image_path;

  Packages({
    required this.id,
    required this.package_name,
    required this.service,
    required this.price,
    required this.real_price,
    required this.car_type,
    required this.image_path,
  });

  factory Packages.fromJson(Map<String, dynamic> json) {
    return Packages(
      id: json['id'],
      package_name: json['package_name'],
      service: json['service'],
      price: json['price'],
      real_price: json['real_price'],
      car_type: json['car_type'],
      image_path: json['image_path'],
    );
  }
}
