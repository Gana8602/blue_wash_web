import 'dart:convert';

import 'package:blue_wash_web/config/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../utls/colors.dart';

class ColorAdd extends StatefulWidget {
  const ColorAdd({Key? key}) : super(key: key);

  @override
  State<ColorAdd> createState() => _ColorAddState();
}

class _ColorAddState extends State<ColorAdd> {
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
        Uri.parse("${config.base}${config.addColor}"),
        body: {'color': _controller.text});
    print(response.body);
    Get();
    _controller.clear();
  }

  Future<void> Get() async {
    var response = await http.get(Uri.parse("${config.base}${config.colors}"));
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
        Uri.parse("${config.base}${config.deleteColor}"),
        body: {'color': name});
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
          Text(
            'Colors',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    labelText: 'Enter Color',
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
                        'Actions',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
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
