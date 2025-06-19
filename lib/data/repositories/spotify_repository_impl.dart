import 'package:lyricapture/domain/entities/spotify_token.dart';
import 'package:lyricapture/domain/entities/song.dart';
import 'package:lyricapture/domain/repositories/spotify_repository.dart';
import 'package:lyricapture/data/datasources/spotify_remote_data_source.dart';

// TODO: Replace with your actual client ID and secret
const String _spotifyClientId = 'YOUR_SPOTIFY_CLIENT_ID';
const String _spotifyClientSecret = 'YOUR_SPOTIFY_CLIENT_SECRET';

class SpotifyRepositoryImpl implements SpotifyRepository {
  final SpotifyRemoteDataSource remoteDataSource;

  SpotifyRepositoryImpl({required this.remoteDataSource});

  @override
  Future<SpotifyToken> getToken() async {
    final spotifyTokenModel = await remoteDataSource.getToken(_spotifyClientId, _spotifyClientSecret);
    return spotifyTokenModel.toDomain();
  }

  @override
  Future<List<Song>> searchSongs(String query, String token) async {
    final songModels = await remoteDataSource.searchSongs(query, token);
    return songModels.map((model) => model.toDomain()).toList();
  }
}
