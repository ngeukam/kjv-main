import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:BibleEngama/models/form.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FetchForm {
  //final String baseUrl = "http://localhost:5000/api/form/forms";
  final String baseUrl = 'https://vmi1929509.contaboserver.net:8450/api/form/forms';// Remplacez par votre URL API

  Future<FormModel> fetchFormData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $token', // Utilisation standard de Bearer Token
      },
    );

    if (response.statusCode == 200) {
      // Décodez la réponse JSON
      final List<dynamic> decodedResponse = json.decode(response.body);// Affichez le tableau d'objets

      if (decodedResponse.isNotEmpty) {
        // Récupérez le premier élément du tableau et créez un FormModel
        return FormModel.fromJson(decodedResponse[0]);
      } else {
        throw Exception('No data found');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }
}
