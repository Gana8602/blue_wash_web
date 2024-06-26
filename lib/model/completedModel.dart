class CompletedModel {
  int id;
  String packageName;
  String completedDate;
  String token;
  String staff_name;
  String staff_token;
  String service;
  String car_number;
  String img1;
  String img2;
  String img3;

  CompletedModel(
      {required this.id,
      required this.packageName,
      required this.completedDate,
      required this.token,
      required this.staff_name,
      required this.staff_token,
      required this.service,
      required this.car_number,
      required this.img1,
      required this.img2,
      required this.img3});

  factory CompletedModel.fromJson(Map<String, dynamic> json) {
    return CompletedModel(
        id: json['id'],
        packageName: json['package_name'],
        completedDate: json['completed_date'],
        token: json['token'],
        staff_name: json['staff_name'],
        staff_token: json['staff_token'],
        service: json['service'],
        car_number: json['car_number'],
        img1: json['img1'],
        img2: json['img2'],
        img3: json['img3']);
  }
}
