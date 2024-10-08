import 'package:BibleEngama/pages/newbls_book_page.dart';
import 'package:BibleEngama/services/newbls_fetch_books.dart';
import 'package:BibleEngama/services/newbls_fetch_verses.dart';
import 'package:BibleEngama/services/save_current_index.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:BibleEngama/models/verse.dart';
import 'package:BibleEngama/pages/books_page.dart';
import 'package:BibleEngama/providers/newbls_main_provider.dart';
import 'package:BibleEngama/widgets/verse_widget.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../services/read_last_index.dart';
import 'search_page.dart';

class NewblsHomePage extends StatefulWidget {
  const NewblsHomePage({super.key});

  @override
  State<NewblsHomePage> createState() => _NewblsHomePageState();
}

class _NewblsHomePageState extends State<NewblsHomePage> {
  bool _loading = true;
  bool _isDataLoaded = false;
  @override
  void initState() {
    // We will resume to the last position the user was
    // Delayed execution to allow the UI to build before scrolling
    Future.delayed(
      const Duration(milliseconds: 100),
          () async {
        NewBlsMainProvider newBlsMainProvider = Provider.of<NewBlsMainProvider>(context, listen: false);
        newBlsMainProvider.itemPositionsListener.itemPositions.addListener(
              () {
            int index = newBlsMainProvider.itemPositionsListener.itemPositions.value.last.index;

            SaveCurrentIndex.execute(
                index: newBlsMainProvider.itemPositionsListener.itemPositions.value.first.index
            );

            Verse currentVerse = newBlsMainProvider.verses[index];

            if (newBlsMainProvider.currentVerse == null) {
              newBlsMainProvider.updateCurrentVerse(verse: newBlsMainProvider.verses.first);
            }

            Verse previousVerse = newBlsMainProvider.currentVerse == null
                ? newBlsMainProvider.verses.first
                : newBlsMainProvider.currentVerse!;

            if (currentVerse.book != previousVerse.book) {
              newBlsMainProvider.updateCurrentVerse(verse: currentVerse);
            }
          },
        );
        await NewBlsFetchVerses.execute(newBlsMainProvider: newBlsMainProvider).then(
              (_) async {
            await NewBlsFetchBooks.execute(newBlsMainProvider: newBlsMainProvider)
                .then((_) => setState(() {
              _loading = false;
            }));
          },
        );
        // Read the last index and scroll to it
        await ReadLastIndex.execute().then(
              (index) {
            if (index != null) {
              newBlsMainProvider.scrollToIndex(index: index);
            }
          },
        );
      },
    );
    super.initState();
  }
  // Process selected verses to create a formatted string
  String formattedSelectedVerses({required List<Verse> verses}) {
    String result = verses
        .map((e) => " [${e.book} ${e.chapter}:${e.verse}] ${e.text.trim()}")
        .join();

    return "$result [Nouveau BLS 1910 Pro]";
  }

  Widget build(BuildContext context) {
    return Consumer<NewBlsMainProvider>(builder: (context, mainProvider, child) {
      // Récupération des données du provider
      List<Verse> verses = mainProvider.verses;
      Verse? currentVerse = mainProvider.currentVerse;
      bool isSelected = mainProvider.selectedVerses.isNotEmpty;
      bool isLoading = mainProvider.isLoading; // Vérification de l'état de chargement

      // Ajout de vérifications de taille pour la liste
      if (_loading) {
        return Center(child: CircularProgressIndicator());
      }
      if (verses.isEmpty) {
        return Center(child: Text('Aucun verset disponible', style: TextStyle(color: Colors.black, fontSize: 18),));
      }

      return Scaffold(
        appBar: AppBar(
          title: currentVerse == null || isSelected
              ? null
              : GestureDetector(
            onTap: () {
              Get.to(
                    () => NewblsBooksPage(
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
              ],
            ),
          ),
          actions: [
            if (isSelected)
              IconButton(
                onPressed: () async {
                  // Copier dans le presse-papiers
                  String string = formattedSelectedVerses(
                      verses: mainProvider.selectedVerses);
                  await FlutterClipboard.copy(string).then(
                        (_) => mainProvider.clearSelectedVerses(),
                  );
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
        body: isLoading // Si c'est en train de charger
            ? Center(child: CircularProgressIndicator()) // Affiche le loader
            : ScrollablePositionedList.builder( // Sinon affiche la liste
          itemCount: verses.length,
          itemBuilder: (context, index) {
            Verse verse = verses[index];
            return VerseWidget(verse: verse, index: index);
          },
          itemScrollController: mainProvider.itemScrollController,
          itemPositionsListener: mainProvider.itemPositionsListener,
        ),
        // Affichage du FloatingActionButton seulement quand isLoading est false
        floatingActionButton: !isLoading // Si ce n'est pas en train de charger
            ? FloatingActionButton(
          backgroundColor: Colors.transparent,
          onPressed: () {
            Get.to(
                  () => NewblsBooksPage(
                chapterIdx: currentVerse?.chapter ?? 1,
                bookIdx: currentVerse?.book ?? '1',
              ),
              transition: Transition.fade,
            );
          },
          tooltip: 'Ouvrir la page des livres',
          child: Icon(
            FontAwesomeIcons.bookBible,
            color: Colors.black,
            size: 35,
          ),
        )
            : null, // Pas de bouton si isLoading est true
      );
    });
  }
}
