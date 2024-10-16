import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pinput/pinput.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  final String welcomeName;

  OtpScreen({
    required this.phoneNumber,
    required this.welcomeName,
  });

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late Timer _timer;
  int _start = 30;
  bool _canResend = false;
  String _otpCode = ""; // Store the OTP code entered
  bool _isLoading = false; // To show loading indicator during verification
  int _failedAttempts = 0;

  final TextEditingController _otpController = TextEditingController();
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  @override
  void initState() {
    super.initState();
    startTimer(); // Start the timer
  }

  void startTimer() {
    _start = 30; // Reset timer to 30 seconds
    _canResend = false; // Disable resend button initially

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
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

  Future<void> _verifyOtp() async {
    // Show loading indicator
    setState(() {
      _isLoading = true;
    });

    try {
      // API endpoint
      final url =
          Uri.parse('http://192.168.1.14:9090/api/customers/verify-otp');

      // Request body
      final body = json.encode({
        "phone": widget.phoneNumber,
        "otp": _otpController.text.trim(),
      });

      // Send POST request
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          // Successful OTP verification
          Fluttertoast.showToast(
            msg: 'OTP Verified Successfully!',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );

          // Navigate to registration screen with welcomeName argument
          Get.offAllNamed('/registerScreen', arguments: widget.welcomeName);
        } else {
          setState(() {
            _failedAttempts++;
          });
          errorMessage.value =
              responseData['message'] ?? "OTP verification failed.";
          Fluttertoast.showToast(
            msg: errorMessage.value,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      } else {
        errorMessage.value = "Server error: ${response.statusCode}";
        Fluttertoast.showToast(
          msg: errorMessage.value,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      errorMessage.value = "An error occurred: ${e.toString()}";
      Fluttertoast.showToast(
        msg: errorMessage.value,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } finally {
      setState(() {
        _isLoading = false; // Stop loading
      });
    }
  }

  void resendOtp() {
    Fluttertoast.showToast(msg: 'OTP resent to ${widget.phoneNumber}');
    setState(() {
      _otpCode = ""; // Clear the OTP input field
    });
    startTimer(); // Restart the timer
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
                  borderRadius: BorderRadius.only(
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
                      SizedBox(height: 180.0), // Space for the image
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Enter the Verification Code',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Navigate back
                            },
                            child: Text(
                              'Edit Number',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16.0,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'A 6 digit code has been sent to ${widget.phoneNumber}',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Pinput(
                          length: 6,
                          controller: _otpController,
                          onCompleted: (pin) {
                            _verifyOtp(); // Verify OTP when completed
                          },
                          defaultPinTheme: PinTheme(
                            width: 50,
                            height: 50,
                            textStyle: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          focusedPinTheme: PinTheme(
                            width: 50,
                            height: 50,
                            textStyle: TextStyle(
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
                      SizedBox(height: 20.0),
                      Text(
                        '00:${_start.toString().padLeft(2, '0')}',
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      TextButton(
                        onPressed: _failedAttempts >= 3
                            ? () {
                                Navigator.pushReplacementNamed(
                                    context, '/gethelp');
                              }
                            : (_canResend ? resendOtp : null),
                        child: Center(
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: _failedAttempts >= 3
                                      ? "You have made '3' unsuccessful attempts. Need assistance? "
                                      : "Didn't receive OTP? ",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: _canResend || _failedAttempts >= 3
                                        ? const Color.fromARGB(255, 255, 0, 0)
                                        : Colors.grey,
                                  ),
                                ),
                                if (_failedAttempts >= 3)
                                  TextSpan(
                                    text: " Get Help",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.pushReplacementNamed(
                                            context, '/gethelp');
                                      },
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      if (_isLoading) CircularProgressIndicator(),
                      Text(
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
