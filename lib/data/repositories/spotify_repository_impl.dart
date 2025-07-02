import 'package:injectable/injectable.dart'; // Added injectable
import 'package:lyricapture/domain/entities/spotify_token.dart';
import 'package:lyricapture/domain/entities/song.dart';
import 'package:lyricapture/domain/repositories/spotify_repository.dart';
import 'package:lyricapture/data/datasources/spotify_remote_data_source.dart';

const String _spotifyClientId = 'a86085f7a2bf48f192a6c6cbaf14e25e';
const String _spotifyClientSecret = 'c0a6931e2ac6464bb099c1aca0ddea41';

@LazySingleton(as: SpotifyRepository)
class SpotifyRepositoryImpl implements SpotifyRepository {
  final SpotifyRemoteDataSource _remoteDataSource;

  SpotifyRepositoryImpl({
    required SpotifyRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<SpotifyToken> getToken() async {
    final spotifyTokenModel = await _remoteDataSource.getToken(
      clientId: _spotifyClientId,
      clientSecret: _spotifyClientSecret,
    );
    return spotifyTokenModel.toDomain();
  }

  @override
  Future<List<Song>> searchSongs(String query, String token) async {
    final songModels = await _remoteDataSource.searchSongs(query, token);
    return songModels.map((model) => model.toDomain()).toList();
  }
}
