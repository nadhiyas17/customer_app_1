import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  final String sublocality; // Declare the sublocality variable

  DashboardScreen({Key? key, required this.sublocality})
      : super(key: key); // Proper constructor

  @override
  Widget build(BuildContext context) {
    return HomeScreen(
        sublocality: sublocality); // Pass the sublocality to the HomeScreen
  }
}

class HomeScreen extends StatefulWidget {
  final String sublocality;

  HomeScreen({Key? key, required this.sublocality})
      : super(key: key); // Accept sublocality in HomeScreen

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget
            .sublocality), // Use the sublocality passed from the constructor
        actions: [
          const Icon(Icons.notifications),
          const SizedBox(width: 16),
          const Icon(Icons.chat),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Welcome to SureCare Services',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Container(
              height: 150.0,
              color: Colors.grey[200],
              child: const Center(
                child: Text(
                  'Our Services',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics:
                  const NeverScrollableScrollPhysics(), // Disable scroll for GridView
              children: const [
                ServiceCard(
                  icon: Icons.person,
                  title: 'Elder Care Companions',
                ),
                ServiceCard(
                  icon: Icons.medical_services,
                  title: 'Nursing Care',
                ),
                ServiceCard(
                  icon: Icons.local_pharmacy_sharp,
                  title: 'Physiotherapy',
                ),
                ServiceCard(
                  icon: Icons.person_pin,
                  title: 'Caretaker',
                ),
                ServiceCard(
                  icon: Icons.local_pharmacy,
                  title: 'Online Pharmacy',
                ),
                ServiceCard(
                  icon: Icons.people_outline,
                  title: 'Attendant',
                ),
              ],
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Wellness',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final IconData icon;
  final String title;

  const ServiceCard({Key? key, required this.icon, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 40.0,
          ),
          const SizedBox(height: 8.0),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
