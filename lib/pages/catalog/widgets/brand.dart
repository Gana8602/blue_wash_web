import 'dart:convert';

import 'package:blue_wash_web/config/config.dart';
import 'package:blue_wash_web/utls/colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Brand extends StatefulWidget {
  const Brand({Key? key}) : super(key: key);

  @override
  State<Brand> createState() => _BrandState();
}

class _BrandState extends State<Brand> {
  final List<Map<String, String>> _items = [];
  final TextEditingController _controller = TextEditingController();
  int count = 1;
  int id = 0;

  void _addItem() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _items.add({
          'id': (_items.length + 1).toString(),
          'name': _controller.text,
        });
        _controller.clear();
      });
    }
  }

  Future<void> Add() async {
    var response = await http.post(
        Uri.parse("${config.base}${config.addBrand}"),
        body: {'brand_name': _controller.text});
    print(response.body);
    Get();
    _controller.clear();
  }

  Future<void> Get() async {
    var response = await http.get(Uri.parse("${config.base}${config.brands}"));
    print(response.body);
    var data = jsonDecode(response.body);
    if (data['status'] == "success") {
      _items.clear();
      for (var item in data['data'])
        setState(() {
          _items.add({
            'id': (item['id'] as String),
            'name': (item['name'] as String),
          });
        });
    }
  }

  Future<void> delete(String name) async {
    var response = await http.post(
        Uri.parse("${config.base}${config.deleteBrand}"),
        body: {'brand_name': name});
    print(response.body);
    Get();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Ac.bNcolor,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3))
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Brand',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                      labelText: 'Enter Brand',
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      )),
                ),
              ),
              IconButton(
                  icon: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Add();
                  }),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: DataTable(
                columnSpacing: 100,
                columns: const [
                  DataColumn(
                      label: Text(
                    'ID',
                    style: TextStyle(color: Colors.white),
                  )),
                  DataColumn(
                      label: Text(
                    'Name',
                    style: TextStyle(color: Colors.white),
                  )),
                  DataColumn(
                      label: Text(
                    'Actions',
                    style: TextStyle(color: Colors.white),
                  )),
                ],
                rows: _items
                    .map(
                      (item) => DataRow(
                        cells: [
                          DataCell(Text(
                            "${count++}",
                            style: TextStyle(color: Colors.white),
                          )),
                          DataCell(Text(
                            item['name']!,
                            style: TextStyle(color: Colors.white),
                          )),
                          DataCell(IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              delete(item['name']!);
                            },
                          ))
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
