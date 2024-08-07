import 'dart:convert';
import 'package:blue_wash_web/config/config.dart';
import 'package:blue_wash_web/controller/package_controller.dart';
import 'package:blue_wash_web/widgets/button.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:multi_dropdown/multiselect_dropdown.dart';

class PackageAdd extends StatefulWidget {
  const PackageAdd({super.key});
  @override
  _PackageAddState createState() => _PackageAddState();
}

class _PackageAddState extends State<PackageAdd> {
  final _formKey = GlobalKey<FormState>();
  final MultiSelectController _controller = MultiSelectController();
  final TextEditingController _packageNameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _realPriceController = TextEditingController();
  String? _selectedCarType;
  PackageController _pack = Get.put(PackageController());
  File? _image;
  final List<ValueItem> _services = [];
  final List<String> _carTypes = [];
  final List<String> _selectedServices = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    isLoading = true;
    fetchCarTypes();
    fetchServices();
  }

  Future<void> fetchCarTypes() async {
    var response = await http.get(Uri.parse("${config.base}${config.types}"));
    var data = jsonDecode(response.body);
    if (data['status'] == "success") {
      setState(() {
        _carTypes.clear();
        for (var item in data['data']) {
          _carTypes.add(item['name']);
        }
      });
    }
  }

  Future<void> fetchServices() async {
    var response =
        await http.get(Uri.parse("${config.base}${config.services}"));
    var data = jsonDecode(response.body);
    if (data['status'] == "success") {
      setState(() {
        _services.clear();
        for (var item in data['data']) {
          _services.add(ValueItem(label: item['name'], value: item['id']));
        }
        print(_services);
        isLoading = false;
      });
    }
  }

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      setState(() {
        _image = File(result.files.single.path!);
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final packageName = _packageNameController.text;
      final service = _selectedServices.join(',');
      final price = _priceController.text;
      final realPrice = _realPriceController.text;
      final carType = _selectedCarType;

      var request = http.MultipartRequest(
        'POST',
        Uri.parse("${config.base}${config.create_package}"),
      );

      request.fields['package_name'] = packageName;
      request.fields['service'] = service;
      request.fields['price'] = price;
      request.fields['real_price'] = realPrice;
      request.fields['car_type'] = carType!;

      if (_image != null) {
        request.files
            .add(await http.MultipartFile.fromPath('image', _image!.path));
      }

      try {
        final response = await request.send();
        final responseBody = await response.stream.bytesToString();

        if (response.statusCode == 200) {
          _pack.packages.clear();

          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Package added successfully')));
          Get.back();
          _pack.fetchPackages();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to add package')));
        }
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('An error occurred')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 800,
        height: 600,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Colors.black,
        ),
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
            : Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Add Packages",
                      style: GoogleFonts.montserrat(
                          color: Colors.white70,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              DropdownButtonFormField<String>(
                                hint: const Text(
                                  'Select Car Type',
                                  style: TextStyle(color: Colors.white54),
                                ),
                                value: _selectedCarType,
                                items: _carTypes.map((String carType) {
                                  return DropdownMenuItem<String>(
                                    value: carType,
                                    child: Text(carType,
                                        style: TextStyle(color: Colors.white)),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedCarType = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                dropdownColor: Colors.black,
                                iconEnabledColor: Colors.white,
                                style: TextStyle(color: Colors.white),
                              ),
                              const SizedBox(height: 25),
                              TextFormField(
                                controller: _packageNameController,
                                decoration: InputDecoration(
                                    labelText: 'Package Name',
                                    labelStyle:
                                        TextStyle(color: Colors.white54),
                                    border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white54),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white54),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white54),
                                      borderRadius: BorderRadius.circular(10.0),
                                    )),
                                style: TextStyle(color: Colors.white),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter package name';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 25),
                              MultiSelectDropDown(
                                clearIcon:
                                    Icon(Icons.close, color: Colors.white),
                                controller: _controller,
                                onOptionSelected: (options) {
                                  setState(() {
                                    _selectedServices.clear();
                                    for (var item in options) {
                                      _selectedServices.add(item.label);
                                    }
                                  });
                                },
                                options: _services,
                                suffixIcon: Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.white54,
                                ),
                                fieldBackgroundColor: Colors.white10,
                                optionsBackgroundColor: Colors.black,
                                dropdownBackgroundColor: Colors.black,
                                selectedOptionBackgroundColor: Colors.grey,
                                selectionType: SelectionType.multi,
                                chipConfig:
                                    const ChipConfig(wrapType: WrapType.wrap),
                                borderColor: Colors.white54,
                                borderWidth: 1,
                                dropdownHeight: 300,
                                optionTextStyle: GoogleFonts.ubuntu(
                                    fontSize: 16, color: Colors.white),
                                showChipInSingleSelectMode: true,
                                selectedOptionIcon: const Icon(
                                  Icons.check_circle,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 25),
                              TextFormField(
                                controller: _priceController,
                                decoration: InputDecoration(
                                    labelText: 'Price',
                                    labelStyle:
                                        TextStyle(color: Colors.white54),
                                    border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white54),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white54),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white54),
                                      borderRadius: BorderRadius.circular(10.0),
                                    )),
                                keyboardType: TextInputType.number,
                                style: TextStyle(color: Colors.white),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter price';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 25),
                              TextFormField(
                                controller: _realPriceController,
                                decoration: InputDecoration(
                                    labelText: 'Real Price',
                                    labelStyle:
                                        TextStyle(color: Colors.white54),
                                    border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white54),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white54),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white54),
                                      borderRadius: BorderRadius.circular(10.0),
                                    )),
                                keyboardType: TextInputType.number,
                                style: TextStyle(color: Colors.white),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter real price';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DottedBorder(
                              color: Colors.grey,
                              strokeWidth: 2,
                              dashPattern: [4, 4],
                              borderType: BorderType.RRect,
                              radius: Radius.circular(12),
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height / 2.3,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _image != null
                                        ? Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Image.file(
                                              _image!,
                                              height: 200,
                                              width: 200,
                                            ),
                                          )
                                        : InkWell(
                                            onTap: _pickImage,
                                            child: Image.asset(
                                              "assets/place.png",
                                              height: 200,
                                              width: 200,
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ButtonBlue2(
                      text: "Submit",
                      ontap: () async {
                        if (_formKey.currentState!.validate()) {
                          if (_image != null) {
                            await _submitForm();
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
