import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class FullscreenLoader extends StatelessWidget {
  final message;
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
            SpinKitDoubleBounce(
              itemBuilder: (context, index) => Image.asset(
                'assets/surecare_launcher.png', // Updated to load local image
                fit: BoxFit.cover,
              ),
              size: 70,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Text(
                  message,
                  style: TextStyle(fontSize: 24), // Customize text style
                ),
                // Space between text and second loader
                SpinKitThreeBounce(
                  color:
                      Colors.green, // Customize the color for the second loader
                  size: 10.0, // Adjust size if necessary
                ),
              ],
            ), // Space between first loader and text
          ],
        ),
      ),
    );
  }
}
