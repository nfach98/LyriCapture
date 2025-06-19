class ArtistModel {
  final String name;

  ArtistModel({required this.name});

  factory ArtistModel.fromJson(Map<String, dynamic> json) {
    return ArtistModel(
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}
