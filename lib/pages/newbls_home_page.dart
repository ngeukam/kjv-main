import 'package:BibleEngama/pages/newbls_book_page.dart';
import 'package:BibleEngama/services/newbls_fetch_books.dart';
import 'package:BibleEngama/services/newbls_fetch_verses.dart';
import 'package:BibleEngama/services/save_current_index.dart';
import 'package:BibleEngama/utils/auth_helper.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:BibleEngama/models/verse.dart';
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

  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(milliseconds: 100),
          () async {
        NewBlsMainProvider newBlsMainProvider = Provider.of<NewBlsMainProvider>(context, listen: false);
        newBlsMainProvider.itemPositionsListener.itemPositions.addListener(() {
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
        });

        await NewBlsFetchVerses.execute(newBlsMainProvider: newBlsMainProvider).then(
              (_) async {
            await NewBlsFetchBooks.execute(newBlsMainProvider: newBlsMainProvider)
                .then((_) => setState(() {
              _loading = false;
            }));
          },
        );

        await ReadLastIndex.execute().then((index) {
          if (index != null) {
            newBlsMainProvider.scrollToIndex(index: index);
          }
        });
      },
    );
  }

  String formattedSelectedVerses({required List<Verse> verses}) {
    String result = verses
        .map((e) => " [${e.book} ${e.chapter}:${e.verse}] ${e.text.trim()}")
        .join();
    return "$result [Nouveau BLS 1910 Pro]";
  }

  @override
  Widget build(BuildContext context) {
    _checkLogin(context); // Vérification de connexion
    return Consumer<NewBlsMainProvider>(builder: (context, newBlsMainProvider, child) {
      List<Verse> verses = newBlsMainProvider.verses;
      Verse? currentVerse = newBlsMainProvider.currentVerse;
      bool isSelected = newBlsMainProvider.selectedVerses.isNotEmpty;
      bool isLoading = newBlsMainProvider.isLoading;

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
              decoration: TextDecoration.none,
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
                  String string = formattedSelectedVerses(verses: newBlsMainProvider.selectedVerses);
                  await FlutterClipboard.copy(string).then(
                        (_) => newBlsMainProvider.clearSelectedVerses(),
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
            // Ajouter un bouton pour ajuster la taille de la police
            IconButton(
              icon: const Icon(Icons.text_fields),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    double newFontSize = newBlsMainProvider.fontSize;
                    return AlertDialog(
                      title: Text('Changer la taille de la police'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Slider(
                            value: newFontSize,
                            min: 10,
                            max: 30,
                            divisions: 20,
                            label: newFontSize.round().toString(),
                            onChanged: (value) {
                              newFontSize = value;
                            },
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            newBlsMainProvider.updateFontSize(newFontSize);
                            Navigator.of(context).pop();
                          },
                          child: Text('OK'),
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
            return VerseWidget(
              verse: verse,
              index: index,
              fontSize: newBlsMainProvider.fontSize, // Passer la taille de police
            );
          },
          itemScrollController: newBlsMainProvider.itemScrollController,
          itemPositionsListener: newBlsMainProvider.itemPositionsListener,
        ),
        floatingActionButton: !isLoading
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
            : null,
      );
    });
  }

  void _checkLogin(BuildContext context) async {
    final isLoggedIn = await AuthHelper.checkLoginStatus();
    if (!isLoggedIn) {
      Get.offAllNamed('/LoginPage'); // Redirige vers la page de connexion
    }
  }
}
