import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loader_overlay/loader_overlay.dart';
import '../APIs/RegisterAPI.dart';
import '../Modals/RegisterModel.dart';

class RegisterScreen extends StatefulWidget {
  final String fullName;

  RegisterScreen({required this.fullName});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _ageFocusNode = FocusNode();
  final ApiService apiService = ApiService();
  final FocusNode _bloodGroupFocusNode = FocusNode();
  String _gender = 'Male';
  String _bloodGroup = 'A+';
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.fullName;
    _emailFocusNode.addListener(_hideErrorMessage);
    _ageFocusNode.addListener(_hideErrorMessage);
    _bloodGroupFocusNode.addListener(_hideErrorMessage);
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _ageFocusNode.dispose();
    _bloodGroupFocusNode.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _hideErrorMessage() {
    if (_emailFocusNode.hasFocus ||
        _ageFocusNode.hasFocus ||
        _bloodGroupFocusNode.hasFocus) {
      setState(() {
        errorMessage = null;
      });
    }
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email';
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validateAge(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your age';
    } else if (int.tryParse(value) == null || int.parse(value) < 1) {
      return 'Please enter a valid age';
    }
    return null;
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pushNamed('/currentloaction');
    }
    // if (_formKey.currentState!.validate()) {
    //   context.loaderOverlay.show(); // Show loading overlay

    //   final UserModel user = UserModel(
    //     name: _nameController.text,
    //     email: _emailController.text,
    //     age: _ageController.text,
    //     gender: _gender,
    //     bloodGroup: _bloodGroup,
    //   );

    //   try {
    //     final response = await apiService.registerUser(user);
    //     context.loaderOverlay.hide(); // Hide loading overlay

    //     Fluttertoast.showToast(
    //       msg: response['message'] ?? "Basic Information Saved",
    //       toastLength: Toast.LENGTH_SHORT,
    //       gravity: ToastGravity.BOTTOM,
    //       backgroundColor: const Color.fromARGB(255, 0, 70, 10),
    //       textColor: Colors.white,
    //       fontSize: 16.0,
    //     );

    //     Navigator.of(context).pushNamed('/currentloaction');
    //   } catch (e) {
    //     context.loaderOverlay.hide(); // Hide loading overlay on error
    //     setState(() {
    //       errorMessage = 'Failed to submit data. Error: $e';
    //     });

    //     Fluttertoast.showToast(
    //       msg: errorMessage!,
    //       toastLength: Toast.LENGTH_SHORT,
    //       gravity: ToastGravity.BOTTOM,
    //       backgroundColor: Colors.red,
    //       textColor: Colors.white,
    //       fontSize: 16.0,
    //     );
    //   }
    // } else {
    //   setState(() {
    //     errorMessage = "Please fill in all required fields.";
    //   });
    // }
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
                  'Data Posting To DB',
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
                        'Basic Information',
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
                                  focusNode: _bloodGroupFocusNode,
                                  decoration: InputDecoration(
                                    labelText: 'Blood Group',
                                    border: OutlineInputBorder(),
                                  ),
                                  items: [
                                    'A+',
                                    'B+',
                                    'AB+',
                                    'O+',
                                    'A-',
                                    'B-',
                                    'AB-',
                                    'O-'
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
                                ),
                              ),
                              SizedBox(width: 20.0),
                              Expanded(
                                child: TextFormField(
                                  controller: _ageController,
                                  focusNode: _ageFocusNode,
                                  decoration: InputDecoration(
                                    labelText: 'Age',
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: validateAge,
                                  onChanged: (value) {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() {
                                        errorMessage = null;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20.0),
                          TextFormField(
                            controller: _emailController,
                            focusNode: _emailFocusNode,
                            decoration: InputDecoration(
                              labelText: 'Enter Email ID',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: validateEmail,
                            onChanged: (value) {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  errorMessage = null;
                                });
                              }
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
