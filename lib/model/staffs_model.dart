class StaffModel {
  String id;
  String name;
  String uName;
  String phone;
  String token;
  String email;
  String image;

  StaffModel(
      {required this.id,
      required this.name,
      required this.uName,
      required this.phone,
      required this.token,
      required this.email,
      required this.image});

  factory StaffModel.fromJson(Map<String, dynamic> json) {
    return StaffModel(
        id: json['id'],
        name: json['name'],
        uName: json['username'],
        phone: json['phone_number'],
        token: json['token'],
        email: json['email'],
        image: json['image']);
  }
}
