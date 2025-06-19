import 'package:lyricapture/domain/entities/song.dart';
import 'package:lyricapture/domain/repositories/spotify_repository.dart';

class SearchSongOnSpotify {
  Future<List<Song>> call(SpotifyRepository repository, String query, String token) {
    return repository.searchSongs(query, token);
  }
}
