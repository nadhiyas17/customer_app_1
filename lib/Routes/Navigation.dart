// ignore: file_names
import 'package:cutomer_app/Location/LocationScreen.dart';
import 'package:cutomer_app/Screens/LoginScreen.dart';
import 'package:cutomer_app/Screens/splashScreen.dart';
import 'package:cutomer_app/Terms/TermsAndConditionsScreen.dart';
import 'package:flutter/material.dart';

import '../Address/AddAddressScreen.dart';
import '../Address/CurrentLocation.dart';
import '../Address/CurrentLocationScreen.dart';
import '../Screens/RegisterScreen.dart';

var onGenerateRoute = (RouteSettings settings) {
  print('my routs: ${settings.name}');
  switch (settings.name) {
    case "/":
      return MaterialPageRoute(builder: (builder) => const SplashScreen());

    //  case "/":
    //     return MaterialPageRoute(builder: (builder) => const AddAddressScreen());

    case "/location":
      return MaterialPageRoute(builder: (builder) => const LocationScreen());
    case "/login":
      return MaterialPageRoute(builder: (builder) => Loginscreen());

    case "/termsandcondition":
      return MaterialPageRoute(
          builder: (builder) => TermsAndConditionsScreen());

// termsandcondition

    // case "/gethelp":
    //   return MaterialPageRoute(builder: (builder) => GetHelp());

    case "/registerScreen":
      final String fullName = settings.arguments as String;
      return MaterialPageRoute(
          builder: (_) => RegisterScreen(fullName: fullName));

    case "/address":
      return MaterialPageRoute(builder: (builder) => AddAddressScreen());

    case "/currentloaction":
      return MaterialPageRoute(builder: (builder) => CurrentLocationScreen());

// RegisterScreen
    default:
  }
};
