import 'package:injectable/injectable.dart';
import 'package:lyricapture/domain/entities/song.dart';
import 'package:lyricapture/domain/repositories/spotify_repository.dart';

@lazySingleton
class SearchSongOnSpotify {
  final SpotifyRepository _repository;

  SearchSongOnSpotify(this._repository);

  Future<List<Song>> call(String query, String token) { // token is still passed
    return _repository.searchSongs(query, token);
  }
}
