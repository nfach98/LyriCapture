class Lyrics {
  final String id;
  final String trackName;
  final String artistName;
  final String albumName;
  final String? plainLyrics;
  final String? syncedLyrics;

  Lyrics({
    required this.id,
    required this.trackName,
    required this.artistName,
    required this.albumName,
    this.plainLyrics,
    this.syncedLyrics,
  });

  Lyrics copyWith({
    String? id,
    String? trackName,
    String? artistName,
    String? albumName,
    String? plainLyrics,
    String? syncedLyrics,
  }) {
    return Lyrics(
      id: id ?? this.id,
      trackName: trackName ?? this.trackName,
      artistName: artistName ?? this.artistName,
      albumName: albumName ?? this.albumName,
      plainLyrics: plainLyrics ?? this.plainLyrics,
      syncedLyrics: syncedLyrics ?? this.syncedLyrics,
    );
  }

  @override
  String toString() {
    return 'Lyrics(id: $id, trackName: $trackName, artistName: $artistName, albumName: $albumName, plainLyrics: $plainLyrics, syncedLyrics: $syncedLyrics)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Lyrics &&
        other.id == id &&
        other.trackName == trackName &&
        other.artistName == artistName &&
        other.albumName == albumName &&
        other.plainLyrics == plainLyrics &&
        other.syncedLyrics == syncedLyrics;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      trackName.hashCode ^
      artistName.hashCode ^
      albumName.hashCode ^
      plainLyrics.hashCode ^
      syncedLyrics.hashCode;
}
