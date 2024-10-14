import 'package:flutter/material.dart';

class  registrationsuccess extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFDCE3E9), // Background color similar to your example
      body: Center(
        child: Container(
          margin: EdgeInsets.all(16.0),
          padding: EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 5,
                offset: Offset(0, 3), // Shadow positioning
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Circular Icon with a checkmark
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: const BoxDecoration(
                  color: Color(0xFFE0F7EF), // Light green background
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Color(0xFF3AB96B), // Green check icon color
                  size: 50.0,
                ),
              ),
              const SizedBox(height: 16.0), // Space between the icon and text

              // "Mobile number verified!" message
              const Text(
                "You're all set",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4E357B), // Purple text color
                ),
              ),
              const SizedBox(height: 8.0),

              // Thank you message
              Text(
                "Your registration was successful. Welcome to the SureCare family",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey[600], // Lighter grey color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() => runApp(MaterialApp(
  home: registrationsuccess(),
));