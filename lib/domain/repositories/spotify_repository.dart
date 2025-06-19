import 'package:lyricapture/domain/entities/spotify_token.dart';
import 'package:lyricapture/domain/entities/song.dart';

abstract class SpotifyRepository {
  Future<SpotifyToken> getToken();
  Future<List<Song>> searchSongs(String query, String token);
}
