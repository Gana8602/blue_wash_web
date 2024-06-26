import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

import 'package:blue_wash_web/config/config.dart';

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

  int count = 1;
  String? _selectedBrand;
  String? _selectedModel;
  String? _selectedColor;
  List<Brands> _collections = [];
  List<String> _models = [];
  List<String> _brands = [];
  late File _image;
  List<String> Colorss = [];
  final picker = ImagePicker();

  Future<void> _addItem() async {
    if (_selectedBrand != null &&
        _selectedModel != null &&
        _selectedColor != null &&
        _image != null) {
      var stream = http.ByteStream(_image!.openRead());
      var length = await _image!.length();
      var uri = Uri.parse(
          "${config.base}${config.saveCarImage}"); // Replace with your server URL

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
              _image = File(""); // Clear the selected image
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
      print(data);
      setState(() {
        _collections.clear();

        for (var item in data['data']) {
          _collections.add(Brands(brand: item['brand'], model: item['name']));
        }

        // Populate brands list
        _brands.clear();
        _brands = _collections.map((e) => e.brand).toSet().toList();
      });
    }
  }

  Future<void> _getBrands() async {
    var response = await http.get(Uri.parse("${config.base}${config.brands}"));
    var data = jsonDecode(response.body);
    if (data['status'] == "success") {
      print(data);
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
      print(data);
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
            'id': item['id'] as String,
            // 'name': item['name'] as String,
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
    var response = await http
        .post(Uri.parse("${config.base}${config.delete_car_image}"), body: {
      'id': id,
    });
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
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 50,
            child: Row(
              children: [
                Text(
                  'Car Image',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 20),
                Flexible(
                  child: DropdownButtonFormField<String>(
                    hint: const Text('Select Brand'),
                    value: _selectedBrand,
                    items: _brands.map((String brand) {
                      return DropdownMenuItem<String>(
                        value: brand,
                        child: Text(brand),
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
                SizedBox(width: 20),
                Flexible(
                  child: DropdownButtonFormField<String>(
                    hint: const Text('Select Model'),
                    value: _selectedModel,
                    items: _models.map((String model) {
                      return DropdownMenuItem<String>(
                        value: model,
                        child: Text(model),
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
          ),
          DropdownButtonFormField<String>(
            hint: const Text('Select Color'),
            value: _selectedColor,
            items: Colorss.map((String color) {
              return DropdownMenuItem<String>(
                value: color,
                child: Text(color),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedColor = value!;
              });
            },
            validator: (value) {
              if (value == null) {
                return 'Please select a model';
              }
              return null;
            },
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: Icon(Icons.image),
                  label: Text('Select Image'),
                  onPressed: _getImage,
                ),
              ),
              SizedBox(width: 20),
              ElevatedButton.icon(
                icon: Icon(Icons.add),
                label: Text('Add'),
                onPressed: _addItem,
              ),
            ],
          ),
          SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('ID')),
                  DataColumn(label: Text('Brand')),
                  DataColumn(label: Text('Model')),
                  DataColumn(label: Text('Image')),
                  DataColumn(label: Text('Action')),
                ],
                rows: _items
                    .map(
                      (item) => DataRow(
                        cells: [
                          DataCell(Text("${count++}")),
                          DataCell(Text(item['brand'] as String)),
                          DataCell(Text(item['model'] as String)),
                          DataCell(
                            Image.network(
                              "${config.base}${item['image']}",
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          DataCell(
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                _delete(item['id'] as String);
                              },
                            ),
                          ),
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
