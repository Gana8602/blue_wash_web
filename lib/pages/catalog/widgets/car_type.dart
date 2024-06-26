import 'dart:convert';

import 'package:blue_wash_web/config/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CarType extends StatefulWidget {
  const CarType({super.key});

  @override
  State<CarType> createState() => _CarTypeState();
}

class _CarTypeState extends State<CarType> {
  final List<Map<String, String>> _items = [];
  final TextEditingController _controller = TextEditingController();
  int count = 1;

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
    var response = await http.post(Uri.parse("${config.base}${config.addType}"),
        body: {'type_name': _controller.text});
    print(response.body);
    Get();
    _controller.clear();
  }

  Future<void> Get() async {
    var response = await http.get(Uri.parse("${config.base}${config.types}"));
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get();
  }

  Future<void> delete(String name) async {
    var response = await http.post(
        Uri.parse("${config.base}${config.deletetype}"),
        body: {'type_name': name});
    print(response.body);
    Get();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Car Type',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(labelText: 'Enter Type'),
                ),
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: Add,
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('ID')),
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text("Action"))
                ],
                rows: _items
                    .map(
                      (item) => DataRow(
                        cells: [
                          DataCell(Text("${count++}")),
                          DataCell(Text(item['name']!)),
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
