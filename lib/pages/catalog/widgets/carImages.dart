import 'dart:convert';
import 'dart:io';
import 'package:blue_wash_web/widgets/button.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

import 'package:blue_wash_web/config/config.dart';

import '../../../utls/colors.dart';

class Brands {
  final String brand;
  final String model;

  Brands({
    required this.brand,
    required this.model,
  });
}

class CarImagePage extends StatefulWidget {
  const CarImagePage({Key? key}) : super(key: key);

  @override
  State<CarImagePage> createState() => _CarImagePageState();
}

class _CarImagePageState extends State<CarImagePage> {
  final List<Map<String, dynamic>> _items = [];
  final TextEditingController _controller = TextEditingController();

  String? _selectedBrand;
  String? _selectedModel;
  String? _selectedColor;
  List<Brands> _collections = [];
  List<String> _models = [];
  List<String> _brands = [];
  File? _image;
  List<String> Colorss = [];
  final picker = ImagePicker();

  Future<void> _addItem() async {
    if (_selectedBrand != null &&
        _selectedModel != null &&
        _selectedColor != null &&
        _image != null) {
      var stream = http.ByteStream(_image!.openRead());
      var length = await _image!.length();
      var uri = Uri.parse("${config.base}${config.saveCarImage}");

      var request = http.MultipartRequest("POST", uri);
      var multipartFile = http.MultipartFile('image', stream, length,
          filename: path.basename(_image!.path));
      request.fields['brand'] = _selectedBrand!;
      request.fields['model'] = _selectedModel!;
      request.fields['color'] = _selectedColor!;
      request.files.add(multipartFile);

      try {
        var response = await request.send();
        if (response.statusCode == 200) {
          var responseData = await response.stream.bytesToString();
          var jsonData = jsonDecode(responseData);
          print(jsonData); // Print server response for debugging
          if (jsonData['status'] == 'success') {
            setState(() {
              _image = null; // Clear the selected image
            });
            await _getCarImages(); // Refresh data after upload
          } else {
            print('Failed to save car image: ${jsonData['message']}');
          }
        } else {
          print('Failed to upload image. Status code: ${response.statusCode}');
        }
      } catch (e) {
        print('Error uploading image: $e');
      }
    } else {
      print('Please select all fields and an image.');
    }
  }

  Future<void> _getModels() async {
    var response = await http.get(Uri.parse("${config.base}${config.models}"));
    var data = jsonDecode(response.body);
    if (data['status'] == "success") {
      setState(() {
        _collections.clear();
        for (var item in data['data']) {
          _collections.add(Brands(brand: item['brand'], model: item['name']));
        }
        _brands = _collections.map((e) => e.brand).toSet().toList();
      });
    }
  }

  Future<void> _getBrands() async {
    var response = await http.get(Uri.parse("${config.base}${config.brands}"));
    var data = jsonDecode(response.body);
    if (data['status'] == "success") {
      setState(() {
        _brands.clear();
        for (var item in data['data']) {
          _brands.add(item['name']);
        }
      });
    }
  }

  Future<void> _getColors() async {
    var response = await http.get(Uri.parse("${config.base}${config.colors}"));
    var data = jsonDecode(response.body);
    if (data['status'] == "success") {
      setState(() {
        Colorss.clear();
        for (var item in data['data']) {
          Colorss.add(item['name']);
        }
      });
    }
  }

  Future<void> _getModelsForBrand(String brand) async {
    setState(() {
      _models.clear();
      for (var item in _collections) {
        if (item.brand == brand) {
          _models.add(item.model);
        }
      }
    });
  }

  Future<void> _getCarImages() async {
    var response =
        await http.get(Uri.parse("${config.base}${config.getCarIage}"));
    var data = jsonDecode(response.body);
    if (data['status'] == "success") {
      setState(() {
        _items.clear();
        for (var item in data['data']) {
          _items.add({
            'id': item['id'].toString(),
            'brand': item['brand'] as String,
            'model': item['model'] as String,
            'color': item['color'] as String,
            'image': item['image_url'] as String,
          });
        }
      });
    }
  }

