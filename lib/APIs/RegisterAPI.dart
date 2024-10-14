import 'dart:convert';
import 'package:http/http.dart' as http;
 
import '../Modals/RegisterModel.dart';

class ApiService {
  // Define the base URL of your API
  static const String _baseUrl = "https://api-generator.retool.com/Y45Av7";

  // Method to register the user
  Future<Map<String, dynamic>> registerUser(UserModel user) async {
    final url = Uri.parse('$_baseUrl/data');

    try {
      // Print the data being sent for debugging
      print('Sending data: ${jsonEncode(user.toJson())}');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(user.toJson()), // Use the toJson method from UserModel
      );

      // Debug the response
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // If the request was successful (status code 200), return the response data
        return jsonDecode(response.body);
      } else if (response.statusCode == 201) {
        // Handle the case for a resource created (status code 201)
        return {"message": "Basic Infromation Saved"};
      } else {
        // If there's an error, throw an exception
        throw Exception(
            'Failed to register user. Status code: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      // Print the error for debugging
      print('Error occurred during registration: $e');
      throw Exception('An error occurred during registration: $e');
    }
  }
}
