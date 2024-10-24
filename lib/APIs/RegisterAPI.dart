import 'dart:convert';
import 'package:cutomer_app/Toasters/Toaster.dart';
import 'package:http/http.dart' as http;
import '../Modals/RegisterModel.dart';
import 'BaseUrl.dart';

class ApiService {
  // Define the base URL of your API

  // Method to register the user
  Future<Map<String, dynamic>> registerUser(RegisterModel user) async {
    final url = Uri.parse('$baseUrl/basic-details');

    try {
      // Log: Starting API call
      print('--- API Call: Register User ---');
      print('URL: $url');

      // Log: Sending data
      print('Sending data: ${jsonEncode(user.toJson())}');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(user.toJson()), // Use the toJson method from UserModel
      );

      // Log: HTTP response status and body
      print('--- Response Received ---');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      // Checking the status of the response
      if (response.statusCode == 200) {
        // Log: Successful registration
        print('User registered successfully. Returning response data.');
        print('User registration complete. Basic information saved.');
        return jsonDecode(response.body);
      }

      // Log: Resource created
      //  showErrorToast(response['message'] ??
      //       'Failed to sign in or sign up. Please try again.');

      else {
        // Log: Error in registration
        print(
            'Error: Failed to register user. Status code: ${response.statusCode}');
        print('Error response body: ${response.body}');
        throw Exception(
            'Failed to register user. Status code: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      // Log: Error during registration
      print('Error occurred during registration: $e');
      throw Exception('An error occurred during registration: $e');
    } finally {
      // Log: End of API call
      print('--- End of API Call: Register User ---');
    }
  }
}
