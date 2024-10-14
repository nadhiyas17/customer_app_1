// ignore: file_names
import 'package:cutomer_app/Location/LocationScreen.dart';
import 'package:cutomer_app/Screens/LoginScreen.dart';
import 'package:cutomer_app/Screens/splashScreen.dart';
import 'package:flutter/material.dart';
 

var onGenerateRoute = (RouteSettings settings) {
  print('my routs: ${settings.name}');
  switch (settings.name) {
    case "/":
      return MaterialPageRoute(builder: (builder) => const SplashScreen());
       case "/location":
      return MaterialPageRoute(builder: (builder) => const LocationScreen());
    case "/login":
      return MaterialPageRoute(builder: (builder) => Loginscreen());


    // case "/gethelp":
    //   return MaterialPageRoute(builder: (builder) => GetHelp());

    // case "/registerScreen":
    //   final String fullName = settings.arguments as String;
    //   return MaterialPageRoute(
    //       builder: (_) => RegisterScreen(fullName: fullName));

    // case "/currentloaction":
    //   return MaterialPageRoute(builder: (builder) => CurrentLocation());

// RegisterScreen
    default:
  }
};
