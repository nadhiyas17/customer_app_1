// import 'package:cutomer_app/Screens/LoginScreen.dart';
// import 'package:cutomer_app/Location/LocationScreen.dart';
import 'package:cutomer_app/Address/AddAddressScreen.dart';
import 'package:cutomer_app/Address/SelectAddressScreen.dart';
import 'package:cutomer_app/Location/LocationScreen.dart';
import 'package:cutomer_app/Routes/Navigation.dart';
import 'package:cutomer_app/Screens/LoginScreen.dart';
import 'package:cutomer_app/Screens/OtpScreen.dart';
import 'package:cutomer_app/Screens/splashScreen.dart';
import 'package:cutomer_app/Terms/TermsAndConditionsScreen.dart';
import 'package:cutomer_app/verification/registrationsuccess.dart';
import 'package:cutomer_app/verification/verficationmessage.dart';
// import 'package:cutomer_app/Screens/splashScreen.dart';
// import 'package:cutomer_app/Terms/TermsAndConditionsScreen.dart';
import 'package:flutter/material.dart';
// import 'package:login/Navigation/onGenerateRoute.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
  
    
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // onGenerateRoute: onGenerateRoute,
      // home: OtpScreen(phoneNumber: '', verificationId: '', welcomeName: '',),
      // home: SelectAddressScreen(),
      // home: registrationsuccess(),
      // home: LoginScreen(),
      // home: AddAddressScreen(),
      // home:LocationScreen();
     onGenerateRoute: onGenerateRoute,
    );
  }
}

  