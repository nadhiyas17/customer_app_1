import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../APIs/AddressAPi.dart';
import '../Modals/AddressModal.dart';
import '../Toasters/Toaster.dart';
import '../verification/registrationsuccess.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

class SaveAddressScreen extends StatefulWidget {
  final String? sublocality;
  final String? street;
  final String? locality;
  final String? postalCode;
  final String? administrativeArea;
  final String? country;
  final double? lat;
  final double? lng;
  final String mobileNumber;

  SaveAddressScreen({
    Key? key,
    this.sublocality,
    this.street,
    this.locality,
    this.postalCode,
    this.administrativeArea,
    this.country,
    this.lat,
    this.lng,
    required this.mobileNumber,
  }) : super(key: key);

  @override
  _SaveAddressScreenState createState() => _SaveAddressScreenState();
}

class _SaveAddressScreenState extends State<SaveAddressScreen> {
  // Form key to validate the form fields
  final _formKey = GlobalKey<FormState>();

  // Text controllers for user input
  final houseController = TextEditingController();
  final apartmentController = TextEditingController();
  final directionController = TextEditingController();
  final receiverNameController = TextEditingController();
  final phoneNumberController = TextEditingController();

  // Variable to track selected category (Friends & Family, Others)
  String? selectedCategory;

  // A list to simulate saving address details
  final List<Map<String, String>> _savedAddresses = [];

  @override
  void dispose() {
    houseController.dispose();
    apartmentController.dispose();
    directionController.dispose();
    receiverNameController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  // Function to handle saving the address details
  void _saveAddressDetails() async {
    print("[LOG - ${DateTime.now()}] Starting address confirmation process...");

    // Validate form fields
    if (_formKey.currentState!.validate()) {
      try {
        // Create an instance of AddressAPI
        print("[LOG - ${DateTime.now()}] Initializing AddressAPI...");
        final addressAPI = AddressAPI();

        // Create AddressModel instance
        AddressModel address = AddressModel(
          houseNo: houseController.text,
          street: widget.street ?? 'N/A',
          city: widget.sublocality ?? 'N/A',
          state: widget.administrativeArea ?? 'N/A',
          postalCode: widget.postalCode ?? 'N/A',
          country: widget.country ?? 'N/A',
          apartment: apartmentController.text.isNotEmpty
              ? apartmentController.text
              : "NA",
          direction: directionController.text.isNotEmpty
              ? directionController.text
              : "NA",
          latitude: widget.lat ?? 0,
          longitude: widget.lng ?? 0,
          saveAs: selectedCategory ?? "NA",
          receiverName: receiverNameController.text.isNotEmpty
              ? receiverNameController.text
              : "NA",
          receiverMobileNumber: int.tryParse(phoneNumberController.text) ?? 0,
        );

        print("[LOG - ${DateTime.now()}] Address: ${address.toJson()}");
        print(
            "[LOG - ${DateTime.now()}] Mobile Number: ${widget.mobileNumber}");

        // Call the instance method onConfirmAddress
        print(
            "[LOG - ${DateTime.now()}] Sending address confirmation request...");
        final response =
            await addressAPI.onConfirmAddress(address, widget.mobileNumber);

        // Log the entire response for debugging
        print("[LOG - ${DateTime.now()}] Response: $response");

        // Check for success status codes (200 or 201)
        if (response.statusCode == 200) {
          showSuccessToast(msg: "Address sent successfully");
          print("[LOG - ${DateTime.now()}] Address sent successfully.");

          // Success - navigate to the dashboard screen
          print(
              "[LOG - ${DateTime.now()}] Navigating to dashboard with sublocality: ${widget.sublocality}");

          DialogHelper.registraionMessage(context);

          await Future.delayed(Duration(seconds: 3));
          Navigator.pushNamedAndRemoveUntil(
            context,
            "/dashboard", // This should match the registered route exactly
            (Route<dynamic> route) => false, // Remove all previous routes
            arguments:
                widget.sublocality, // Pass the sublocality as an argument
          );
        } else if (response.statusCode == 400) {
          showErrorToast(msg: "Failed to send address");
        } else {
          // Log failure with status code
          showErrorToast(msg: "Failed to send address. Status code");
          print(
              "[LOG - ${DateTime.now()}] Failed to send address. Status code: ${response.statusCode}");
        }
      } catch (e) {
        // Log error with exception message
        showErrorToast(msg: "Error during address confirmation");
        print(
            "[LOG - ${DateTime.now()}] Error during address confirmation: $e");
      }

      print("[LOG - ${DateTime.now()}] Address confirmation process ended.");
    }

    // Simulate saving the address by adding it to the list
    final address = {
      'house': houseController.text,
      'apartment': apartmentController.text.isNotEmpty
          ? apartmentController.text
          : 'Not provided',
      'direction': directionController.text.isNotEmpty
          ? directionController.text
          : 'Not provided',
      'category': selectedCategory ?? 'Uncategorized',
      'receiverName': receiverNameController.text.isNotEmpty
          ? receiverNameController.text
          : 'N/A',
      'phoneNumber': phoneNumberController.text.isNotEmpty
          ? phoneNumberController.text
          : 'N/A',
    };

    // setState(() {
    //   _savedAddresses.add(address);
    // });

    showSuccessToast(msg: "Address details saved successfully!");

    // Clear the form after saving
    _formKey.currentState!.reset();
    receiverNameController.clear();
    phoneNumberController.clear();
    selectedCategory = null;
  }

  // Improved validation for all fields
  String? _validateField(String? value,
      {bool isRequired = false, String? fieldName}) {
    if (isRequired && (value == null || value.isEmpty)) {
      return '$fieldName is required.';
    }
    if (fieldName == 'Receiver\'s Phone Number' &&
        value != null &&
        value.isNotEmpty) {
      final RegExp phoneRegExp = RegExp(r'^\+?[0-9]{10,15}$');
      if (!phoneRegExp.hasMatch(value)) {
        return '$fieldName is invalid.';
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Save Address', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: const Color(0xFF6B3FA0),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16.0),

                // Google Map Display
                Container(
                  height: 200.0,
                  width: double.infinity,
                  child: GoogleMap(
                    initialCameraPosition: const CameraPosition(
                      target: LatLng(
                          17.428549, 78.464774), // Jubilee Hills coordinates
                      zoom: 15.0,
                    ),
                    markers: {
                      Marker(
                        markerId: const MarkerId('JubileeHills'),
                        position: const LatLng(17.428549, 78.464774),
                        infoWindow: const InfoWindow(
                          title: 'Jubilee Hills',
                          snippet: 'This is a snippet',
                        ),
                      ),
                    },
                  ),
                ),

                const SizedBox(height: 16.0),

                // House/Flat/Floor field (required)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: houseController,
                    decoration: const InputDecoration(
                        labelText: 'HOUSE / FLAT / FLOOR NO.'),
                    validator: (value) => _validateField(value,
                        isRequired: true, fieldName: 'House/Flat/Floor No.'),
                  ),
                ),

                // Apartment/Road/Area field (optional, with validation)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: apartmentController,
                    decoration: const InputDecoration(
                        labelText: 'APARTMENT / ROAD / AREA (OPTIONAL)'),
                    validator: (value) =>
                        _validateField(value, fieldName: 'Apartment/Road/Area'),
                  ),
                ),

