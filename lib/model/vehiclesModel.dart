import 'package:flutter/material.dart';

class Vehicles {
  final String id;
  final String owner;
  final String brand;
  final String model;
  final String number;
  final String color;
  final String type;
  final String id_token;
  final String address;

  Vehicles({
    required this.id,
    required this.owner,
    required this.brand,
    required this.model,
    required this.number,
    required this.color,
    required this.type,
    required this.id_token,
    required this.address,
  });

  factory Vehicles.fromJson(Map<String, dynamic> json) {
    return Vehicles(
      id: json['id'],
      owner: json['owner'],
      brand: json['brand'],
      model: json['model'],
      number: json['number'],
      color: json['color'],
      type: json['type'],
      id_token: json['id_token'],
      address: json['address'],
    );
  }
}
