import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:BibleEngama/models/verse.dart';
import 'package:BibleEngama/pages/books_page.dart';
import 'package:BibleEngama/providers/main_provider.dart';
import 'package:BibleEngama/widgets/verse_widget.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ... (initState et autres méthodes restent inchangées)

  @override
  Widget build(BuildContext context) {
    return Consumer<MainProvider>(
      builder: (context, mainProvider, child) {
        List<Verse> verses = mainProvider.verses;
        Verse? currentVerse = mainProvider.currentVerse;
        bool isSelected = mainProvider.selectedVerses.isNotEmpty;

        return Scaffold(
          appBar: AppBar(
            title: currentVerse == null || isSelected
                ? null
                : GestureDetector(
              onTap: () {
                Get.to(
                      () => BooksPage(
                    chapterIdx: currentVerse.chapter,
                    bookIdx: currentVerse.book,
                  ),
                  transition: Transition.leftToRight,
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(currentVerse.book),
                  SizedBox(width: 4),
                  Icon(
                    FontAwesomeIcons.bookBible,
                    color: Colors.grey,
                    size: 20,
                  ),
                ],
              ),
            ),
            actions: [
              if (isSelected)
                IconButton(
                  onPressed: () async {
                    // ... (copie dans le presse-papiers)
                  },
                  icon: const Icon(Icons.copy_rounded),
                ),
              if (!isSelected)
                IconButton(
                  onPressed: () async {
                    Get.to(
                          () => SearchPage(verses: verses),
                      transition: Transition.rightToLeft,
                    );
                  },
                  icon: const Icon(Icons.search_rounded),
                ),
            ],
          ),
          body: ScrollablePositionedList.builder(
            itemCount: verses.length,
            itemBuilder: (context, index) {
              Verse verse = verses[index];
              return VerseWidget(verse: verse, index: index);
            },
            itemScrollController: mainProvider.itemScrollController,
            itemPositionsListener: mainProvider.itemPositionsListener,
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.transparent,
            onPressed: () {
              Get.to(() => BooksPage(
                chapterIdx: currentVerse?.chapter ?? 1,
                bookIdx: currentVerse?.book ?? '1',
              ), transition: Transition.fade);
            },
            tooltip: 'Ouvrir la page des livres',
            child: Icon(
              FontAwesomeIcons.bookBible,
              color: Colors.black,
              size: 35,
            ),
          ),
        );
      },
    );
  }
}
