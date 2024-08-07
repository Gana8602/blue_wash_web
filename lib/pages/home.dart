import 'package:blue_wash_web/pages/Add_package/Packages.dart';
import 'package:blue_wash_web/pages/ProfilePage/profile.dart';
import 'package:blue_wash_web/pages/catalog/catalog.dart';
import 'package:blue_wash_web/pages/catalog/widgets/carImages.dart';
import 'package:blue_wash_web/pages/home/home.dart';
import 'package:blue_wash_web/pages/purchased/purchased.dart';
import 'package:blue_wash_web/pages/staffs/staffsPage.dart';
import 'package:blue_wash_web/pages/staffs/staffs_add.dart';
import 'package:blue_wash_web/pages/tasks/TaskPage.dart';
import 'package:blue_wash_web/pages/users/users.dart';
import 'package:blue_wash_web/pages/vehicles/vehicles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Add_package/add_package.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentPage = 0;
  bool isExpand = false;
  List<IconData> icon = [
    CupertinoIcons.chart_bar_alt_fill,
    Icons.supervised_user_circle_sharp,
    CupertinoIcons.cart_fill,
    CupertinoIcons.car_detailed,
    CupertinoIcons.collections_solid,
    CupertinoIcons.circle_grid_3x3_fill,
    Icons.person_add_sharp,
    Icons.task
  ];
  List<String> names = [
    "Home",
    "Users",
    "cars",
    "Vehicles",
    "Mail",
    "Catalog",
    "Staffs",
    "Tasks",
  ];

  int person = 7;
  @override
  Widget build(BuildContext context) {
    double sheight = MediaQuery.of(context).size.height;
    double swidth = MediaQuery.of(context).size.width;

    return Scaffold(
        body: Row(
      children: [
        Container(
            height: sheight,
            width: isExpand ? 150 : 50,
            color: Colors.black,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  height: sheight / 1.2,
                  child: ListView.builder(
                      itemCount: icon.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      currentPage = index;
                                    });
                                  },
                                  icon: Icon(
                                    icon[index],
                                    color: currentPage == index
                                        ? Colors.white
                                        : Colors.grey,
                                  )),
                              isExpand
                                  ? InkWell(
                                      onTap: () {
                                        setState(() {
                                          currentPage = index;
                                        });
                                      },
                                      child: Text(
                                        names[index],
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: currentPage == index
                                                ? Colors.white
                                                : Colors.grey),
                                      ),
                                    )
                                  : const SizedBox(
                                      width: 1,
                                      height: 1,
                                    ),
                            ],
                          ),
                        );
                      }),
                ),
                const Spacer(),
                InkWell(
                  onTap: () {
                    setState(() {
                      currentPage = person + 1;
                    });
                  },
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: const BoxDecoration(
                              color: Colors.grey,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          child: Icon(
                            Icons.person,
                            size: 20,
                            color: currentPage == 8 ? Colors.white : null,
                          ),
                        ),
                      ),
                      isExpand
                          ? Text(
                              "Account",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: currentPage == 8
                                      ? Colors.white
                                      : Colors.grey),
                            )
                          : const SizedBox(
                              height: 1,
                              width: 1,
                            )
                    ],
                  ),
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        isExpand = !isExpand;
                      });
                    },
                    icon: Icon(isExpand
                        ? Icons.arrow_back_ios
                        : Icons.arrow_forward_ios_outlined)),
              ],
            )),
        Flexible(
          child: SizedBox(
              height: sheight,
              width: swidth,
              child: PageChanger(
                page: currentPage,
              )),
        )
      ],
    ));
  }
}

class PageChanger extends StatelessWidget {
  final int page;
  const PageChanger({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    if (page == 0) {
      return const HomePage();
    } else if (page == 1) {
      return const UsersPage();
    } else if (page == 2) {
      return const PurchasedPage();
    } else if (page == 3) {
      return const VehiclesPage();
    } else if (page == 4) {
      return const PackagesPage();
    } else if (page == 5) {
      return const Catalog();
    } else if (page == 6) {
      return const StaffsPage();
    } else if (page == 7) {
      return const TaskPage();
    } else if (page == 8) {
      return const Profilepgae();
    } else {
      return const Con1();
    }
  }
}

class Con1 extends StatelessWidget {
  const Con1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
    );
  }
}

class Con2 extends StatelessWidget {
  const Con2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
    );
  }
}

class Con3 extends StatelessWidget {
  const Con3({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black45,
    );
  }
}

class Con4 extends StatelessWidget {
  const Con4({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black38,
    );
  }
}
