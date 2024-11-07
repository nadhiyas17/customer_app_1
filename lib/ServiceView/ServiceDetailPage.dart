import 'package:cutomer_app/ServiceView/FetchViewService.dart';
import 'package:flutter/material.dart';
import 'ServiceDetail.dart';

class ServiceDetailsPage extends StatefulWidget {
  @override
  _ServiceDetailsPageState createState() => _ServiceDetailsPageState();
}

class _ServiceDetailsPageState extends State<ServiceDetailsPage> {
  late ApiService apiService;
  ServiceDetails? serviceDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
    fetchServiceDetails();
  }

  Future<void> fetchServiceDetails() async {
    try {
      final details = await apiService.fetchServiceDetails();
      setState(() {
        serviceDetails = details;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle error (e.g., show a snackbar or log the error)
      print("Error fetching service details: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Service Details'),
        backgroundColor: Color(0xFF6B3FA0),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : serviceDetails == null
              ? Center(child: Text('Service details not available'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      serviceDetails!.imageUrl.isNotEmpty
                          ? Image.network(serviceDetails!.imageUrl)
                          : Container(),
                      SizedBox(height: 16),
                      Text(
                        serviceDetails!.title,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        serviceDetails!.description,
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Includes:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        serviceDetails!.includes,
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Ready Period:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        serviceDetails!.readyPeriod,
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Preparation:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        serviceDetails!.preparation,
                        style: TextStyle(fontSize: 16),
                      ),
                      Spacer(),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50),
                          backgroundColor: Color(0xFF6B3FA0),
                        ),
                        onPressed: () {
                          // Handle booking confirmation
                        },
                        child: Text(
                          'CONFIRM BOOKING',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
