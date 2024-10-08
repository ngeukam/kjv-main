import 'package:flutter/material.dart';
import 'package:BibleEngama/models/book.dart';
import 'package:BibleEngama/models/verse.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

// MainProvider class extends ChangeNotifier for state management

class NewBlsMainProvider extends ChangeNotifier {
  // Controllers and Listeners for managing scroll positions and items
  ItemScrollController itemScrollController = ItemScrollController();
  ScrollOffsetController scrollOffsetController = ScrollOffsetController();
  ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  ScrollOffsetListener scrollOffsetListener = ScrollOffsetListener.create();

  // List to store Verse objects
  List<Verse> verses = [];
  // List to store Book objects
  List<Book> books = [];
  // Variable to manage loading state
  bool isLoading = true;

  // Method to set loading state
  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
  // Method to add a Verse to the list and notify listeners
  Future<void> addVerse({required Verse verse}) async {
    setLoading(true);  // Start loading
    verses.add(verse);
    notifyListeners();
    setLoading(false);  // End loading
  }

  // Method to add a Book to the list and notify listeners
  Future<void> addBook({required Book book}) async {
    setLoading(true);  // Start loading
    books.add(book);
    notifyListeners();
    setLoading(false);  // End loading
  }

  // Variable to store the current Verse
  Verse? currentVerse;

  // Method to update the current Verse and notify listeners
  void updateCurrentVerse({required Verse verse}) {
    currentVerse = verse;
    notifyListeners();
  }

  // Method to scroll to a specific index in the list and notify listeners
  void scrollToIndex({required int index}) {
    itemScrollController.scrollTo(
        index: index, duration: const Duration(milliseconds: 800));
    notifyListeners();
  }

  // List to store selected Verse objects
  List<Verse> selectedVerses = [];

  // Method to toggle the selection of a Verse and notify listeners
  void toggleVerse({required Verse verse}) {
    bool contains = selectedVerses.any((element) => element == verse);
    if (contains) {
      selectedVerses.remove(verse);
    } else {
      selectedVerses.add(verse);
    }
    notifyListeners();
  }

  // Method to clear the selected Verse list and notify listeners
  void clearSelectedVerses() {
    selectedVerses.clear();
    notifyListeners();
  }
}
