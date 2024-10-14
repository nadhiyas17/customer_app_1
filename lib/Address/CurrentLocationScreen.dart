import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_google_maps_webservices/places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

const kGoogleApiKey = 'AIzaSyDY_mNvqPbcGCRiwor1IVcJ5pyRmstm9XY'; // Replace with your API key
final GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class CurrentLocation extends StatefulWidget {
  const CurrentLocation({super.key});

  @override
  State<CurrentLocation> createState() => _CurrentLocationState();
}

class _CurrentLocationState extends State<CurrentLocation> {
  String _address = "Fetching location...";
  String _city = "";
  String _state = "";
  String _street = "";
  String _pincode = ""; // Variable to store the pincode
  LatLng _currentPosition = LatLng(0, 0);
  late GoogleMapController _mapController;
  bool _isLoading = true; // Track loading state
  Marker? _searchMarker; // Marker for searched location

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        setState(() {
          _address = "Location permissions are denied.";
          _isLoading = false;
        });
        return;
      }

      LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high, // You can use LocationAccuracy.low, medium, etc.
        distanceFilter: 100, // Optional: distance in meters before location updates
      );

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );

      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        setState(() {
          _address =
              "${placemark.street}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}";
          _city = placemark.locality ?? "Unknown city";
          _state = placemark.administrativeArea ?? "Unknown state";
          _street = placemark.street ?? "Unknown street";
          _pincode = placemark.postalCode ?? "Unknown pincode";
          _currentPosition = LatLng(position.latitude, position.longitude);
          _isLoading = false;
        });

        // Check if _mapController is initialized
        if (_mapController != null) {
          _mapController.animateCamera(CameraUpdate.newLatLngZoom(_currentPosition, 16));
        }
      } else {
        setState(() {
          _address = "No address found for this location.";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _address = "Failed to get location: $e";
        _isLoading = false;
      });
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _onConfirmAddress() {
    // Store address and navigate to the dashboard
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => DashboardScreen()), // Your dashboard screen
    );
    print("Selected Address: " + _address);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "Add Address",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: SizedBox(
              width: double.infinity, // Ensure the button takes the full width
              child: ElevatedButton.icon(
                onPressed: _getCurrentLocation, // Trigger search on button press
                icon: Icon(Icons.my_location),
                label: Text("Locate Me"),
                style: ElevatedButton.styleFrom(
                  alignment: Alignment.centerLeft, // Align the content to the left
                  padding: EdgeInsets.all(15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _currentPosition,
                zoom: 14.0,
              ),
              markers: {
                if (_searchMarker != null) _searchMarker!,
                Marker(
                  markerId: MarkerId("currentLocation"),
                  position: _currentPosition,
                ),
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Current Location:",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton(
                      onPressed: _getCurrentLocation,
                      child: Text("Change"),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text("Street: $_street"),
                Text("City: $_city"),
                Text("State: $_state"),
                Text("Pincode: $_pincode"),
                Text("Current Position: $_currentPosition"),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _onConfirmAddress,
                        child: Text("Confirm Address"),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 15.0),
                          foregroundColor: Colors.white, // Set text color to white
                          backgroundColor: Colors.green, // Set background color to green
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), // Rounded corners
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Dummy Dashboard Screen to navigate after confirmation
class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
      ),
      body: Center(
        child: Text("Welcome to the Dashboard!"),
      ),
    );
  }
}
