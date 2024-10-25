import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/contact.dart' as contacts_service;
import 'package:fluttercontactpicker/fluttercontactpicker.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
    print("Opening phone book...");
    print("[LOG - ${DateTime.now()}] Starting address confirmation process...");

    // Validate form fields

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
      print("[LOG - ${DateTime.now()}] Mobile Number: ${widget.mobileNumber}");

      // Call the instance method onConfirmAddress
      print(
          "[LOG - ${DateTime.now()}] Sending address confirmation request...");
      final response =
          await addressAPI.onConfirmAddress(address, widget.mobileNumber);

      // Log the entire response for debugging
      print("[LOG - ${DateTime.now()}] Response: $response");

      // Check for success status codes (200 or 201)
      if (response.statusCode == 200) {
        showSuccessToast(msg: "Address details saved successfully!");
        print("[LOG - ${DateTime.now()}] Address sent successfully.");

        // Success - navigate to the dashboard screen
        print(
            "[LOG - ${DateTime.now()}] Navigating to dashboard with sublocality: ${widget.sublocality}");

        VerificationMessage.registraionMessage(context);

        await Future.delayed(Duration(seconds: 3));
        Navigator.pushNamedAndRemoveUntil(
          context,
          "/dashboard", // This should match the registered route exactly
          (Route<dynamic> route) => false, // Remove all previous routes
          arguments: widget.sublocality, // Pass the sublocality as an argument
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
      print("[LOG - ${DateTime.now()}] Error during address confirmation: $e");
    }

    print("[LOG - ${DateTime.now()}] Address confirmation process ended.");

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

    // Clear the form after saving
    _formKey.currentState!.reset();
    receiverNameController.clear();
    phoneNumberController.clear();
    selectedCategory = null;
  }

  PhoneContact? _selectedContact;

  Future<void> _pickPhoneContact() async {
    // showSuccessToast(msg: "_pickPhoneContact");

    try {
      // Request permission to access contacts if not granted already
      PermissionStatus permissionStatus = await Permission.contacts.status;
      if (permissionStatus != PermissionStatus.granted) {
        permissionStatus = await Permission.contacts.request();
        if (permissionStatus != PermissionStatus.granted) {
          showErrorToast(msg: "Contacts permission denied");
          return;
        }
      }

      final PhoneContact contact =
          await FlutterContactPicker.pickPhoneContact();

      // Check if contact and phone number are not null
      if (contact != null &&
          contact.phoneNumber != null &&
          contact.phoneNumber!.number != null) {
        setState(() {
          _selectedContact = contact;
          showSuccessToast(msg: "Selected Contact: ${contact.fullName}");
          phoneNumberController.text = contact.phoneNumber!.number!;
        });
      } else {
        showErrorToast(msg: "No phone number found in contact");
      }
    } catch (e) {
      showErrorToast(msg: "Failed to pick contact");
      print('Failed to pick contact: ${e.toString()}');
    }
  }

  // Future<void> _openPhoneBook() async {
  //   print("Attempting to open phone book...");

  //   PermissionStatus permission = await Permission.contacts.status;
  //   print('Initial permission status: $permission');

  //   if (permission.isDenied) {
  //     permission = await Permission.contacts.request();
  //     print('Requested permission status: $permission');
  //   }

  //   if (permission.isGranted) {
  //     try {
  //       Iterable<Contact> contacts = await ContactsService.getContacts();
  //       print('Fetched contacts: ${contacts.length} found.');

  //       if (contacts.isEmpty) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text('No contacts found.')),
  //         );
  //         return;
  //       }

  //       Contact? selectedContact = await showDialog<Contact>(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return AlertDialog(
  //             title: const Text('Select a contact'),
  //             content: Container(
  //               width: double.maxFinite,
  //               height: 400.0,
  //               child: ListView.builder(
  //                 itemCount: contacts.length,
  //                 itemBuilder: (context, index) {
  //                   Contact contact = contacts.elementAt(index);
  //                   return ListTile(
  //                     title: Text(contact.displayName ?? ''),
  //                     onTap: () {
  //                       Navigator.of(context).pop(contact);
  //                     },
  //                   );
  //                 },
  //               ),
  //             ),
  //           );
  //         },
  //       );

  //       if (selectedContact != null &&
  //           selectedContact.phones != null &&
  //           selectedContact.phones!.isNotEmpty) {
  //         setState(() {
  //           phoneNumberController.text =
  //               selectedContact.phones!.first.value ?? '';
  //         });
  //       }
  //     } catch (e) {
  //       print('Error fetching contacts: $e');
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Failed to fetch contacts: $e')),
  //       );
  //     }
  //   } else if (permission.isPermanentlyDenied) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text(
  //             'Permission to access contacts is permanently denied. Please enable it in settings.'),
  //       ),
  //     );
  //     openAppSettings();
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Permission to access contacts was denied.'),
  //       ),
  //     );
  //   }
  // }

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
                    initialCameraPosition: CameraPosition(
                      target: LatLng(widget.lat ?? 0.0,
                          widget.lng ?? 0.0), // Jubilee Hills coordinates
                      zoom: 15.0,
                    ),
                    markers: {
                      Marker(
                        markerId: const MarkerId('current location'),
                        position: LatLng(widget.lat ?? 0.0, widget.lng ?? 0.0),
                        infoWindow: const InfoWindow(
                          title: 'current location',
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
                    autovalidateMode: AutovalidateMode.onUnfocus,
                    decoration: const InputDecoration(
                        labelText: 'HOUSE / FLAT / FLOOR NO.'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter a valid HOUSE / FLAT / FLOOR NO.";
                      }
                      // else if (!GetUtils.isUsername(value)) {
                      //   // Adjust validation condition if needed
                      //   return "Invalid input for HOUSE / FLAT / FLOOR NO.";
                      // }
                      return null; // No error
                    },
                  ),
                ),

                // Apartment/Road/Area field (optional, with validation)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: apartmentController,
                    decoration: const InputDecoration(
                        labelText: 'APARTMENT / ROAD / AREA (OPTIONAL)'),
                  ),
                ),

                // Direction to reach field (optional, with validation)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: directionController,
                    decoration: const InputDecoration(
                        labelText: 'DIRECTION TO REACH (OPTIONAL)'),
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
                          selectedCategory =
                              selectedCategory == 'Friends & Family'
                                  ? null
                                  : 'Friends & Family'; // Toggle the button
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
                          selectedCategory = selectedCategory == 'Others'
                              ? null
                              : 'Others'; // Toggle the button
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

                // Conditionally show input fields based on selected category
                if (selectedCategory == 'Friends & Family') ...[
                  // Name field (required)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: receiverNameController,
                      decoration: const InputDecoration(
                        labelText: 'Receiver\'s Name',
                        border: OutlineInputBorder(),
                      ),
                      autovalidateMode: AutovalidateMode.onUnfocus,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter a valid Receiver\'s Name";
                        } else if (!GetUtils.isUsername(value)) {
                          return "Enter a valid Receiver\'s Name";
                        }
                        return null; // No error
                      },
                    ),
                  ),

                  // Phone Number field (required for Friends & Family)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: phoneNumberController,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(10),
                      ],
                      decoration: InputDecoration(
                        labelText: 'Receiver\'s Phone Number',
                        border: OutlineInputBorder(),
                        // Phone icon

                        suffixIcon: IconButton(
                          icon: Icon(Icons.contacts), // Phonebook icon
                          onPressed:
                              _pickPhoneContact, // Open phonebook on click
                        ), // Phone icon
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                ],

                if (selectedCategory == 'Others') ...[
                  // Optionally, you could add additional fields or a message here for "Others"
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: receiverNameController,
                      autovalidateMode: AutovalidateMode.onUnfocus,
                      decoration: const InputDecoration(
                        labelText: 'Save as',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter a valid Name";
                        } else if (!GetUtils.isUsername(value)) {
                          return "Enter a valid Name";
                        }
                        return null; // No error
                      },
                    ),
                  ),

                  // Phone Number field (required for Friends & Family)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: phoneNumberController,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(10),
                      ],
                      decoration: InputDecoration(
                        labelText: 'Receiver\'s Phone Number',
                        border: OutlineInputBorder(),
                        // Phone icon
                        suffixIcon: IconButton(
                          icon: Icon(Icons.contacts), // Phonebook icon
                          // onPressed: _openPhoneBook, // Open phonebook on click
                          onPressed:
                              _pickPhoneContact, // Open phonebook on click
                        ), // Phone icon
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Center(
                    child: Text(
                      "If you don't provide a phone number, we will use the following number to contact you: ${widget.mobileNumber}.",
                      style: TextStyle(
                          color: const Color.fromARGB(255, 173, 86, 4)),
                    ),
                  ),
                ],

                // const SizedBox(height: 50.0),

                // Save Address Button

                // ),

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
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        child: ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _saveAddressDetails();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 96, 15, 196),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          child: const Text('SAVE ADDRESS DETAILS'),
        ),
      ),
    );
  }
}
