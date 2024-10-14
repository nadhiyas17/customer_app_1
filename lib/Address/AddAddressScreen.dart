import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  _AddAddressScreenState createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  String _address = "";
  bool _isUsingCurrentLocation = false;
  List<String> _savedAddresses = [
    
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  // Function to get the current location of the user
  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _isUsingCurrentLocation = true;
        _getAddress(position.latitude, position.longitude);
      });
    } catch (e) {
      print("Error getting current location: $e");
    }
  }

  // Function to get the address from coordinates
  Future<void> _getAddress(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        _address =
            "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}, ${place.country}";
        setState(() {});
      }
    } catch (e) {
      print("Error getting address: $e");
    }
  }

  // Function to handle the "Use my current location" button press
  void _useCurrentLocation() {
    setState(() {
      _isUsingCurrentLocation = true;
    });
    _getCurrentLocation();
  }

  // Function to handle the "Add new address" button press
  void _addNewAddress() {
    // TODO: Implement logic to add a new address
    print("Add new address clicked");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF6B3FA0), // Blue from the mock screen
        title: Text(
          'Add Address',
          style: TextStyle(color: Colors.white), // White text for title
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white), // White back icon
          onPressed: () => Navigator.pop(context),
        ),
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.home, color: Colors.white), // White home icon
        //     onPressed: () {
        //       // Handle home button action
        //     },
        //   ),
        // ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Try for area, city...',
                hintStyle: TextStyle(color: Colors.grey), // Light gray hint text
                contentPadding: EdgeInsets.all(12.0), // Add content padding
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0), // Rounded border
                  borderSide: BorderSide(color: Color(0xFFE0E0E0)), // Light gray border
                ),
                suffixIcon: Icon(Icons.search),
                
                
                
              ),
              
              
              onChanged: (value) {
                // Handle address search
              },
            ),
           ListTile(
  leading: Icon(Icons.my_location, color: Colors.red, ),
  title: Text(
    'Use my current location',
    style: TextStyle(color: Colors.red), // Red text for "Use my current location"
  ),
  trailing: Icon(Icons.chevron_right,),
  onTap: _useCurrentLocation,
),
ListTile(
  leading: Icon(Icons.add, color: Colors.red, ),
  title: Text(
    'Add new address',
    style: TextStyle(color: Colors.red), // Red text for "Add new address"
  ),
  onTap: _addNewAddress,
),
            Divider(
              color: Color(0xFFE0E0E0), // Light gray divider
            ),
            // Text(
            //   'SAVED ADDRESSES',
            //   style: TextStyle(fontWeight: FontWeight.bold,
            //   color: Colors.grey),
              
            //    // Bold text for saved addresses heading
            // ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _savedAddresses.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_savedAddresses[index]),
                  // Add more actions or buttons as needed
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}