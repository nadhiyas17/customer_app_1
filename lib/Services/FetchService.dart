import 'dart:convert';
import 'package:cutomer_app/Services/Service.dart';
import 'package:http/http.dart' as http;

Future<List<Service>> fetchServices() async {
  final response = await http.get(Uri.parse('https://api.example.com/services'));

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((service) => Service.fromJson(service)).toList();
  } else {
    throw Exception('Failed to load services');
  }
}
