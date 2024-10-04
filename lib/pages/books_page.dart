import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:BibleEngama/models/book.dart';
import 'package:BibleEngama/models/chapter.dart';
import 'package:BibleEngama/providers/main_provider.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:expandable/expandable.dart';

import '../services/login_register.dart';

class BooksPage extends StatefulWidget {
  final int chapterIdx;
  final String bookIdx;
  const BooksPage({super.key, required this.chapterIdx, required this.bookIdx});

  @override
  State<BooksPage> createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  final AutoScrollController _autoScrollController = AutoScrollController();
  final LoginRegisterService apiService = LoginRegisterService();
  List<Book> books = [];
  Book? currentBook;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    MainProvider mainProvider = Provider.of<MainProvider>(context, listen: false);
    books = mainProvider.books;
    currentBook = mainProvider.books.firstWhere(
          (element) => element.title == mainProvider.currentVerse!.book,
    );

    int index = mainProvider.books.indexOf(currentBook!);
    _autoScrollController.scrollToIndex(
      index,
      preferPosition: AutoScrollPosition.begin,
      duration: Duration(milliseconds: (10 * books.length)),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Filtrer les chapitres selon la recherche
    final filteredBooks = books.where((book) {
      return book.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          book.chapters.any((chapter) => chapter.title.toString().toLowerCase().contains(searchQuery.toLowerCase()));
    }).toList();

    return Consumer<MainProvider>(
      builder: (context, mainProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Ancien Testament"),
            //centerTitle: true,
            elevation: 4,
            actions: [
              IconButton(
                icon: Icon(Icons.logout),
                onPressed:()async{
                  await apiService.logout();
                },
              ),
            ],
          ),
          body: Stack(
            children: [
              // Image de fond avec opacité
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/blue-fond.jpg'), // Chemin de votre image
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Couche semi-transparente
              Container(
                color: Colors.lightBlueAccent.withOpacity(0.5),
              ),
              // Contenu principal
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Rechercher un livre',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredBooks.length,
                      physics: const BouncingScrollPhysics(),
                      controller: _autoScrollController,
                      itemBuilder: (context, index) {
                        Book book = filteredBooks[index];
                        return AutoScrollTag(
                          key: ValueKey(index),
                          controller: _autoScrollController,
                          index: index,
                          child: Card(
                            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ExpandablePanel(
                              controller: ExpandableController(initialExpanded: currentBook == book),
                              header: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  book.title,
                                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                              ),
                              collapsed: const SizedBox.shrink(),
                              expanded: Wrap(
                                children: List.generate(
                                  book.chapters.length,
                                      (chapterIndex) {
                                    Chapter chapter = book.chapters[chapterIndex];
                                    return GestureDetector(
                                      onTap: () {
                                        int idx = mainProvider.verses.indexWhere(
                                              (element) =>
                                          element.chapter == chapter.title &&
                                              element.book == book.title,
                                        );
                                        mainProvider.updateCurrentVerse(
                                          verse: mainProvider.verses.firstWhere(
                                                (element) =>
                                            element.chapter == chapter.title &&
                                                element.book == book.title,
                                          ),
                                        );
                                        mainProvider.scrollToIndex(index: idx);
                                        Get.back();
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: chapter.title == widget.chapterIdx.toString() &&
                                              widget.bookIdx == book.title
                                              ? Theme.of(context).colorScheme.primaryContainer
                                              : Colors.white,
                                          borderRadius: BorderRadius.circular(8),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.1),
                                              blurRadius: 5,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Chapitre ${chapter.title.toString()}',
                                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
