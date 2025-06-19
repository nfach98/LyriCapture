import 'package:flutter/foundation.dart';
import 'package:lyricapture/domain/entities/song.dart';
import 'package:lyricapture/domain/entities/spotify_token.dart';
import 'package:lyricapture/domain/usecases/get_spotify_token.dart';
import 'package:lyricapture/domain/usecases/search_song_on_spotify.dart';
import 'package:lyricapture/domain/repositories/spotify_repository.dart';

class SongSearchProvider extends ChangeNotifier {
  final GetSpotifyToken getSpotifyToken;
  final SearchSongOnSpotify searchSongOnSpotify;
  final SpotifyRepository spotifyRepository; // Needed to pass to use cases

  bool _isLoading = false;
  List<Song> _songs = [];
  String? _error;
  SpotifyToken? _spotifyToken;

  SongSearchProvider({
    required this.getSpotifyToken,
    required this.searchSongOnSpotify,
    required this.spotifyRepository,
  });

  bool get isLoading => _isLoading;
  List<Song> get songs => _songs;
  String? get error => _error;

  Future<void> _fetchTokenIfNeeded() async {
    if (_spotifyToken == null || _isTokenExpired()) {
      try {
        _spotifyToken = await getSpotifyToken.call(spotifyRepository);
      } catch (e) {
        _error = 'Failed to get Spotify token: $e';
        // Optionally, rethrow or handle more gracefully
        rethrow;
      }
    }
  }

  bool _isTokenExpired() {
    // Basic check, a real app might store expiration time and check against current time
    return _spotifyToken == null || _spotifyToken!.expiresIn < DateTime.now().millisecondsSinceEpoch / 1000;
  }

  Future<void> search(String query) async {
    if (query.isEmpty) {
      _songs = [];
      _error = null;
      notifyListeners();
      return;
    }

    _isLoading = true;
    _songs = [];
    _error = null;
    notifyListeners();

    try {
      await _fetchTokenIfNeeded();
      if (_spotifyToken == null) {
        throw Exception("Spotify token is not available.");
      }
      final results = await searchSongOnSpotify.call(spotifyRepository, query, _spotifyToken!.accessToken);
      _songs = results;
    } catch (e) {
      _error = 'Search failed: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
