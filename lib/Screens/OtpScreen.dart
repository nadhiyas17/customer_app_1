import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
// ignore: depend_on_referenced_packages
import 'package:pinput/pinput.dart';

// import '../../utils.dart/HelpScreen.dart';
// import '../LoginScreen.dart';
// import '../Dashboard/Dashboard.dart';
// import '../Registration.dart';

class OtpScreen extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;
  final String welcomeName;

  OtpScreen({
    required this.phoneNumber,
    required this.verificationId,
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

  // OTP verification logic
  void verifyOtp(String otpCode) {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    // Simulating async OTP verification
    Future.delayed(Duration(seconds: 2), () {
      if (otpCode == "123456") {
        // Success scenario
        Fluttertoast.showToast(
          msg: 'OTP Verified Successfully!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );

        // Navigate to the Dashboard on successful verification
   Navigator.of(context).pushReplacementNamed('/registerScreen', arguments: widget.welcomeName);


      } else {
        // Handle failed OTP verification
        setState(() {
          _failedAttempts++;
          _isLoading = false; // Hide loading indicator
        });

        Fluttertoast.showToast(
          msg: 'Invalid OTP, please try again.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );

        // If failed attempts reach 3, show the "Get Help" link
        if (_failedAttempts >= 3) {
          setState(() {
            _canResend = false; // Disable resend button
          });
        }
      }
    });
  }

  void resendOtp() {
    // Logic to resend OTP
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

                      // Pinput for OTP input
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Pinput(
                          length: 6,
                          onChanged: (value) {
                            setState(() {
                              _otpCode = value;
                            });
                          },
                          onCompleted: (pin) {
                            // Verify OTP when completed
                            verifyOtp(pin);
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

                      SizedBox(height: 20.0),
                      if (_isLoading)
                        CircularProgressIndicator(), // Show loader
                      Text(
                        '@Copyright SureCare-2024',
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
