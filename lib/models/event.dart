class EventModel {
  final String title;
  final String description;
  final DateTime date;
  final String time;
  final String? location; // Champ optionnel
  final DateTime createdAt;

  EventModel({
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    this.location,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      title: json['title'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      time: json['time'],
      location: json['location'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
