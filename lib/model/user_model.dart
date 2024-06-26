class Users {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String address;

  Users(
      {required this.id,
      required this.name,
      required this.phone,
      required this.email,
      required this.address});

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
        id: json['id'],
        name: json['username'],
        phone: json['phone_number'],
        email: json['emailid'],
        address: json['address']);
  }
}
