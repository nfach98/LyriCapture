import 'package:injectable/injectable.dart'; // Added injectable
import 'package:lyricapture/domain/entities/spotify_token.dart';
import 'package:lyricapture/domain/entities/song.dart';
import 'package:lyricapture/domain/repositories/spotify_repository.dart';
import 'package:lyricapture/data/datasources/spotify_remote_data_source.dart';

// TODO: Replace with your actual client ID and secret
// These constants are used by the repository itself, not directly injected for now.
const String _spotifyClientId = 'YOUR_SPOTIFY_CLIENT_ID';
const String _spotifyClientSecret = 'YOUR_SPOTIFY_CLIENT_SECRET';

@LazySingleton(as: SpotifyRepository) // Added annotation
class SpotifyRepositoryImpl implements SpotifyRepository {
  final SpotifyRemoteDataSource _remoteDataSource; // Changed to _remoteDataSource for convention

  // Constructor updated to match the new field name if changed, and for DI
  SpotifyRepositoryImpl({required SpotifyRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<SpotifyToken> getToken() async {
    // Using the field _remoteDataSource now
    final spotifyTokenModel = await _remoteDataSource.getToken(_spotifyClientId, _spotifyClientSecret);
    return spotifyTokenModel.toDomain();
  }

  @override
  Future<List<Song>> searchSongs(String query, String token) async {
    // Using the field _remoteDataSource now
    final songModels = await _remoteDataSource.searchSongs(query, token);
    return songModels.map((model) => model.toDomain()).toList();
  }
}
