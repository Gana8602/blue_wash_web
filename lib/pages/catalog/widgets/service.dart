import 'dart:convert';

import 'package:blue_wash_web/config/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Services extends StatefulWidget {
  const Services({super.key});

  @override
  State<Services> createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
  final List<Map<String, String>> _items = [];
  final TextEditingController _controller = TextEditingController();
  int count = 1;

  Future<void> Add() async {
    var response = await http.post(
        Uri.parse("${config.base}${config.addService}"),
        body: {'service_name': _controller.text});
    print(response.body);
    Get();
    _controller.clear();
  }

  Future<void> Get() async {
    var response =
        await http.get(Uri.parse("${config.base}${config.services}"));
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
        Uri.parse("${config.base}${config.deleteService}"),
        body: {'service_name': name});
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
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Services',
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
                  decoration: InputDecoration(labelText: 'Enter Service'),
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
