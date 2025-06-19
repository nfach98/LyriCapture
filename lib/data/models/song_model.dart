import 'package:lyricapture/data/models/album_model.dart';
import 'package:lyricapture/data/models/artist_model.dart';
import 'package:lyricapture/domain/entities/song.dart';

class SongModel {
  final String id;
  final String name;
  final List<ArtistModel> artists;
  final AlbumModel album;

  SongModel({
    required this.id,
    required this.name,
    required this.artists,
    required this.album,
  });

  factory SongModel.fromJson(Map<String, dynamic> json) {
    return SongModel(
      id: json['id'],
      name: json['name'],
      artists: (json['artists'] as List)
          .map((a) => ArtistModel.fromJson(a))
          .toList(),
      album: AlbumModel.fromJson(json['album']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'artists': artists.map((a) => a.toJson()).toList(),
      'album': album.toJson(),
    };
  }

  Song toDomain() {
    return Song(
      id: id,
      name: name,
      artistName: artists.isNotEmpty ? artists.map((a) => a.name).join(', ') : 'Unknown Artist',
      albumName: album.name,
      albumArtUrl: album.images.isNotEmpty ? album.images.first.url : null,
    );
  }
}
