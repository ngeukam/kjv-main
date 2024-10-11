import 'package:flutter/material.dart';
import 'package:BibleEngama/models/verse.dart';
import 'package:BibleEngama/providers/main_provider.dart';
import 'package:provider/provider.dart';

class VerseWidget extends StatelessWidget {
  final Verse verse;
  final int index;
  final double fontSize; // Taille de police

  const VerseWidget({
    Key? key,
    required this.verse,
    required this.index,
    this.fontSize = 16.0, // Valeur par défaut si non spécifiée
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MainProvider>(
      builder: (context, mainProvider, child) {
        bool isSelected = mainProvider.selectedVerses.contains(verse);
        return ListTile(
          onTap: () {
            mainProvider.toggleVerse(verse: verse);
          },
          title: RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style.copyWith(fontSize: fontSize),
              children: <TextSpan>[
                TextSpan(
                  text: verse.verse == 1 ? "${verse.chapter}" : "${verse.verse} ",
                  style: TextStyle(
                    fontSize: verse.verse == 1 ? 45 : fontSize,
                    fontWeight: verse.verse == 1 ? FontWeight.bold : FontWeight.w500,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                TextSpan(
                  text: verse.text.trim(),
                  style: TextStyle(
                    fontSize: fontSize,
                    color: isSelected ? Theme.of(context).colorScheme.primary : null,
                    decorationColor: Theme.of(context).colorScheme.primary,
                    decorationStyle: TextDecorationStyle.dotted,
                    decoration: isSelected ? TextDecoration.underline : null,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
