class FormModel {
  final String? body1;
  final Map<String, List<String>>? body2; // Changement de List<Body2Item> à Map
  final String? body3;

  FormModel({this.body1, this.body2, this.body3});

  factory FormModel.fromJson(Map<String, dynamic> json) {
    // On suppose que body2 est un Map, donc il n'est pas nécessaire de le convertir en Body2Item
    var body2Map = json['body2'] as Map<String, dynamic>?;

    // Convertir le Map en Map<String, List<String>>
    Map<String, List<String>>? body2Items = body2Map?.map((key, value) {
      return MapEntry(key, List<String>.from(value));
    });

    return FormModel(
      body1: json['body1'],
      body2: body2Items,
      body3: json['body3'],
    );
  }
}
