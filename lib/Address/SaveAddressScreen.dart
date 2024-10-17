import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

class SaveAddressScreen extends StatefulWidget {
  const SaveAddressScreen({super.key});

  @override
  _SaveAddressScreenState createState() => _SaveAddressScreenState();
}

class _SaveAddressScreenState extends State<SaveAddressScreen> {
  // Form key to validate the form fields
  final _formKey = GlobalKey<FormState>();

  // Text controllers for user input
  final _houseController = TextEditingController();
  final _apartmentController = TextEditingController();
  final _directionController = TextEditingController();
  final _receiverNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  // Variable to track selected category (Friends & Family, Others)
  String? _selectedCategory;

  // A list to simulate saving address details
  final List<Map<String, String>> _savedAddresses = [];

  @override
  void dispose() {
    _houseController.dispose();
    _apartmentController.dispose();
    _directionController.dispose();
    _receiverNameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  // Function to handle saving the address details
  void _saveAddressDetails() {
    if (_formKey.currentState!.validate()) {
      // Simulate saving the address by adding it to the list
      final address = {
        'house': _houseController.text,
        'apartment': _apartmentController.text.isNotEmpty
            ? _apartmentController.text
            : 'Not provided',
        'direction': _directionController.text.isNotEmpty
            ? _directionController.text
            : 'Not provided',
        'category': _selectedCategory ?? 'Uncategorized',
        'receiverName': _receiverNameController.text.isNotEmpty
            ? _receiverNameController.text
            : 'N/A',
        'phoneNumber': _phoneNumberController.text.isNotEmpty
            ? _phoneNumberController.text
            : 'N/A',
      };

      setState(() {
        _savedAddresses.add(address);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Address details saved successfully!')),
      );

      // Clear the form after saving
      _formKey.currentState!.reset();
      _receiverNameController.clear();
      _phoneNumberController.clear();
      _selectedCategory = null;
    }
  }

  // Improved validation for all fields
  String? _validateField(String? value, {bool isRequired = false, String? fieldName}) {
    if (isRequired && (value == null || value.isEmpty)) {
      return '$fieldName is required.';
    }
    if (fieldName == 'Receiver\'s Phone Number' && value != null && value.isNotEmpty) {
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
        title: const Text('Save Address', style: TextStyle(color: Colors.white)),
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
                      target: LatLng(17.428549, 78.464774), // Jubilee Hills coordinates
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
                    controller: _houseController,
                    decoration: const InputDecoration(labelText: 'HOUSE / FLAT / FLOOR NO.'),
                    validator: (value) => _validateField(value, isRequired: true, fieldName: 'House/Flat/Floor No.'),
                  ),
                ),

                // Apartment/Road/Area field (optional, with validation)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _apartmentController,
                    decoration: const InputDecoration(labelText: 'APARTMENT / ROAD / AREA (OPTIONAL)'),
                    validator: (value) => _validateField(value, fieldName: 'Apartment/Road/Area'),
                  ),
                ),

                // Direction to reach field (optional, with validation)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _directionController,
                    decoration: const InputDecoration(labelText: 'DIRECTION TO REACH (OPTIONAL)'),
                    validator: (value) => _validateField(value, fieldName: 'Direction to Reach'),
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
                          _selectedCategory = 'Friends & Family';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedCategory == 'Friends & Family' ? Colors.purple : Colors.grey,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Friends & Family'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedCategory = 'Others';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedCategory == 'Others' ? Colors.purple : Colors.grey,
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
                    controller: _receiverNameController,
                    decoration: const InputDecoration(labelText: 'Receiver\'s name'),
                    validator: (value) => _validateField(value, isRequired: true, fieldName: 'Receiver\'s Name'),
                  ),
                ),

                // Phone Number field (conditionally shown for Friends & Family, required)
                if (_selectedCategory == 'Friends & Family')
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _phoneNumberController,
                      decoration: const InputDecoration(labelText: 'Receiver\'s Phone Number'),
                      keyboardType: TextInputType.phone,
                      validator: (value) => _validateField(value, isRequired: true, fieldName: 'Receiver\'s Phone Number'),
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
                      const Text('Saved Addresses:', style: TextStyle(fontWeight: FontWeight.bold)),
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
