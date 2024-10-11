import 'dart:convert';
import 'package:BibleEngama/providers/newbls_main_provider.dart';
import 'package:http/http.dart' as http;
import 'package:BibleEngama/models/verse.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Class responsible for fetching verses from a JSON file

class NewBlsFetchVerses {
  static final List<String> bookOrder = [
    "Matthieu", "Marc", "Luc", "Jean", "Actes", "Romains", "1 Corinthiens",
    "2 Corinthiens", "Galates", "Éphésiens", "Philippiens", "Colossiens",
    "1 Thessaloniciens", "2 Thessaloniciens", "1 Timothée", "2 Timothée",
    "Tite", "Philémon", "Hébreux", "Jacques", "1 Pierre", "2 Pierre",
    "1 Jean", "2 Jean", "3 Jean", "Jude", "Apocalypse",];
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

        List<Verse> verses = [];
        for (var json in jsonList) {
          Verse verse = Verse.fromJson(json);
          verses.add(verse);
        }

        // Trier les versets avant de les ajouter au provider
        verses.sort((a, b) {
          int bookIndexA = bookOrder.indexOf(a.book);
          int bookIndexB = bookOrder.indexOf(b.book);

          if (bookIndexA == bookIndexB) {
            if (a.chapter == b.chapter) {
              return a.verse.compareTo(b.verse);
            }
            return a.chapter.compareTo(b.chapter);
          }
          return bookIndexA.compareTo(bookIndexB);
        });
        newBlsMainProvider.verses.clear();
        for (var verse in verses) {
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
