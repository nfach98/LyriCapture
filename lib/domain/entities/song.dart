class Song {
  final String id;
  final String name;
  final String artistName;
  final String albumName;
  final String? albumArtUrl;

  Song({
    required this.id,
    required this.name,
    required this.artistName,
    required this.albumName,
    this.albumArtUrl,
  });

  Song copyWith({
    String? id,
    String? name,
    String? artistName,
    String? albumName,
    String? albumArtUrl,
  }) {
    return Song(
      id: id ?? this.id,
      name: name ?? this.name,
      artistName: artistName ?? this.artistName,
      albumName: albumName ?? this.albumName,
      albumArtUrl: albumArtUrl ?? this.albumArtUrl,
    );
  }

  @override
  String toString() {
    return 'Song(id: $id, name: $name, artistName: $artistName, albumName: $albumName, albumArtUrl: $albumArtUrl)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Song &&
        other.id == id &&
        other.name == name &&
        other.artistName == artistName &&
        other.albumName == albumName &&
        other.albumArtUrl == albumArtUrl;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      artistName.hashCode ^
      albumName.hashCode ^
      albumArtUrl.hashCode;
}
