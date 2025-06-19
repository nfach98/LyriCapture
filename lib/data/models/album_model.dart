import 'package:lyricapture/data/models/image_model.dart';

class AlbumModel {
  final String name;
  final List<ImageModel> images;

  AlbumModel({
    required this.name,
    required this.images,
  });

  factory AlbumModel.fromJson(Map<String, dynamic> json) {
    return AlbumModel(
      name: json['name'],
      images: (json['images'] as List)
          .map((i) => ImageModel.fromJson(i))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'images': images.map((i) => i.toJson()).toList(),
    };
  }
}
