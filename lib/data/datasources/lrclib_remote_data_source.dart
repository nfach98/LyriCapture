import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lyricapture/data/models/lyrics_model.dart';

abstract class LrcLibRemoteDataSource {
  Future<LyricsModel> getLyrics(String trackName, String artistName);
}

class LrcLibRemoteDataSourceImpl implements LrcLibRemoteDataSource {
  final http.Client client;
  final String _lrcLibApiBaseUrl = 'https://lrclib.net/api';

  LrcLibRemoteDataSourceImpl({required this.client});

  @override
  Future<LyricsModel> getLyrics(String trackName, String artistName) async {
    // Note: lrclib.net API seems to prefer '+' for spaces in query params based on typical web practices,
    // but Uri.encodeQueryComponent handles spaces and other special characters correctly.
    final queryParameters = {
      'track_name': trackName,
      'artist_name': artistName,
      // Other parameters like album_name, duration can be added if needed for more specific search
    };
    final uri = Uri.parse('$_lrcLibApiBaseUrl/get').replace(queryParameters: queryParameters);

    final response = await client.get(uri);

    if (response.statusCode == 200) {
      // The API returns a JSON array of possible matches.
      // For simplicity, we'll take the first one if it exists.
      // A more robust solution might involve some logic to pick the best match.
      final List<dynamic> results = jsonDecode(response.body);
      if (results.isNotEmpty) {
        // Check if any of the results have non-null plainLyrics or syncedLyrics
        final validResults = results.where((item) => item['plainLyrics'] != null || item['syncedLyrics'] != null).toList();
        if (validResults.isNotEmpty) {
          return LyricsModel.fromJson(validResults.first);
        } else {
          // No results with lyrics found, return an empty model or throw specific exception
           return LyricsModel.fromJson({ // return an empty model
            'id': 0,
            'name': trackName,
            'artistName': artistName,
            'albumName': '',
            'plainLyrics': null,
            'syncedLyrics': null,
          });
        }
      } else {
        // No results found, return an empty model or throw specific exception
        // For now, returning an empty model to avoid crashing if no lyrics found.
        // This can be improved with more specific error handling or a Maybe/Optional type.
         return LyricsModel.fromJson({
          'id': 0,
          'name': trackName,
          'artistName': artistName,
          'albumName': '',
          'plainLyrics': null,
          'syncedLyrics': null,
        });
      }
    } else if (response.statusCode == 404) {
        // Specifically handle 404 as no lyrics found
        return LyricsModel.fromJson({
          'id': 0,
          'name': trackName,
          'artistName': artistName,
          'albumName': '',
          'plainLyrics': null,
          'syncedLyrics': null,
        });
    }
    else {
      throw Exception('Failed to get lyrics from LrcLib: ${response.statusCode} ${response.body}');
    }
  }
}
