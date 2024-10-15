import 'dart:convert';
import 'package:http/http.dart' as http;

import 'BaseUrl.dart';

class LoginApiService {
  final String endpoint = 'sign-in-or-sign-up';

  Future<Map<String, dynamic>> signInOrSignUp(
      String fullname, String mobileNumber) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}/${endpoint}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'fullName': fullname,
          'mobileNumber': mobileNumber,
        }),
      );

      if (response.statusCode == 200) {
        print("Suufully added");
        // Success - Parse response body
        return json.decode(response.body);
      } else {
        // Failed - Handle API errors
        return {
          'error':
              'Failed to sign in or sign up. Status: ${response.statusCode}'
        };
      }
    } catch (e) {
      // Exception - Handle connection or parsing errors
      return {'error': 'An error occurred: $e'};
    }
  }

  Future<Map<String, dynamic>> verifyOtp(String phoneNumber, String otp) async {
    final url = 'http://localhost:9090/api/customers/verify-otp';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'phoneNumber': phoneNumber,
        'otp': otp,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to verify OTP: ${response.body}');
    }
  }
}
