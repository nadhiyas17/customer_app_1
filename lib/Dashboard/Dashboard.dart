import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  final String sublocality; // Declare as final

  // Constructor
  DashboardScreen({super.key, this.sublocality = ''}); // Use `this.sublocality` to assign

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.sublocality), // Access using widget.sublocality
      ),
      body: Center(
        child: Text("Welcome to the Dashboard!"),
      ),
    );
  }
}
