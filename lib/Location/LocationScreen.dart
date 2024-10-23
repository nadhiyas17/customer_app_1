import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart'; // Import this for geocoding functionality
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../Loading/FullScreeenLoader.dart'; // For Google Maps

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  String? _address = "";
  String? locationMessage = "Fetching location...";
  bool isLoading = true;
  Position? _currentPosition;
  late GoogleMapController _mapController;
  final LatLng _initialPosition =
      const LatLng(20.5937, 78.9629); // Default location (India)
  @override
  void initState() {
    super.initState();
    _checkAndRequestLocationPermission();
    _getLocation();
  }

  // Function to check and request location permission
  Future<void> _checkAndRequestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      _getLocation();
    } else {
      setState(() {
        locationMessage = "Location permission denied.";
        isLoading = false;
      });
      showToast("GPS is disabled. Please enable it to access your location.");
    }
  }

  @override

  // Function to get the current location of the user
  Future<void> _getLocation() async {
    LocationPermission permission;

    // Check for location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }

    // If location permission is granted, fetch the location
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      try {
        LocationSettings locationSettings = LocationSettings(
          accuracy: LocationAccuracy
              .high, // You can use LocationAccuracy.low, medium, etc.
          distanceFilter:
              100, // Optional: distance in meters before location updates
        );

        Position position = await Geolocator.getCurrentPosition(
          locationSettings: locationSettings,
        );

        setState(() {
          _currentPosition = position;
          locationMessage = "${position.latitude}, ${position.longitude}";
          isLoading = false;
        });

        // Get the address from location coordinates
        _getAddress(position.latitude, position.longitude);

        // Send the location and address to the backend
        _sendLocationToBackend(
            position.latitude, position.longitude, _address!);
        await Future.delayed(Duration(seconds: 3));

        Navigator.pushReplacementNamed(context, '/login');
      } catch (e) {
        setState(() {
          locationMessage = "Error getting location: $e";
          isLoading = false;
        });
      }
    } else {
      setState(() {
        locationMessage = "Permission Denied!";
        isLoading = false;
      });
    }
  }

  // Function to get the address from coordinates
  Future<void> _getAddress(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        // Formatting the address to match the desired structure
        _address =
            "${place.street}, ${place.locality},${place.subLocality}, ${place.administrativeArea}, ${place.postalCode}, ${place.country}";
        setState(() {}); // Update UI with the formatted address
      }
    } catch (e) {
      print("Error getting address: $e");
    }
  }

  // Function to send the user's location and address to the backend
  Future<void> _sendLocationToBackend(
      double latitude, double longitude, String address) async {
    final url = Uri.parse(
        'https://example.com/api/location'); // Replace with your backend URL
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
            {'latitude': latitude, 'longitude': longitude, 'address': address}),
      );

      if (response.statusCode == 200) {
        print("Location and address sent successfully!");
      } else {
        print("Failed to send location and address: ${response.body}");
      }
    } catch (error) {
      print("Error sending location and address: $error");
    }
  }

  // Function to open Google Maps with the current location
  // void _openMap() {
  //   if (_currentPosition != null) {
  //     Navigator.of(context).push(
  //       MaterialPageRoute(
  //         builder: (context) => MapScreen(
  //           latitude: _currentPosition!.latitude,
  //           longitude: _currentPosition!.longitude,
  //         ),
  //       ),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isLoading
            ? FullscreenLoader(message: "Fetching Address")
            : Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.location_on,
                        size: 60, color: Colors.green),
                    const SizedBox(height: 10),
                    const Text(
                      "Current Location  ",
                      style: TextStyle(fontSize: 20, color: Colors.green),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      _address ?? "",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 5),
                    // Text(
                    //   locationMessage ?? "",
                    //   style: const TextStyle(fontSize: 16),
                    // ),
                    // const SizedBox(height: 20),
                    // ElevatedButton(
                    //   onPressed: _openMap, // Button to open the map
                    //   child: const Text("Show on Map"),
                    // ),
                  ],
                ),
              ),
      ),
    );
  }

  void showToast(String s) {}
}

// MapScreen Widget to display Google Maps
// class MapScreen extends StatelessWidget {
//   final double latitude;
//   final double longitude;

//   const MapScreen({super.key, required this.latitude, required this.longitude});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Your Location")),
//       body: GoogleMap(
//         initialCameraPosition: CameraPosition(
//           target: LatLng(latitude, longitude),
//           zoom: 15,
//         ),
//         markers: {
//           Marker(
//             markerId: const MarkerId("currentLocation"),
//             position: LatLng(latitude, longitude),
//           ),
//         },
//       ),
//     );
//   }
// }
