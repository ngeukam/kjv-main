class Verse {
  final String book;
  final int chapter;
  final int verse;
  final String text;
  Verse({
    required this.book,
    required this.chapter,
    required this.verse,
    required this.text,
  });

  // Factory method to create a Verse object from JSON data
  factory Verse.fromJson(Map<String, dynamic> json) {
    return Verse(
      book: json['book'],
      chapter: int.parse(json['chapter']),
      verse: int.parse(json['verse']),
      text: json['text'],
    );
  }
  @override
  bool operator == (Object other) {
    if (identical(this, other)) return true;

    return other is Verse &&
        other.book == book &&
        other.chapter == chapter &&
        other.verse == verse;
  }
  @override
  int get hashCode => book.hashCode ^ chapter.hashCode ^ verse.hashCode;
}
