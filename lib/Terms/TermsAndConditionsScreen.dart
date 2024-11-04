import 'package:flutter/material.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          // Arrange logo and text in a row
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space evenly between children
          children: [
            // Text on the left
            Text(
              'Terms and Conditions',
              style: TextStyle(
                color: Colors.white, // Adjust color as needed
              ),
            ),
            // Image on the right
            // Image.asset(
            //   'assets/surecare_launcher.png', // Replace with your image path
            //  // Adjust image size as needed
            // ),
          ],
        ),
        backgroundColor: Color(0xFF6B3FA0), // Adjust color as needed
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white), // Adjust color as needed
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              'Terms and Conditions for Sure Care App',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
      //       SizedBox(height: 16.0),
      // body: SingleChildScrollView(
      //   padding: EdgeInsets.all(16.0),
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
            // Rest of the content (uncomment as needed)
            // SizedBox(height: 16.0),
            // Text(
            //   'Sure Care (referred to as "we," "us," or "our") provides this mobile application ("App") for informational purposes and general healthcare support. By downloading, installing, or using the App, you agree to abide by these terms and conditions (the "Terms"). Please read the following carefully before using the Sure Care App.',
            //   style: TextStyle(
            //     fontSize: 16,
            //     color: Colors.grey, // Adjust color as needed
            //   ),
            // ),
            // SizedBox(height: 16.0),
            // Text(
            //   '1. Acceptance of Terms',
            //   style: TextStyle(
            //     fontSize: 18,
            //     fontWeight: FontWeight.bold,
            //     color: Colors.black, // Adjust color as needed
            //   ),
            // ),
            // SizedBox(height: 8.0),
            // Text(
            //   'By accessing or using the Sure Care App, you agree to comply with these Terms. If you do not agree, you must uninstall the App and discontinue its use immediately.',
            //   style: TextStyle(
            //     fontSize: 16,
            //     color: Colors.grey, // Adjust color as needed
            //   ),
            // ),
            // Add more sections and content here as needed
          ],
        ),
      ),
    );
  }
}