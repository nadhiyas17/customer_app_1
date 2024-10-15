import 'package:flutter/material.dart';
import 'package:flutter_google_maps_webservices/places.dart';

const kGoogleApiKey = 'AIzaSyDY_mNvqPbcGCRiwor1IVcJ5pyRmstm9XY'; // Replace with your API key
final GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class CurrentLocationScreen extends StatefulWidget {
  const CurrentLocationScreen({Key? key}) : super(key: key);

  @override
  State<CurrentLocationScreen> createState() => _CurrentLocationScreenState();
}

class _CurrentLocationScreenState extends State<CurrentLocationScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Prediction> _suggestions = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  // Function to fetch location predictions based on the search input
  Future<void> _fetchSuggestions(String input) async {
    if (input.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      try {
        final response = await _places.autocomplete(input);
        if (response.predictions != null) {
          setState(() {
            _suggestions = response.predictions!;
          });
        }
      } catch (e) {
        print("Error fetching suggestions: $e");
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _suggestions = [];
      });
    }
  }

  // Function to handle search input changes
  void _onSearchChanged(String value) {
    _fetchSuggestions(value);
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
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                fillColor: Colors.amber,
                hintText: "Search for a location...",
                border: OutlineInputBorder(),
                
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _suggestions.clear();
                  },
                ),
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          _isLoading
              ? CircularProgressIndicator()
              : Expanded(
                  child: ListView.builder(
                    itemCount: _suggestions.length,
                    itemBuilder: (context, index) {
                      final suggestion = _suggestions[index];
                      return ListTile(
                        title: Text(suggestion.description ?? ""),
                        onTap: () {
                          // Handle the location selection
                          _searchController.text = suggestion.description ?? "";
                          _suggestions.clear(); // Clear suggestions after selection
                          // TODO: Handle location selection logic here
                        },
                      );
                    },
                  ),
                ),
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: SizedBox(
              width: 150.0,
              child: ElevatedButton.icon(
                onPressed: () {}, // Trigger search on button press
                icon: Icon(Icons.my_location),
                label: Text("Locate Me"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.red,
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    
                  ),
                ),
              ),
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
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton(
                      onPressed: () {}, // Change location logic here
                      child: Text("Change"),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text("Street: "),
                Text("City: "),
                Text("State: "),
                Text("Pincode: "),
                Text("Current Position: "),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Logic to confirm address
                        },
                        child: Text("Confirm Address"),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 15.0),
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
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
