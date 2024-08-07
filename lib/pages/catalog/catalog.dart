import 'package:blue_wash_web/pages/catalog/widgets/brand.dart';
import 'package:blue_wash_web/pages/catalog/widgets/carImages.dart';
import 'package:blue_wash_web/pages/catalog/widgets/car_type.dart';
import 'package:blue_wash_web/pages/catalog/widgets/colors.dart';
import 'package:blue_wash_web/pages/catalog/widgets/model.dart';
import 'package:blue_wash_web/pages/catalog/widgets/service.dart';
import 'package:flutter/material.dart';

class Catalog extends StatefulWidget {
  const Catalog({super.key});

  @override
  State<Catalog> createState() => _CatalogState();
}

class _CatalogState extends State<Catalog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
                child: GridView(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, crossAxisSpacing: 30, mainAxisSpacing: 30),
              children: const [
                Brand(),
                Model(),
                CarType(),
                Services(),
                ColorAdd(),
                CarImagePage()
              ],
            )),
          ],
        ),
      ),
    );
  }
}
