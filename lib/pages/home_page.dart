import 'package:BibleEngama/services/fetch_books.dart';
import 'package:BibleEngama/services/fetch_verses.dart';
import 'package:BibleEngama/services/save_current_index.dart';
import 'package:BibleEngama/utils/auth_helper.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:BibleEngama/models/verse.dart';
import 'package:BibleEngama/pages/books_page.dart';
import 'package:BibleEngama/providers/main_provider.dart';
import 'package:BibleEngama/widgets/verse_widget.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../services/read_last_index.dart';
import 'search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(milliseconds: 100),
          () async {
        MainProvider mainProvider = Provider.of<MainProvider>(context, listen: false);
        mainProvider.itemPositionsListener.itemPositions.addListener(() {
          int index = mainProvider.itemPositionsListener.itemPositions.value.last.index;
          SaveCurrentIndex.execute(index: mainProvider.itemPositionsListener.itemPositions.value.first.index);
          Verse currentVerse = mainProvider.verses[index];

          if (mainProvider.currentVerse == null) {
            mainProvider.updateCurrentVerse(verse: mainProvider.verses.first);
          }

          Verse previousVerse = mainProvider.currentVerse ?? mainProvider.verses.first;

          if (currentVerse.book != previousVerse.book) {
            mainProvider.updateCurrentVerse(verse: currentVerse);
          }
        });

        await FetchVerses.execute(mainProvider: mainProvider).then((_) async {
          await FetchBooks.execute(mainProvider: mainProvider).then((_) {
            setState(() {
              _loading = false;
            });
          });
        });

        await ReadLastIndex.execute().then((index) {
          if (index != null) {
            mainProvider.scrollToIndex(index: index);
          }
        });
      },
    );
  }

  String formattedSelectedVerses({required List<Verse> verses}) {
    String result = verses
        .map((e) => " [${e.book} ${e.chapter}:${e.verse}] ${e.text.trim()}")
        .join();

    return "$result [Ancien BLS 1910 Pro]";
  }

  @override
  Widget build(BuildContext context) {
    _checkLogin(context);
    return Consumer<MainProvider>(builder: (context, mainProvider, child) {
      List<Verse> verses = mainProvider.verses;
      Verse? currentVerse = mainProvider.currentVerse;
      bool isSelected = mainProvider.selectedVerses.isNotEmpty;
      bool isLoading = mainProvider.isLoading;

      if (_loading) {
        return Center(child: CircularProgressIndicator());
      }
      if (verses.isEmpty) {
        return Center(
          child: Text(
            'Aucun verset trouvé',
            style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 18,
                decoration: TextDecoration.none
            ),
          ),
        );
      }
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
              ],
            ),
          ),
          actions: [
            if (isSelected)
              IconButton(
                onPressed: () async {
                  String string = formattedSelectedVerses(verses: mainProvider.selectedVerses);
                  await FlutterClipboard.copy(string).then((_) => mainProvider.clearSelectedVerses());
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
            IconButton(
              icon: Icon(Icons.text_fields),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Ajuster la taille de police'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Slider(
                            value: mainProvider.fontSize,
                            min: 10,
                            max: 30,
                            divisions: 20,
                            label: mainProvider.fontSize.round().toString(),
                            onChanged: (value) {
                              mainProvider.updateFontSize(value);
                            },
                          ),
                          Text('Taille actuelle : ${mainProvider.fontSize.round()}'),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('Fermer'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : ScrollablePositionedList.builder(
          itemCount: verses.length,
          itemBuilder: (context, index) {
            Verse verse = verses[index];
            return VerseWidget(verse: verse, index: index, fontSize: mainProvider.fontSize);
          },
          itemScrollController: mainProvider.itemScrollController,
          itemPositionsListener: mainProvider.itemPositionsListener,
        ),
        floatingActionButton: !isLoading
            ? FloatingActionButton(
          backgroundColor: Colors.transparent,
          onPressed: () {
            Get.to(
                  () => BooksPage(
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
            : null,
      );
    });
  }

  void _checkLogin(BuildContext context) async {
    final isLoggedIn = await AuthHelper.checkLoginStatus();
    if (!isLoggedIn) {
      Get.offAllNamed('/LoginPage');
    }
  }
}
