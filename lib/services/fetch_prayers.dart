import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class FetchPrayers {
  //final String apiUrl = 'http://localhost:5000/api/prayer/prayers';
  final String apiUrl = 'https://vmi1929509.contaboserver.net:8450/api/prayer/prayers';

  Future<List> fetchPrayers() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final response = await http.get(Uri.parse(apiUrl), headers: {
      'Authorization': 'Bearer $token', // Utilisation standard de Bearer Token
    },);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load prayers');
    }
  }
}