  Future<void> _delete(String id) async {
    var response = await http.post(
      Uri.parse("${config.base}${config.delete_car_image}"),
      body: {'id': id},
    );
    print(response.body);
    await _getCarImages();
  }

  Future<void> _getImage() async {
    FilePickerResult? file = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (file != null) {
      setState(() {
        _image = File(file.files.single.path!);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getCarImages();
    _getBrands();
    _getModels();
    _getColors();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
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
          const Text(
            'Car Image',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Flexible(
                child: DropdownButtonFormField<String>(
                  dropdownColor: Colors.black,
                  hint: const Text(
                    'Select Brand',
                    style: TextStyle(color: Colors.white),
                  ),
                  value: _selectedBrand,
                  decoration: InputDecoration(
                    hintStyle: const TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  items: _brands.map((String brand) {
                    return DropdownMenuItem<String>(
                      value: brand,
                      child: Text(
                        brand,
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedBrand = value!;
                      _selectedModel = null; // Reset model selection
                      _getModelsForBrand(
                          value); // Fetch models for selected brand
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a brand';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 20),
              Flexible(
                child: DropdownButtonFormField<String>(
                  dropdownColor: Colors.black,
                  hint: const Text(
                    'Select Model',
                    style: TextStyle(color: Colors.white),
                  ),
                  value: _selectedModel,
                  decoration: InputDecoration(
                    hintStyle: const TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  items: _models.map((String model) {
                    return DropdownMenuItem<String>(
                      value: model,
                      child: Text(
                        model,
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedModel = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a model';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Flexible(
                child: DropdownButtonFormField<String>(
                  dropdownColor: Colors.black,
                  hint: const Text(
                    'Select Color',
                    style: TextStyle(color: Colors.white),
                  ),
                  value: _selectedColor,
                  decoration: InputDecoration(
                    hintStyle: const TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  items: Colorss.map((String color) {
                    return DropdownMenuItem<String>(
                      value: color,
                      child: Text(
                        color,
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedColor = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a color';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                width: 15,
              ),
              _image != null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.file(
                        _image!,
                        height: 40,
                        width: 200,
                      ),
                    )
                  : DottedBorder(
                      color: Colors.grey,
                      strokeWidth: 2,
                      dashPattern: [4, 4],
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 40,
                          width: 100,
                          decoration: const BoxDecoration(),
                          child: Center(
                            child: InkWell(
                              onTap: _getImage,
                              child: Image.asset(
                                "assets/place.png",
                                height: 200,
                                width: 200,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
          const SizedBox(height: 10),
          ButtonBlue2(text: "Add", ontap: _addItem),
          // ElevatedButton.icon(
          //   icon: const Icon(Icons.add),
          //   label: const Text('Add'),
          //   onPressed: _addItem,
          // ),
          // const SizedBox(height: 10),
          // const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                return Container(
                  width: constraints.maxWidth * 2.3,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
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
                          'Brand',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                        DataColumn(
                            label: Text(
                          'Model',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                        DataColumn(
                            label: Text(
                          'Color',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                        DataColumn(
                            label: Text(
                          'Image',
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
                        )),
                      ],
                      rows: _items
                          .asMap()
                          .entries
                          .map(
                            (entry) => DataRow(
                              cells: [
                                DataCell(Text("${entry.key + 1}")),
                                DataCell(Text(
                                  entry.value['brand'] as String,
                                  style: const TextStyle(color: Colors.white),
                                )),
                                DataCell(Text(
                                  entry.value['model'] as String,
                                  style: const TextStyle(color: Colors.white),
                                )),
                                DataCell(Text(
                                  entry.value['color'] as String,
                                  style: const TextStyle(color: Colors.white),
                                )),
                                DataCell(
                                  Image.network(
                                    "${config.base}${entry.value['image']}",
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                DataCell(
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      _delete(entry.value['id'] as String);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          )
                          .toList(),
                    ),
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
