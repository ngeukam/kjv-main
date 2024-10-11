import 'package:flutter/material.dart';
import 'package:BibleEngama/models/book.dart';
import 'package:BibleEngama/models/verse.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class MainProvider extends ChangeNotifier {
  ItemScrollController itemScrollController = ItemScrollController();
  ScrollOffsetController scrollOffsetController = ScrollOffsetController();
  ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  ScrollOffsetListener scrollOffsetListener = ScrollOffsetListener.create();

  List<Verse> verses = [];
  List<Book> books = [];
  bool isLoading = true;

  double _fontSize = 16.0; // Taille de police par défaut
  double get fontSize => _fontSize;

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<void> addVerse({required Verse verse}) async {
    setLoading(true);
    verses.add(verse);
    notifyListeners();
    setLoading(false);
  }

  Future<void> addBook({required Book book}) async {
    setLoading(true);
    books.add(book);
    notifyListeners();
    setLoading(false);
  }

  Verse? currentVerse;

  void updateCurrentVerse({required Verse verse}) {
    currentVerse = verse;
    notifyListeners();
  }

  void scrollToIndex({required int index}) {
    itemScrollController.scrollTo(
        index: index, duration: const Duration(milliseconds: 800));
    notifyListeners();
  }

  List<Verse> selectedVerses = [];

  void toggleVerse({required Verse verse}) {
    bool contains = selectedVerses.any((element) => element == verse);
    if (contains) {
      selectedVerses.remove(verse);
    } else {
      selectedVerses.add(verse);
    }
    notifyListeners();
  }

  void clearSelectedVerses() {
    selectedVerses.clear();
    notifyListeners();
  }

  // Méthode pour mettre à jour la taille de police
  void updateFontSize(double newSize) {
    _fontSize = newSize;
    notifyListeners();
  }
}
