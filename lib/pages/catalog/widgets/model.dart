import 'dart:convert';

import 'package:blue_wash_web/config/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../utls/colors.dart';

class Model extends StatefulWidget {
  const Model({super.key});

  @override
  State<Model> createState() => _ModelState();
}

class _ModelState extends State<Model> {
  final List<Map<String, String>> _items = [];
  final TextEditingController _controller = TextEditingController();
  int count = 1;
  String? _selectedBrand;
  List<String> _brands = [];

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
        Uri.parse("${config.base}${config.addModel}"),
        body: {'model_name': _controller.text, 'brand': _selectedBrand});
    print(response.body);
    _controller.clear();

    Get();
  }

  Future<void> getBrands() async {
    var response = await http.get(Uri.parse("${config.base}${config.brands}"));
    print(response.body);
    var data = jsonDecode(response.body);
    if (data['status'] == "success") {
      _brands.clear();
      for (var item in data['data'])
        setState(() {
          _brands.add(
            (item['name'] as String),
          );
        });
    }
  }

  Future<void> Get() async {
    var response = await http.get(Uri.parse("${config.base}${config.models}"));
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
        Uri.parse("${config.base}${config.deleteModel}"),
        body: {'model_name': name});
    print(response.body);
    Get();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get();
    getBrands();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Ac.bNcolor,
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        boxShadow: [
          BoxShadow(
            color: Colors.white10.withOpacity(0.5),
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 50,
            child: Row(
              children: [
                Text(
                  'Model',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Flexible(
                  child: DropdownButtonFormField<String>(
                    hint: const Text(
                      'Select Brand',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    decoration: InputDecoration(
                        hintStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                    value: _selectedBrand,
                    items: _brands.map((String service) {
                      return DropdownMenuItem<String>(
                        value: service,
                        child: Text(
                          service,
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedBrand = value!;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a service';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    labelText: 'Enter Model',
                    labelStyle: const TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  gradient: Ac.bbg,
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
                child: IconButton(
                  icon: const Icon(Icons.add, color: Colors.white),
                  onPressed: Add,
                ),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                return Container(
                  width: constraints.maxWidth * 2.3,
                  child: DataTable(
                    columns: const [
                      DataColumn(
                          label: Text(
                        'ID',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                      DataColumn(
                          label: Text(
                        'Name',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                      DataColumn(
                          label: Text(
                        'Action',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ))
                    ],
                    rows: _items
                        .map(
                          (item) => DataRow(
                            cells: [
                              DataCell(Text(
                                "${count++}",
                                style: const TextStyle(color: Colors.white),
                              )),
                              DataCell(Text(
                                item['name']!,
                                style: const TextStyle(color: Colors.white),
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
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
