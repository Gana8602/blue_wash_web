class UpcomingModel {
  int id;
  String packageName;
  String date;
  String token;
  String staff_name;
  String staff_token;
  String service;
  String car_number;

  UpcomingModel({
    required this.id,
    required this.packageName,
    required this.date,
    required this.token,
    required this.staff_name,
    required this.staff_token,
    required this.service,
    required this.car_number,
  });

  factory UpcomingModel.fromJson(Map<String, dynamic> json) {
    return UpcomingModel(
        id: json['id'],
        packageName: json['package_name'],
        date: json['selected_date'],
        token: json['token'],
        staff_name: json['staff_name'],
        staff_token: json['staff_token'],
        service: json['service'],
        car_number: json['car_number']);
  }
}
