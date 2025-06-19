import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lyricapture/data/models/spotify_token_model.dart';
import 'package:lyricapture/data/models/song_model.dart';

abstract class SpotifyRemoteDataSource {
  Future<SpotifyTokenModel> getToken(String clientId, String clientSecret);
  Future<List<SongModel>> searchSongs(String query, String token);
}

class SpotifyRemoteDataSourceImpl implements SpotifyRemoteDataSource {
  final http.Client client;
  final String _spotifyApiBaseUrl = 'https://api.spotify.com/v1';
  final String _spotifyAccountsBaseUrl = 'https://accounts.spotify.com/api';

  SpotifyRemoteDataSourceImpl({required this.client});

  @override
  Future<SpotifyTokenModel> getToken(String clientId, String clientSecret) async {
    final response = await client.post(
      Uri.parse('$_spotifyAccountsBaseUrl/token'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Basic ${base64Encode(utf8.encode('$clientId:$clientSecret'))}',
      },
      body: {'grant_type': 'client_credentials'},
    );

    if (response.statusCode == 200) {
      return SpotifyTokenModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get token from Spotify: ${response.statusCode} ${response.body}');
    }
  }

  @override
  Future<List<SongModel>> searchSongs(String query, String token) async {
    final response = await client.get(
      Uri.parse('$_spotifyApiBaseUrl/search?q=${Uri.encodeQueryComponent(query)}&type=track'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> items = data['tracks']['items'];
      return items.map((item) => SongModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to search songs on Spotify: ${response.statusCode} ${response.body}');
    }
  }
}
