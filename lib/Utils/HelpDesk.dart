import 'package:flutter/material.dart';

class HelpDeskScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final BoxDecoration containerDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      border:
          Border.all(color: Colors.grey), // Optional: Add a border if needed
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Help Desk',
          style: TextStyle(
            color: Colors.white, // Adjust color as needed
          ),
        ),
        // Image on the right
        // Image.asset(
        //   'assets/logo.jpeg', // Replace with your image path
        //   width: 50,
        //   height: 50, // Adjust image size as needed
        backgroundColor: Color(0xFF6B3FA0), // Adjust color as needed
        // ),

        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
         onPressed: () {
  Navigator.pop(context); // Navigate back to the previous screen
},
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Need help desk support for...',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double
                  .infinity, // Ensures the container fills the available width
              child: InkWell(
                onTap: () {
                  // Implement navigation to Elder Care Companions support
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: containerDecoration.copyWith(
                      color: const Color.fromARGB(255, 243, 164, 190)),
                  child: Text(
                    'Elder Care Companions',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double
                  .infinity, // Ensures the container fills the available width
              child: InkWell(
                onTap: () {
                  // Implement navigation to Nurse Care support
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: containerDecoration.copyWith(
                      color: const Color.fromARGB(255, 122, 202, 239)),
                  child: Text(
                    'Nurse Care',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double
                  .infinity, // Ensures the container fills the available width
              child: InkWell(
                onTap: () {
                  // Implement navigation to Login Issues support
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: containerDecoration.copyWith(
                      color: const Color.fromARGB(255, 165, 236, 202)),
                  child: Text(
                    'Login Issues',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 110.0),
            
            // Add the image here
        Container(
  height: 340, // Set a fixed height
  child: Image.asset(
    'assets/support.png',
    width: double.infinity, // This can stay as is
    fit: BoxFit.cover,
  ),
)

            // Add a placeholder for the 24/7 support icon
          ],
        ),
      ),
    );
  }
}