                // Direction to reach field (optional, with validation)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: directionController,
                    decoration: const InputDecoration(
                        labelText: 'DIRECTION TO REACH (OPTIONAL)'),
                    validator: (value) =>
                        _validateField(value, fieldName: 'Direction to Reach'),
                  ),
                ),

                const SizedBox(height: 16.0),
                const Text('SAVE AS'),

                // Save As buttons (Friends & Family, Others)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedCategory = 'Friends & Family';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedCategory == 'Friends & Family'
                            ? Colors.purple
                            : Colors.grey,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Friends & Family'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedCategory = 'Others';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedCategory == 'Others'
                            ? Colors.purple
                            : Colors.grey,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Others'),
                    ),
                  ],
                ),

                // Name field (required)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: receiverNameController,
                    decoration:
                        const InputDecoration(labelText: 'Receiver\'s name'),
                    validator: (value) => _validateField(value,
                        isRequired: true, fieldName: 'Receiver\'s Name'),
                  ),
                ),

                // Phone Number field (conditionally shown for Friends & Family, required)
                if (selectedCategory == 'Friends & Family')
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: phoneNumberController,
                      decoration: const InputDecoration(
                          labelText: 'Receiver\'s Phone Number'),
                      keyboardType: TextInputType.phone,
                      validator: (value) => _validateField(value,
                          isRequired: true,
                          fieldName: 'Receiver\'s Phone Number'),
                    ),
                  ),

                const SizedBox(height: 50.0),

                // Save Address Button
                Center(
                  child: ElevatedButton(
                    onPressed: _saveAddressDetails,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 96, 15, 196),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('SAVE ADDRESS DETAILS'),
                  ),
                ),

                const SizedBox(height: 50.0),

                // Display saved addresses (for demonstration)
                if (_savedAddresses.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Saved Addresses:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      ..._savedAddresses.map((address) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'House: ${address['house']}, '
                            'Category: ${address['category']}, '
                            'Receiver: ${address['receiverName']}, '
                            'Phone: ${address['phoneNumber']}, '
                            'Apartment: ${address['apartment']}, '
                            'Direction: ${address['direction']}',
                          ),
                        );
                      }).toList(),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
