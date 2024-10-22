import 'package:cutomer_app/Toasters/Toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import '../APIs/RegisterAPI.dart';
import '../Modals/RegisterModel.dart';

class RegisterScreen extends StatefulWidget {
  final String fullName; //TODO: check this is static
  final String mobileNumber;
  RegisterScreen({
    super.key,
    required this.fullName,
    required this.mobileNumber,
  });

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  //API
  final ApiService apiService = ApiService();

  String _gender = 'Male';
  String _bloodGroup = 'NA';
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.fullName.toLowerCase();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Adding a delay before showing the loading overlay
      await Future.delayed(Duration(seconds: 2));
      context.loaderOverlay.show(); // Show loading overlay

      final RegisterModel user = RegisterModel(
        fullName: widget.fullName,
        mobileNumber: widget.mobileNumber,
        emailId: _emailController.text,
        age: int.tryParse(_ageController.text) ?? 0, // Handle parsing error
        gender: _gender,
        bloodGroup: _bloodGroup,
      );

      try {
        final response = await apiService.registerUser(user);
        context.loaderOverlay.hide(); // Hide loading overlay

        if (response['status'] == 200) {
          showSuccessToast(
            msg: response['message'],
          );
          Navigator.of(context)
              .pushNamed('/address', arguments: widget.mobileNumber);
        } else {
          // Handle cases where the server responds with an error status
          showErrorToast(
              msg: response['message'] ??
                  "Failed to register. Please try again.");
        }
      } catch (e) {
        context.loaderOverlay.hide(); // Hide loading overlay on error
        showErrorToast(
            msg: "Server did not respond. Please check your connection.");
        print("Error: $e"); // Log the error for debugging
      }
    } else {
      // Optionally provide feedback for validation errors
      showErrorToast(msg: "Please fill in all required fields correctly.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LoaderOverlay(
        overlayColor: Colors.black87,
        overlayWidgetBuilder: (_) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                const SizedBox(height: 20),
                const Text(
                  'Sending...',
                  style: TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(255, 227, 227, 227),
                  ),
                ),
              ],
            ),
          );
        },
        child: Stack(
          children: [
            Positioned(
              top: 410.0,
              left: 0,
              right: 0,
              bottom: 0,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20.0),
                    Align(
                      alignment: Alignment(-1.0, 0.0),
                      child: Text(
                        'Health Profile',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6B3FA0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: 'Full Name',
                              border: OutlineInputBorder(),
                            ),
                            enabled: false,
                          ),
                          const SizedBox(height: 10.0),
                          Stack(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 12.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey, width: 1.0),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 5.0),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 45,
                                          child: RadioListTile(
                                            title: Text('Male'),
                                            value: 'Male',
                                            groupValue: _gender,
                                            onChanged: (value) {
                                              setState(() {
                                                _gender = value.toString();
                                              });
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          flex: 55,
                                          child: RadioListTile(
                                            title: Text('Female'),
                                            value: 'Female',
                                            groupValue: _gender,
                                            onChanged: (value) {
                                              setState(() {
                                                _gender = value.toString();
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                left: 20.0,
                                top: 0.0,
                                child: Container(
                                  color: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  child: Text(
                                    'Gender',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20.0),
                          Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  value: _bloodGroup,
                                  decoration: InputDecoration(
                                    labelText: 'Blood Group (Optional)',
                                    border: OutlineInputBorder(),
                                  ),
                                  items: [
                                    'NA',
                                    'A+',
                                    'B+',
                                    'AB+',
                                    'O+',
                                    'A-',
                                    'B-',
                                    'AB-',
                                    'O-',
                                  ]
                                      .map((bloodType) => DropdownMenuItem(
                                            child: Text(bloodType),
                                            value: bloodType,
                                          ))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _bloodGroup = value!;
                                    });
                                  },
                                  // If you don't want any validation, don't add a validator here.
                                  validator:
                                      null, // No validation, because it's optional
                                ),
                              ),
                              SizedBox(width: 20.0),
                              Expanded(
                                child: TextFormField(
                                  controller: _ageController,
                                  decoration: InputDecoration(
                                    labelText: 'Age',
                                    border: OutlineInputBorder(),
                                  ),
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(3),
                                  ],
                                  keyboardType: TextInputType.number,
                                  autovalidateMode: AutovalidateMode.onUnfocus,
                                  validator: (value) {
                                    value = value?.trim();
                                    if (value == null || value.isEmpty) {
                                      return "Field should not be empty";
                                    } else if (!GetUtils.isNumericOnly(value)) {
                                      return "Enter a numeric value";
                                    }
                                    return null; // No error
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20.0),
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Enter Email ID',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            autovalidateMode: AutovalidateMode.onUnfocus,
                            validator: (value) {
                              value = value?.trim();
                              if (value == null || value.isEmpty) {
                                return "Filed Shold not be empty";
                              } else if (!GetUtils.isEmail(value)) {
                                return "Enter a valid Email";
                              }
                              return null; // No error
                            },
                          ),
                          const SizedBox(height: 20.0),
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
                                'SUBMIT',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          if (errorMessage != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text(
                                errorMessage!,
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          const SizedBox(height: 30.0),
                          Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 20.0),
                              child: Text(
                                'Copyright © 2024 - SureCare',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 12.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Image.asset(
                'assets/Registers.png',
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
