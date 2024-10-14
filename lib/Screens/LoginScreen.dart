import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'OTP/OtpScreen.dart';
import 'OtpScreen.dart';

class Loginscreen extends StatefulWidget {
  @override
  _LoginscreenState createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  bool agreeToTerms = true;
  String? errorMessage;
  String? phoneNumber; // This will store the formatted phone number

  // Validation for the name field
  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  // Validation for the mobile field
  String? validateMobile(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a mobile number';
    } else if (value.length < 10) {
      return 'Mobile number must be at least 10 digits';
    } else if (!RegExp(r'^\+?[1-9]\d{1,14}$').hasMatch('+91${value.trim()}')) {
      return 'Invalid phone number format';
    }
    return null;
  }

  // Handle form submission
  void _submitForm() {
    if (_formKey.currentState!.validate() && agreeToTerms) {
      // Make sure the phoneNumber is formatted properly
      phoneNumber = '+91${_mobileController.text.trim()}';

      // Navigate to OTP Screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (ctx) => OtpScreen(
            phoneNumber: phoneNumber!,
            verificationId: "123456",
            welcomeName: _nameController.text,
          ),
        ),
      );
    } else if (!agreeToTerms) {
      setState(() {
        errorMessage = "You must agree to the terms to proceed.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                // Top section with image
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                  ),
                  child: Image.asset(
                    'assets/Register.png', // Add your image asset path here
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 150,
                  left: 20,
                  right: 20,
                  child: Column(
                    children: [
                      SizedBox(height: 210.0), // Space for the image
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 20.0),
                              Align(
                                alignment: Alignment.topLeft,
                                child: const Center(
                                  child: Text(
                                    'Sign In / Sign Up',
                                    style: TextStyle(
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF6B3FA0),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20.0),
                              TextFormField(
                                controller: _nameController,
                                decoration: InputDecoration(
                                  labelText: 'Enter Full Name',
                                  border: OutlineInputBorder(),
                                ),
                                validator: validateName,
                              ),
                              SizedBox(height: 15.0),
                              TextFormField(
                                controller: _mobileController,
                                decoration: InputDecoration(
                                  labelText: 'Enter Mobile Number',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.phone,
                                validator: validateMobile,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(10),
                                ],
                              ),
                              const SizedBox(height: 10.0),
                              Row(
                                children: [
                                  Checkbox(
                                    value: agreeToTerms,
                                    onChanged: (bool? newValue) {
                                      setState(() {
                                        agreeToTerms = newValue ?? true;
                                      });
                                    },
                                  ),
                                  Text('I Agree to '),
                                  GestureDetector(
                                    onTap: () {
                                      // Handle the tap here to navigate to Terms & Conditions page
                                      print('Terms & Conditions clicked');
                                    },
                                    child: Text(
                                      'Terms & Conditions',
                                      style: TextStyle(
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (errorMessage != null)
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Text(
                                    errorMessage!,
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              SizedBox(height: 10.0),
                              Center(
                                child: ElevatedButton(
                                  onPressed: _submitForm,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Color.fromARGB(255, 96, 15, 196),
                                    padding: EdgeInsets.symmetric(
                                      vertical: 15.0,
                                      horizontal: 60.0,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                  ),
                                  child: Text(
                                    'GET OTP',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Copyright © 2024 - SureCare',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
