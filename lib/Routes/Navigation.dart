// ignore: file_names
import 'package:cutomer_app/Screens/LoginScreen.dart';
import 'package:cutomer_app/Screens/splashScreen.dart';
import 'package:flutter/material.dart';

var onGenerateRoute = (RouteSettings settings) {
  print('my routs: ${settings.name}');
  switch (settings.name) {
    case "/":
      return MaterialPageRoute(builder: (builder) => const SplashScreen());
      

   case "/login":
      return MaterialPageRoute(builder: (builder) => const LoginScreen());

    
  }
};