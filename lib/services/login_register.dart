import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:BibleEngama/pages/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginRegisterService {
  //final FlutterSecureStorage storage = FlutterSecureStorage();
  static const String baseUrl = '';
  //static const String baseUrl = 'http://localhost:5000/api/auth';
  // Change to your API URL

  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      // Ensure the token exists before saving it
      final String token = responseData['token'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      return responseData;
    } else {
      throw Exception('Failed to log in: ${response.body}');
    }
  }
  /*Future<http.Response> checkToken(String endpoint) async {
    final token = await storage.read(key: 'token');
    final response = await http.get(Uri.parse('$baseUrl/$endpoint'), headers: {
      'Authorization': 'Bearer Token $token',
    });
    // Check for unauthorized error (403)
    if (response.statusCode == 403 || token ==null) {
      await storage.delete(key: 'token');
      Get.offAll(() => LoginPage()); // Redirect to LoginPage// Token expired
    }
    return response;
  }*/

  Future<void> logout() async {
    try {
      // Delete the token from storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');  // Clear the token

      // Navigate to the LoginPage
      Get.snackbar(
        'Aurevoir',
        'Vous êtes déconnecté.e!',
        backgroundColor: Colors.white,
        borderColor: Colors.orange,
        borderWidth: 2,
        duration: Duration(seconds: 3),
        snackPosition: SnackPosition.TOP,
      );
      Get.offAll(() => LoginPage());
    } catch (e) {
      // Handle any errors that occur during the logout process
      print("Logout error: $e");
      // Optionally, you can show a snackbar or alert to inform the user
      Get.snackbar('Logout Failed', 'Could not log out. Please try again.');
    }
  }
}
