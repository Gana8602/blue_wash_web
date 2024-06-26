import 'package:blue_wash_web/pages/home/widget/infoCard.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OverviewCardsLargeScreen extends StatefulWidget {
  const OverviewCardsLargeScreen({super.key});

  @override
  State<OverviewCardsLargeScreen> createState() =>
      _OverviewCardsLargeScreenState();
}

class _OverviewCardsLargeScreenState extends State<OverviewCardsLargeScreen> {
  // int overallPackageCount = 0;

  // Future<void> getCurrentPackageCount() async {
  //   // Query all users' current packages
  //   QuerySnapshot querySnapshot =
  //       await FirebaseFirestore.instance.collection("users").get();

  //   int totalCount = 0;

  //   // Iterate through each user document
  //   for (QueryDocumentSnapshot userDoc in querySnapshot.docs) {
  //     // Get the 'CurentPackage' field from each user document
  //     List<dynamic>? currentPackages = userDoc.data()['CurentPackage'];

  //     // If currentPackages is not null and contains data, update totalCount
  //     if (currentPackages != null && currentPackages.isNotEmpty) {
  //       totalCount += currentPackages.length;
  //     }
  //   }

  //   // Update overallPackageCount state
  //   setState(() {
  //     overallPackageCount = totalCount;
  //   });
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   getCurrentPackageCount();
  // }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Row(
      children: [
        // StreamBuilder<QuerySnapshot>(
        //   stream: FirebaseFirestore.instance.collection('users').snapshots(),
        //   builder: (context, snapshot) {
        //     if (snapshot.connectionState == ConnectionState.waiting) {
        //       return Center(
        //         child: CircularProgressIndicator(),
        //       );
        //     }

        //     if (snapshot.hasError) {
        //       return Center(
        //         child: Text('Error: ${snapshot.error}'),
        //       );
        //     }

        //     int totalPackageCount = 0;

        //     final List<DocumentSnapshot> userDocuments = snapshot.data!.docs;
        //     for (DocumentSnapshot userDoc in userDocuments) {
        //       final userData = userDoc.data() as Map<String, dynamic>?;
        //       if (userData != null && userData.containsKey('CurentPackage')) {
        //         totalPackageCount += (userData['CurentPackage'] as List).length;
        //       }
        //     }

        //     return InfoCard(
        //       title: "Orders List",
        //       value: totalPackageCount.toString(),
        //       onTap: () {},
        //       topColor: Colors.orange,
        //     );
        //   },
        // ),
        SizedBox(
          width: width / 64,
        ),
        // StreamBuilder<QuerySnapshot>(
        //   stream: FirebaseFirestore.instance.collection('users').snapshots(),
        //   builder: (context, snapshot) {
        //     if (snapshot.connectionState == ConnectionState.waiting) {
        //       return Center(
        //         child: CircularProgressIndicator(),
        //       );
        //     }

        //     if (snapshot.hasError) {
        //       return Center(
        //         child: Text('Error: ${snapshot.error}'),
        //       );
        //     }

        //     int totalupcomingCount = 0;

        //     final List<DocumentSnapshot> userDocuments = snapshot.data!.docs;
        //     for (DocumentSnapshot userDoc in userDocuments) {
        //       final userData = userDoc.data() as Map<String, dynamic>?;
        //       if (userData != null && userData.containsKey('upcoming')) {
        //         totalupcomingCount += (userData['upcoming'] as List).length;
        //       }
        //     }

        //     return InfoCard(
        //       title: "Upcoming Services",
        //       value: totalupcomingCount.toString(),
        //       topColor: Colors.lightGreen,
        //       onTap: () {},
        //     );
        //   },
        // ),
        SizedBox(
          width: width / 64,
        ),
        // StreamBuilder<QuerySnapshot>(
        //   stream: FirebaseFirestore.instance.collection('users').snapshots(),
        //   builder: (context, snapshot) {
        //     if (snapshot.connectionState == ConnectionState.waiting) {
        //       return Center(
        //         child: CircularProgressIndicator(),
        //       );
        //     }

        //     if (snapshot.hasError) {
        //       return Center(
        //         child: Text('Error: ${snapshot.error}'),
        //       );
        //     }

        //     int totalcompletedCount = 0;

        //     final List<DocumentSnapshot> userDocuments = snapshot.data!.docs;
        //     for (DocumentSnapshot userDoc in userDocuments) {
        //       final userData = userDoc.data() as Map<String, dynamic>?;
        //       if (userData != null && userData.containsKey('Completed')) {
        //         totalcompletedCount += (userData['Completed'] as List).length;
        //       }
        //     }

        //     return InfoCard(
        //       title: "Completed Services",
        //       value: totalcompletedCount.toString(),
        //       topColor: Colors.redAccent,
        //       onTap: () {},
        //     );
        //   },
        // ),
        SizedBox(
          width: width / 64,
        ),
        // StreamBuilder<QuerySnapshot>(
        //   stream: FirebaseFirestore.instance.collection('users').snapshots(),
        //   builder: (context, snapshot) {
        //     if (snapshot.connectionState == ConnectionState.waiting) {
        //       return Center(
        //         child: CircularProgressIndicator(),
        //       );
        //     }

        //     if (snapshot.hasError) {
        //       return Center(
        //         child: Text('Error: ${snapshot.error}'),
        //       );
        //     }

        //     double totalPayments = 0;

        //     final List<DocumentSnapshot> userDocuments = snapshot.data!.docs;
        //     for (DocumentSnapshot userDoc in userDocuments) {
        //       final userData = userDoc.data() as Map<String, dynamic>?;
        //       if (userData != null && userData.containsKey('payments')) {
        //         final List<dynamic> payments = userData['payments'];
        //         for (var payment in payments) {
        //           final String? priceString = payment['price'];
        //           if (priceString != null) {
        //             final double price = double.tryParse(priceString) ?? 0;
        //             totalPayments += price;
        //           }
        //         }
        //       }
        //     }

        //     return InfoCard(
        //       title: "Total Payments",
        //       value: "₹ ${totalPayments.toString()}",
        //       onTap: () {},
        //       topColor: Colors.red,
        //     );
        //   },
        // ),
      ],
    );
  }
}
