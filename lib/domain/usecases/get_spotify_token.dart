import 'package:injectable/injectable.dart';
import 'package:lyricapture/domain/entities/spotify_token.dart';
import 'package:lyricapture/domain/repositories/spotify_repository.dart';

@lazySingleton
class GetSpotifyToken {
  final SpotifyRepository _repository;

  GetSpotifyToken(this._repository);

  Future<SpotifyToken> call() { // No longer takes repository as parameter
    return _repository.getToken();
  }
}
