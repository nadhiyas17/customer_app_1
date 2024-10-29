import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class FullscreenLoader extends StatelessWidget {
  final String message;

  FullscreenLoader({required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 227, 227, 227),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SpinKitCircle(
              color: Colors.blue, // Customize color as needed
              size: 70.0, // Adjust size if necessary
            ),
            SizedBox(height: 20), // Space between loader and text row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  message,
                  style: TextStyle(fontSize: 24), // Customize text style
                ),
                SizedBox(width: 10), // Space between text and second loader
                // SpinKitThreeBounce(
                //   color: Colors.green, // Customize the color for the loader
                //   size: 15.0, // Adjust size if necessary
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
