import 'package:cutomer_app/APIs/LoginAPI.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../Toasters/Toaster.dart';
import 'OtpScreen.dart';
import 'OtpScreenVerify.dart'; // Ensure this is the correct path to your OtpScreen

class Loginscreen extends StatefulWidget {
  @override
  _LoginscreenState createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  var getOTPButton = "GET OTP".obs;

  var isLoading = false.obs;
  bool agreeToTerms = true; // Initialize to false to require agreement
  String? phoneNumber; // This will store the formatted phone number
  var errorMessage = ''.obs; // Observable for error message
  final LoginApiService _loginapiService = LoginApiService();
  void _submitForm() async {
    if (_formKey.currentState!.validate() && agreeToTerms) {
      getOTPButton.value = "Sending Otp...";
      // Show sending OTP message
      isLoading.value = true; // Start loading

      // Format the phone number properly
      phoneNumber = '${_mobileController.text.trim()}';

      final fullname = _nameController.text.trim();
      final mobileNumber = _mobileController.text.trim();

      try {
        // Call the API service to sign in or sign up
        final response =
            await _loginapiService.signInOrSignUp(fullname, mobileNumber);

        // Check if the response is successful (assuming status 200 indicates success)
        if (response != null && response['status'] == 200) {
          // Show success toast
          getOTPButton.value = "GET OTP";

          // Navigate to OTP Screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) => Otpscreencustomer(
                PhoneNumberstored: phoneNumber!,
                username: fullname,
              ),
            ),
          );
        } else {
          getOTPButton.value = "GET OTP";
          // Show error toast with the message from the response
          showErrorToast(
              msg: response['message'] ??
                  'Failed to sign in or sign up. Please try again.');
        }
      } catch (e) {
        getOTPButton.value = "GET OTP";
        // Handle the error (e.g., network issues, API errors)
        showErrorToast(msg: "An error occurred: ${e.toString()}");
      } finally {
        // Reset loading state
        isLoading.value = false; // Hide loading state
      }

      if (!agreeToTerms) {
        showErrorToast(msg: "You must agree to the terms to proceed.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              'assets/Registers.png', // Add your image asset path here
              width: double.infinity,
              height: 380,
              fit: BoxFit.cover,
            ),
            Positioned(
              left: 20,
              right: 20,
              child: Column(
                children: [
                  // SizedBox(height: 210.0), // Space for the image
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20.0),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Sign In / Sign Up',
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF6B3FA0),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          // Full Name Field
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: 'Enter Full Name',
                              border: OutlineInputBorder(),
                            ),
                            autovalidateMode: AutovalidateMode.onUnfocus,
                            validator: (value) {
                              value = value?.trim();
                              if (value == null || value.isEmpty) {
                                return "Enter a valid username";
                              } else if (!GetUtils.isUsername(value)) {
                                return "Enter a valid username";
                              }
                              return null; // No error
                            },
                          ),
                          SizedBox(height: 15.0),
                          // Mobile Number Field
                          TextFormField(
                            controller: _mobileController,
                            decoration: InputDecoration(
                              labelText: 'Enter Mobile Number',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            autovalidateMode: AutovalidateMode.onUnfocus,
                            validator: (value) {
                              value = value?.trim();
                              if (value == null || value.isEmpty) {
                                return "Enter a valid mobile number";
                              } else if (!GetUtils.isPhoneNumber(value)) {
                                return "Enter a valid mobile number";
                              }
                              return null; // No error
                            },
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(10),
                            ],
                          ),
                          const SizedBox(height: 10.0),
                          // Terms and Conditions Checkbox
                          Row(
                            children: [
                              Checkbox(
                                value: agreeToTerms,
                                onChanged: (bool? newValue) {
                                  setState(() {
                                    agreeToTerms = newValue ?? false;
                                    errorMessage.value =
                                        ""; // Clear error when checkbox is checked
                                  });
                                },
                              ),
                              Text('I Agree to '),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed('/termsandcondition');
                                  print('Terms & Conditions clicked');
                                },
                                child: Text(
                                  'Terms & Conditions',
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            ],
                          ),
                          // Error Message Display
                          Obx(() => errorMessage.value.isNotEmpty
                              ? Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Text(
                                    errorMessage.value,
                                    style: TextStyle(color: Colors.red),
                                  ),
                                )
                              : SizedBox.shrink()),
                          SizedBox(height: 10.0),
                          // Submit Button
                          Center(
                            child: ElevatedButton(
                              // Disable button when loading
                              onPressed: isLoading.value
                                  ? null
                                  : () async {
                                      isLoading.value = true; // Start loading
                                      _submitForm(); // Perform your submit action
                                      isLoading.value = false; // End loading
                                    },
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
                              child: Obx(() => Text(
                                    getOTPButton.value,
                                    style: TextStyle(color: Colors.white),
                                  )),
                            ),
                          )
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
      ),
    );
  }
}
