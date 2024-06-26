class StaffModel {
  String id;
  String name;
  String uName;
  String phone;
  String token;

  StaffModel({
    required this.id,
    required this.name,
    required this.uName,
    required this.phone,
    required this.token,
  });

  factory StaffModel.fromJson(Map<String, dynamic> json) {
    return StaffModel(
        id: json['id'],
        name: json['name'],
        uName: json['username'],
        phone: json['phone_number'],
        token: json['token']);
  }
}
