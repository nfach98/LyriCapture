import 'package:lyricapture/domain/entities/spotify_token.dart';
import 'package:lyricapture/domain/repositories/spotify_repository.dart';

class GetSpotifyToken {
  Future<SpotifyToken> call(SpotifyRepository repository) {
    return repository.getToken();
  }
}
