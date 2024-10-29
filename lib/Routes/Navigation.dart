// ignore: file_names
import 'package:cutomer_app/Address/AddAddress.dart';
import 'package:cutomer_app/Dashboard/Dashboard.dart';
import 'package:cutomer_app/Location/LocationScreen.dart';
import 'package:cutomer_app/Screens/LoginScreen.dart';
import 'package:cutomer_app/Screens/splashScreen.dart';
import 'package:cutomer_app/Terms/TermsAndConditionsScreen.dart';
import 'package:flutter/material.dart';

import '../Address/AddAddressScreen.dart';
import '../Address/CurrentLocation.dart';
import '../Address/CurrentLocationScreen.dart';
import '../Address/SaveAddressScreen.dart';
import '../Screens/RegisterScreen.dart';
import '../Utils/HelpDesk.dart';

var onGenerateRoute = (RouteSettings settings) {
  print('my routs: ${settings.name}');
  switch (settings.name) {
    case "/":
      return MaterialPageRoute(builder: (builder) => const SplashScreen());

    // case "/":
    //   return MaterialPageRoute(builder: (builder) => const CurrentLocationl());

    case "/location":
      return MaterialPageRoute(builder: (builder) => const LocationScreen());
    case "/login":
      return MaterialPageRoute(builder: (builder) => Loginscreen());

    case "/termsandcondition":
      return MaterialPageRoute(
          builder: (builder) => TermsAndConditionsScreen());

// termsandcondition

    case "/gethelp":
      return MaterialPageRoute(builder: (builder) => HelpDeskScreen());

    case "/registerScreen":
      final args = settings.arguments as List; // Expecting a List of arguments
      final fullName = args[0] as String; // Extract username
      final mobileNumber = args[1] as String; // Extract mobile number

      return MaterialPageRoute(
        builder: (_) => RegisterScreen(
          fullName: fullName,
          mobileNumber: mobileNumber, // Pass mobile number
        ),
      ); // Pass the fullName here

    case "/address":
      final mobileNumber = settings.arguments as String;
      return MaterialPageRoute(
        builder: (context) => AddAddressScreen(mobileNumber: mobileNumber),
      );

 case "/addaddress":
  final List<dynamic> args = settings.arguments as List<dynamic>;
  final String mobileNumber = args[0] as String;
  final String addressSearch = args[1] as String; // Ensure this corresponds to the address
  return MaterialPageRoute(
    builder: (context) => AddAddress(
      mobileNumber: mobileNumber,
      addressSearch: addressSearch,
    ),
  );


    // case "/sevedaddress":
    //   return MaterialPageRoute(builder: (builder) => SaveAddressScreen());

    case "/currentloaction":
      final mobileNumber = settings.arguments as String;
      return MaterialPageRoute(
          builder: (builder) => CurrentLocationl(mobileNumber: mobileNumber));

    case "/dashboard":
  final sublocality = settings.arguments as String; // Get the passed argument
  return MaterialPageRoute(
    builder: (_) => DashboardScreen(sublocality: sublocality), // Pass it to the screen
  );

// RegisterScreen
    default:
  }
};
