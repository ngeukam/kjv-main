import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:BibleEngama/models/verse.dart';
import 'package:BibleEngama/providers/main_provider.dart';

// Class responsible for fetching verses from a JSON file

class FetchVerses {
  // Static method to execute the fetching process
  static Future<void> execute({required MainProvider mainProvider}) async {
    // Replace with your remote API URL
    final String apiUrl = 'https://vmi1929509.contaboserver.net:8450/api/bls/retrieve-verse';

    try {
      // Make the HTTP GET request
      final response = await http.get(Uri.parse(apiUrl));

      // Check for successful response
      if (response.statusCode == 200) {
        // Decode the JSON string into a List of dynamic objects
        List<dynamic> jsonList = json.decode(response.body);

        // Loop through each JSON object, then convert it to a Verse, and add it to the provider's list
        for (var json in jsonList) {
          mainProvider.addVerse(verse: Verse.fromJson(json));
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
