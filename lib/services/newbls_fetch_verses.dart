import 'dart:convert';
import 'package:BibleEngama/providers/newbls_main_provider.dart';
import 'package:http/http.dart' as http;
import 'package:BibleEngama/models/verse.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Class responsible for fetching verses from a JSON file

class NewBlsFetchVerses {
  // Static method to execute the fetching process
  static Future<void> execute({required NewBlsMainProvider newBlsMainProvider}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    // Replace with your remote API URL
    //final String apiUrl = 'http://localhost:5000/api/newbls/retrieve-verse';
    final String apiUrl = 'https://vmi1929509.contaboserver.net:8450/api/newbls/retrieve-verse';

    try {
      // Make the HTTP GET request
      final response = await http.get(Uri.parse(apiUrl),  headers: {
        'Authorization': 'Bearer $token', // Utilisation standard de Bearer Token
      },);
      // Check for successful response
      if (response.statusCode == 200) {
        // Decode the JSON string into a List of dynamic objects
        List<dynamic> jsonList = json.decode(response.body);

        // Loop through each JSON object, then convert it to a Verse, and add it to the provider's list
        for (var json in jsonList) {
          Verse verse = Verse.fromJson(json);
          // Vérifiez si le verset existe déjà avant de l'ajouter
          if (!newBlsMainProvider.verses.contains(verse)) {
            newBlsMainProvider.addVerse(verse: verse);
          }
        }
      } else {
        // Handle the error, e.g., print an error message or throw an exception
        throw Exception('Failed to load verses: ${response.statusCode}');
      }
    } catch (error) {
      // Handle any exceptions or errors that occur during the HTTP request
      print('Error fetching verses: $error');
    }
  }
}
