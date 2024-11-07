import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart'; // Missing import

class SelectServicesPage extends StatefulWidget {
  @override
  _SelectServicesPageState createState() => _SelectServicesPageState();
}

class _SelectServicesPageState extends State<SelectServicesPage> {
  int totalItems = 0;
  double totalPrice = 0.0;
  final List<String> carouselImages = [
    'assets/support.png',
    'assets/support.png',
    'assets/support.png',
  ];

  final List<Service> services = [
    Service("Sponge Bath", "Maintaining physical well being", 500),
    Service("Bathing and Hygiene", "Maintaining physical well being", 600),
    Service("Grooming", "Maintaining physical well being", 700),
    Service("Assistant Leaving", "Maintaining physical well being", 800),
  ];

  @override
  void initState() {
    super.initState();
    updateTotal();
  }

  void updateTotal() {
    setState(() {
      totalItems = services.where((service) => service.quantity > 0).length;
      totalPrice =
          services.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Services"),
        backgroundColor: Color(0xFF6B3FA0),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {},
          ),
          IconButton(
            icon: FaIcon(FontAwesomeIcons.whatsapp, color: Colors.green),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search...",
                suffixIcon: Icon(
                  Icons.search,
                  color: Color(0xFF6B3FA0),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          CarouselSlider(
            items: carouselImages.map((imagePath) {
              return Image.asset(
                imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
              );
            }).toList(),
            options: CarouselOptions(
              height: 200,
              autoPlay: true,
              enlargeCenterPage: true,
              aspectRatio: 16 / 9,
              viewportFraction: 0.8,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "ELDER CARE COMPANIONS",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6B3FA0),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: services.length,
              itemBuilder: (context, index) {
                final service = services[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //  Image.asset(
                        // service.imageUrl, // Load image from the asset or network
                        // width: 60,
                        // height: 60,
                        // fit: BoxFit.cover,
                        // ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                service.name,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 4),
                              Text(service.description),
                              SizedBox(height: 5),
                              Text(
                                "From ₹${service.price} onwards",
                                style: TextStyle(color: Colors.purple),
                              ),
                              SizedBox(height: 10),
                              GestureDetector(
                                onTap: () {
                                  // Implement View Details logic here
                                },
                                child: Text(
                                  "View Details",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10),
                        service.quantity > 0
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.remove),
                                    onPressed: () {
                                      setState(() {
                                        if (service.quantity > 0) {
                                          service.quantity--;
                                          updateTotal();
                                        }
                                      });
                                    },
                                  ),
                                  Text(
                                    service.quantity.toString(),
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.add),
                                    onPressed: () {
                                      setState(() {
                                        service.quantity++;
                                        updateTotal();
                                      });
                                    },
                                  ),
                                ],
                              )
                            : ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    service.quantity++;
                                    updateTotal();
                                  });
                                },
                                child: Text("Add"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF6B3FA0),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.grey[200],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "₹ $totalPrice",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text("Added Items($totalItems)"),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    // Implement booking confirmation logic here
                  },
                  child: Text("CONFIRM BOOKING"),
                  style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      backgroundColor: Color(0xFF6B3FA0),
                      foregroundColor: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Service {
  final String name;
  final String description;
  final double price;
  int quantity;

  Service(this.name, this.description, this.price, {this.quantity = 0});
}
