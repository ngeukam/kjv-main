import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:BibleEngama/models/verse.dart';
import 'package:BibleEngama/providers/main_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FetchVerses {
  // Liste des livres dans l'ordre souhaité
  static final List<String> bookOrder = [
    "Genèse", "Exode", "Lévitique", "Nombres", "Deutéronome", "Josué", "Juges",
    "Ruth", "1 Samuel", "2 Samuel", "1 Rois", "2 Rois", "1 Chroniques",
    "2 Chroniques", "Esdras", "Néhémie", "Esther", "Job", "Psaumes",
    "Proverbes", "Ecclésiaste", "Cantique des Cantiques", "Ésaïe", "Jérémie",
    "Lamentations", "Ézéchiel", "Daniel", "Osée", "Joël", "Amos", "Abdias",
    "Jonas", "Michée", "Nahum", "Habacuc", "Sophonie", "Aggée", "Zacharie",
    "Malachie",
  ];

  // Static method to execute the fetching process
  static Future<void> execute({required MainProvider mainProvider}) async {
    final String apiUrl = 'https://vmi1929509.contaboserver.net:8450/api/bls/retrieve-verse';
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    try {
      final response = await http.get(Uri.parse(apiUrl), headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
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
        mainProvider.verses.clear();
        // Ajoutez chaque verset trié au provider
        for (var verse in verses) {
          if (!mainProvider.verses.contains(verse)) {
            mainProvider.addVerse(verse: verse);
          }
        }
      } else {
        throw Exception('Failed to load verses: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching verses: $error');
    }
  }
}
