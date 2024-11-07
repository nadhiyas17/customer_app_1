import 'package:cutomer_app/Routes/Navigation.dart';
// import 'package:cutomer_app/Services/SelectServicesPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Address/AddAddress.dart';
import 'Address/AddAddressScreen.dart';
import 'ServiceView/ServiceDetailPage.dart';
import 'Services/ServiceSelectionScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'SureCare',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // onGenerateRoute: onGenerateRoute,
      // home: SelectServicesPage(),
      home: ServiceDetailsPage(),

      // home: AddAddressScreen(mobileNumber: "7842259803"),
    );
  }
}
