import 'package:lyricapture/domain/entities/lyrics.dart';

class LyricsModel {
  final int id;
  final String name; // track name
  final String artistName;
  final String albumName;
  final String? plainLyrics;
  final String? syncedLyrics;

  LyricsModel({
    required this.id,
    required this.name,
    required this.artistName,
    required this.albumName,
    this.plainLyrics,
    this.syncedLyrics,
  });

  factory LyricsModel.fromJson(Map<String, dynamic> json) {
    return LyricsModel(
      id: json['id'] ?? 0, // lrclib might not always provide an id
      name: json['name'] ?? json['trackName'] ?? 'Unknown Track', // trackName is also used
      artistName: json['artistName'] ?? 'Unknown Artist',
      albumName: json['albumName'] ?? 'Unknown Album',
      plainLyrics: json['plainLyrics'],
      syncedLyrics: json['syncedLyrics'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'artistName': artistName,
      'albumName': albumName,
      'plainLyrics': plainLyrics,
      'syncedLyrics': syncedLyrics,
    };
  }

  Lyrics toDomain() {
    return Lyrics(
      // lrclib provides 'id' as int, domain entity expects String.
      // Also, the API uses 'name' for trackName.
      id: id.toString(),
      trackName: name,
      artistName: artistName,
      albumName: albumName,
      plainLyrics: plainLyrics,
      syncedLyrics: syncedLyrics,
    );
  }
}
