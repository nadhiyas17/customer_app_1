import 'dart:convert';
import 'package:cutomer_app/APIs/BaseUrl.dart';

import 'package:http/http.dart' as http;

import '../Toasters/Toaster.dart';

// import 'BaseUrl.dart';

class LoginApiService {
  final String endpoint = 'sign-in-or-sign-up';

  Future<Map<String, dynamic>> signInOrSignUp(
      String fullname, String mobileNumber) async {
    print("==============================================================");
    try {
      print(
          "============================================================== try");
      final response = await http.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'fullName': fullname,
          'mobileNumber': mobileNumber,
        }),
      );
      print('===================================${response.body}');
      if (response.statusCode == 200) {
        showSuccessToast(
          msg: 'OTP Send successfully',
        );
        print(
            "============================================================== success");
        print("Successfully added");
        return json.decode(response.body);
      } else {
        showErrorToast(msg:"server not respond");
        print(
            "============================================================== error");
        print("Response body: ${response.body}"); // Log response body
        return {
          'error':
              'Failed to sign in or sign up. Status: ${response.statusCode}'
        };
      }
    } catch (e) {
      print(
          "============================================================== catch");
      print("Error details: $e"); // Log detailed error
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
