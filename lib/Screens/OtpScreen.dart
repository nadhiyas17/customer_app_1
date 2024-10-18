import 'dart:async';
import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinput/pinput.dart';
// import 'package:provider_app/screens/successscreen.dart';
import 'package:http/http.dart' as http;

import '../APIs/BaseUrl.dart';
import '../verification/verficationmessage.dart';
import '../Toasters/Toaster.dart';

class Otpscreencustomer extends StatefulWidget {
  final String? PhoneNumberstored;

  final dynamic username;
  const Otpscreencustomer({
    super.key,
    required this.PhoneNumberstored,
    required this.username,
  });

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<Otpscreencustomer> {
  late Timer _timer;
  int _start = 60;
  bool _canResend = false;
  String otpCode = ""; // Store the OTP code entered
  bool _isLoading = false; // To show loading indicator during verification
  int _failedAttempts = 0;
  String? verificationId; // Add this field to store the verification ID

  @override
  void initState() {
    super.initState();
    startTimer(); // Start the timer
  }

  void startTimer() {
    _start = 60; // Reset timer to 30 seconds
    _canResend = false; // Disable resend button initially

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_start > 0) {
          _start--;
        } else {
          _canResend = true; // Enable resend button after countdown
          _timer.cancel(); // Stop the timer
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Clean up the timer
    super.dispose();
  }

  // OTP verification logic
  void verifyOtp(String otpCode) {
    print("============================${otpCode}==========================");
    print(
        "============================${widget.PhoneNumberstored}==========================");

    setState(() {
      _isLoading = true; // Show loading indicator
    });

    // Send mobile number and OTP to the backend for verification
    Future.delayed(const Duration(seconds: 2), () async {
      try {
        if (widget.PhoneNumberstored != null) {
          print("======== Try ========");

          // Replace this with your actual API endpoint
          final response = await http.post(
            Uri.parse('$baseUrl/verify-otp'),
            body: json.encode({
              'mobileNumber': widget.PhoneNumberstored,
              'enteredOtp': otpCode,
            }),
            headers: {'Content-Type': 'application/json'},
          );

          // Check for successful response
          if (response.statusCode == 200) {
            print("======== Success ========");
            final responseData = json.decode(response.body);
            print("$responseData");

            // Show success message
            showSuccessToast(
              msg: 'OTP verified successfully',
            );

            // Hide loading indicator and navigate to registration screen
            DialogHelper.showVerificationDialog(context);

            // Wait for 3 seconds before navigating
            setState(() {
              _isLoading = false; // Show loading indicator
              _timer.cancel();
            });
            await Future.delayed(Duration(seconds: 3));

            // if (responseData['registrationCompleted'] == "false") {
              Navigator.pushNamedAndRemoveUntil(
                context,
                "/registerScreen",
                (Route<dynamic> route) => false, // Removes all previous routes
                arguments: [
                  widget.username,
                  widget.PhoneNumberstored,
                ], // Pass arguments
              );
            // } else {
            //   Navigator.of(context).pushNamedAndRemoveUntil(
            //     '/dashboard',
            //     (Route<dynamic> route) => false,
            //   );
            // }
          } else {
            showErrorToast(msg: "Invalid OTP");
            setState(() {
              _isLoading = false;
              _failedAttempts++;
            });

            // Handle other messages from the server
            final responseData = json.decode(response.body);

            if (response.statusCode == 400) {
              showErrorToast(
                msg: responseData['message'] ??
                    "OTP has expired. Please request a new OTP.",
              );
            } else {
              showErrorToast(
                msg: 'Failed to verify OTP. Please try again later.',
              );
            }
          }
        }
      } catch (e) {
        print("======== Catch ========");
        showErrorToast(msg: "Server not responding");
        print('Error verifying OTP: $e');
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

// Helper function to show error messages

  Future<void> resendOtp() async {
    try {
      _isLoading = true;
      // Define the API URL
      String apiUrl = '$baseUrl/resend-otp';

      // Ensure the phone number is not null
      final phoneNumber = widget.PhoneNumberstored ?? '';

      // Make the POST request
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'mobileNumber': phoneNumber, // Send the phone number as a parameter
        }),
      );

      // Check if the API call was successful
      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: 'OTP resent to $phoneNumber');

        // Clear the OTP input field
        setState(() {
          otpCode = "";
          _isLoading = false;
        });
        // Restart the timer
        startTimer();
      } else {
        // Show error message if the API call fails
        Fluttertoast.showToast(msg: 'Failed to resend OTP. Please try again.');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      // Handle any errors
      Fluttertoast.showToast(msg: 'Error: $e');
      setState(() {
        _isLoading = false;
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
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                  ),
                  child: Image.asset(
                    'assets/Register.png', // Image for the top section
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 220,
                  left: 20,
                  right: 20,
                  child: Column(
                    children: [
                      const SizedBox(height: 180.0),

                      // Space for the image
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                            child: Text(
                              'Enter the Verification Code',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Navigate back
                            },
                            child: const Text(
                              'Edit Number',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 12.0,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),

                      //   text messages with phone_number
                      Padding(
                        padding: const EdgeInsets.only(left: 0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'A 6 digit code has been sent to ${widget.PhoneNumberstored}',
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20.0),

                      // Pinput for OTP input  think 6 boxes
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Pinput(
                          length: 6,
                          onChanged: (value) {
                            setState(() {
                              otpCode = value;
                            });
                          },
                          onCompleted: (pin) {
                            // Verify OTP when completed
                            verifyOtp(pin);
                          },
                          defaultPinTheme: PinTheme(
                            width: 50,
                            height: 50,
                            textStyle: const TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black38),
                              // Change border color to a darker shade
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          focusedPinTheme: PinTheme(
                            width: 50,
                            height: 50,
                            textStyle: const TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.purple),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20.0),
                      Text(
                        '00:${_start.toString().padLeft(2, '0')}',
                        style: const TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      //this section includes 3 otp try error message UI
                      const SizedBox(height: 10.0),
                      TextButton(
                        onPressed: _failedAttempts >= 2
                            ? () {
                                // Navigate to Get Help screen when clicked
                                Navigator.pushReplacementNamed(
                                    context, '/gethelp');
                              }
                            : (_canResend
                                ? resendOtp
                                : null), // Resend button logic
                        child: Center(
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: _failedAttempts >= 2
                                      ? "You have made '2' unsuccessful attempts. Need assistance? "
                                      : "Didn't receive OTP? ",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: _canResend || _failedAttempts >= 2
                                        ? const Color.fromARGB(255, 255, 0, 0)
                                        : Colors.grey,
                                  ),
                                ),
                                if (_failedAttempts >= 2)
                                  TextSpan(
                                    text: " Get Help",
                                    style: const TextStyle(
                                      height: 1.5,
                                      fontSize: 20.0,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        // Navigate to help page
                                        Navigator.pushReplacementNamed(
                                            context, '/gethelp');
                                      },
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20.0),
                      if (_isLoading)
                        const CircularProgressIndicator(), // Show loader
                      const Text(
                        'Copyright © 2024 - SureCare',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey,
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
