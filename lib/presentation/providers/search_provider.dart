import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart'; // Added injectable
import 'package:lyricapture/domain/entities/song.dart';
import 'package:lyricapture/domain/entities/spotify_token.dart';
import 'package:lyricapture/domain/usecases/get_spotify_token.dart';
import 'package:lyricapture/domain/usecases/search_song_on_spotify.dart';
// import 'package:lyricapture/domain/repositories/spotify_repository.dart'; // No longer needed if use cases are used

@injectable // Added annotation
class SearchProvider extends ChangeNotifier {
  final GetSpotifyToken _getSpotifyToken;
  final SearchSongOnSpotify _searchSongOnSpotify;

  bool _isLoading = false;
  List<Song> _songs = [];
  String? _error;
  SpotifyToken? _spotifyToken; // Renamed for consistency

  SearchProvider({
    required GetSpotifyToken getSpotifyToken, // Constructor params updated
    required SearchSongOnSpotify searchSongOnSpotify,
    // required SpotifyRepository spotifyRepository, // Removed
  })  : _getSpotifyToken = getSpotifyToken,
        _searchSongOnSpotify = searchSongOnSpotify;
  // _spotifyRepository = spotifyRepository; // Removed

  bool get isLoading => _isLoading;
  List<Song> get songs => _songs;
  String? get error => _error;

  Future<void> _fetchTokenIfNeeded() async {
    // Using _spotifyToken field now
    if (_spotifyToken == null || _isTokenExpired(_spotifyToken!)) {
      try {
        // Use case call doesn't need repository passed here anymore
        _spotifyToken = await _getSpotifyToken.call();
      } catch (e) {
        _error = 'Failed to get Spotify token: $e';
        rethrow;
      }
    }
  }

  // Placeholder: Real implementation would check expiry time against current time
  // This logic might need a timestamp of when the token was fetched.
  bool _isTokenExpired(SpotifyToken token) {
    // This is a simplified check. A robust solution needs to store the fetch time
    // and calculate `DateTime.now().millisecondsSinceEpoch / 1000 > (fetchTime + expiresInSeconds)`.
    // For now, let's assume it might expire quickly for testing or always refetch if not ideal.
    // Or, if expiresIn is an absolute timestamp, then:
    // return DateTime.now().millisecondsSinceEpoch / 1000 > token.expiresIn;
    return false; // Assuming token once fetched is valid for its lifetime for now
  }

  Future<void> search(String query) async {
    if (query.isEmpty) {
      _songs = [];
      _error = null;
      notifyListeners();
      return;
    }

    _isLoading = true;
    _songs = []; // Clear previous songs
    _error = null;
    notifyListeners();

    try {
      await _fetchTokenIfNeeded();
      if (_spotifyToken == null) {
        // Check internal _spotifyToken
        throw Exception("Spotify token is not available.");
      }
      // Use case call for searchSongOnSpotify
      _songs =
          await _searchSongOnSpotify.call(query, _spotifyToken!.accessToken);
    } catch (e) {
      _error = 'Search failed: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> reset() async {
    _isLoading = false;
    _songs = [];
    _error = null;
    notifyListeners();
  }
}
