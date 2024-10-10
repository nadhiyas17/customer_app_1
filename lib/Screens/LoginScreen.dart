// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:sc_app/Login/OTPLogic.dart';
// import 'package:sc_app/Login/OTPScreen.dart';

// import '../Screens/Dashboard/Dashboard.dart';

// Import the FirebaseAuth package

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  bool agreeToTerms = false;
  String? errorMessage;

  String? phoneNumber; // This will store the error message

  // Add your validation functions here
  // String? validateName(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return 'Please enter your name';
  //   }
  //   return null;

  //   // Your validation logic
  // }

  String? validateMobile(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a mobile number';
    } else if (value.length < 10) {
      return 'Mobile number must be at least 10 digits';
    } else if (!RegExp(r'^\+?[1-9]\d{1,14}$').hasMatch(phoneNumber!)) {
      return 'Invalid phone number format';
    }
    return null;

    // Your validation logic
  }

  _validateAndProceed() {
    // Check if the checkbox is selected
    if (agreeToTerms) {
      // Navigate to the next screen
      return null;
    } else {
      // Show an error message if checkbox is not selected

      return "You must agree to the terms to proceed.";
    }
  }

  // void _submitForm() {
  //   if (_formKey.currentState!.validate() && agreeToTerms) {
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder:(context) => DashboardScreen()));
  //     //       builder: (ctx) => OtpScreen(
  //     //           phoneNumber: phoneNumber!,
  //     //           verificationId: "123456",
  //     //           welcomeName: _nameController.text)),
  //     // );
  //     // Your form submission logic
  //   };
  // }

  @override
  // void initState() {
  //   super.initState();
  //   _mobileController.addListener(_updatePhoneNumber);
  // }

  // void _updatePhoneNumber() {
  //   setState(() {
  //     phoneNumber = '+91${_mobileController.text.trim()}';
  //   });
  // }

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
                  borderRadius: const BorderRadius.only(
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
                      const SizedBox(height: 220.0), // Space for the image
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Form(
                          key: _formKey, // Assign the form key
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Center(
                                child: Text(
                                  'Signup/Register',
                                  style: TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF6B3FA0),
                                  ),
                                  
                                ),
                                
                              ),

                              TextFormField(
                                controller: _nameController,
                                decoration: const InputDecoration(
                                  labelText: 'Enter Full Name',
                                  border: OutlineInputBorder(),
                                ),
                                // validator: validateName,
                              ),
                              const SizedBox(height: 20.0),
                              TextFormField(
                                // minLines: 10,
                                controller: _mobileController,
                                decoration: const InputDecoration(
                                  labelText: 'Enter Mobile Number',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.phone,
                                validator: validateMobile,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(
                                      10), // Set the maximum length
                                ],
                              ),
                              const SizedBox(height: 10.0),
                              Row(
                                children: [
                                  // Checkbox(
                                  //   value: agreeToTerms,
                                  //   onChanged: (bool? newValue) {
                                  //     setState(() {
                                  //       agreeToTerms = newValue ?? false;
                                  //     });
                                  //   },
                                  // ),
                                  const Text('I Agree to terms &'),
                                  GestureDetector(
                                    // onTap: () {
                                    //   // Navigate to terms and conditions
                                    // },
                                    child: const Text(
                                      ' Conditions',
                                      style: TextStyle(
                                        color: Color(0xFF6B3FA0),
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                  if (errorMessage != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Text(
                                        errorMessage!,
                                        style: const TextStyle(
                                            color: Colors.red, fontSize: 14),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 10.0),
                              Center(
                                child: ElevatedButton(
                                  onPressed: () {
                                    // SubmitPhoneNumber submitPhoneNumber =
                                    //     SubmitPhoneNumber();
                                    // submitPhoneNumber.submitPhoneNumber(
                                    //     mobileController:
                                    //         _mobileController.text);
                                    // _submitForm();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(255, 96, 15, 196),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15.0, horizontal: 60.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                  ),
                                  child: const Text(
                                    'GET OTP',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'This site is protected by reCAPTCHA and the Google [Privacy Policy](https://policies.google.com/privacy) and [Terms of Service](https://policies.google.com/terms) apply.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Privacy section at the bottom
          ],
        ),
      ),
    );
  }
}
