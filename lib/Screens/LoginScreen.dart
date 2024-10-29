import 'package:cutomer_app/APIs/LoginAPI.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../Toasters/Toaster.dart';
import 'OtpScreen.dart';

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
      getOTPButton.value = "Sending OTP...";
      isLoading.value = true; // Start loading

      phoneNumber = '${_mobileController.text.trim()}';
      final fullname = _nameController.text.trim();
      final mobileNumber = _mobileController.text.trim();

      try {
        final response = await _loginapiService.signInOrSignUp(fullname, mobileNumber);
        if (response != null && response['status'] == 200) {
          getOTPButton.value = "GET OTP";
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
          showErrorToast(msg: response['message'] ?? 'Failed to sign in or sign up. Please try again.');
        }
      } catch (e) {
        getOTPButton.value = "GET OTP";
        showErrorToast(msg: "An error occurred: ${e.toString()}");
      } finally {
        isLoading.value = false; // Hide loading state
      }
    }
    if (!agreeToTerms) {
      showErrorToast(msg: "You must agree to the terms to proceed.");
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
              'assets/Registers.png', // Ensure this path is correct
              width: double.infinity,
              height: 380,
              fit: BoxFit.cover,
            ),
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
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Enter Full Name',
                        border: OutlineInputBorder(),
                      ),
                      autovalidateMode: AutovalidateMode.onUnfocus,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter a valid username";
                        }
                        return null; // No error
                      },
                    ),
                    SizedBox(height: 15.0),
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
                    Row(
                      children: [
                        Checkbox(
                          value: agreeToTerms,
                          onChanged: (bool? newValue) {
                            setState(() {
                              agreeToTerms = newValue ?? false;
                              errorMessage.value = ""; // Clear error when checkbox is checked
                            });
                          },
                        ),
                        Text('I Agree to '),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed('/termsandcondition');
                          },
                          child: Text(
                            'Terms & Conditions',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
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
                    Center(
                      child: ElevatedButton(
                        onPressed: isLoading.value
                            ? null
                            : () async {
                                _submitForm(); // Perform your submit action
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 96, 15, 196),
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
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        child: Center(
          child: Text(
            'Copyright © 2024 - SureCare',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
