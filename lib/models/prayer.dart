class PrayerModel {
  final String title;
  final String description;
  final String? author; // Utilisez ? pour un champ optionnel
  final DateTime createdAt;

  PrayerModel({
    required this.title,
    required this.description,
    this.author,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory PrayerModel.fromJson(Map<String, dynamic> json) {
    return PrayerModel(
      title: json['title'],
      description: json['description'],
      author: json['author'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
