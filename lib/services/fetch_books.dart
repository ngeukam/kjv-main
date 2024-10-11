import 'package:BibleEngama/models/book.dart';
import 'package:BibleEngama/models/chapter.dart';
import 'package:BibleEngama/providers/main_provider.dart';
import 'package:BibleEngama/models/verse.dart';

class FetchBooks {
  // Liste des livres dans l'ordre souhaité
  static final List<String> bookOrder = [
    "Genèse", "Exode", "Lévitique", "Nombres", "Deutéronome", "Josué", "Juges",
    "Ruth", "1 Samuel", "2 Samuel", "1 Rois", "2 Rois", "1 Chroniques",
    "2 Chroniques", "Esdras", "Néhémie", "Esther", "Job", "Psaumes",
    "Proverbes", "Ecclésiaste", "Cantique des Cantiques", "Ésaïe", "Jérémie",
    "Lamentations", "Ézéchiel", "Daniel", "Osée", "Joël", "Amos", "Abdias",
    "Jonas", "Michée", "Nahum", "Habacuc", "Sophonie", "Aggée", "Zacharie",
    "Malachie",];

  // Static method to execute the fetching process
  static Future<void> execute({required MainProvider mainProvider}) async {
    List<Verse> verses = mainProvider.verses;

    // Extract unique book titles from the list of verses
    List<String> bookTitles = verses.map((e) => e.book).toSet().toList();

    // Trier les titres de livres selon l'ordre défini dans bookOrder
    bookTitles.sort((a, b) {
      int indexA = bookOrder.indexOf(a);
      int indexB = bookOrder.indexOf(b);
      return indexA.compareTo(indexB);
    });

    // Iterate through each unique book title to organize chapters and verses
    for (var bookTitle in bookTitles) {
      // Filter verses based on the current book title
      List<Verse> availableVerses =
      verses.where((v) => v.book == bookTitle).toList();

      // Extract unique chapter numbers from the filtered verses
      List<int> availableChapters =
      availableVerses.map((e) => e.chapter).toSet().toList();

      List<Chapter> chapters = [];

      // Iterate through each unique chapter number to organize verses
      for (var element in availableChapters) {
        // Create a Chapter object for each unique chapter
        Chapter chapter = Chapter(
          title: element,
          verses: availableVerses.where((v) => v.chapter == element).toList(),
        );

        chapters.add(chapter);
      }

      // Create a Book object for the current book title and its organized chapters
      Book book = Book(title: bookTitle, chapters: chapters);

      // Add the created Book to the mainProvider's list of books
      // Check if the book already exists in the mainProvider's list of books
      if (!mainProvider.books.any((b) => b.title == book.title)) {
        // Add the created Book to the mainProvider's list of books
        mainProvider.addBook(book: book);
      }
    }
  }
}
