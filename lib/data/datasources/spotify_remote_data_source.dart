import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart'; // Added injectable
import 'package:lyricapture/data/models/spotify_token_model.dart';
import 'package:lyricapture/data/models/song_model.dart';

abstract class SpotifyRemoteDataSource {
  Future<SpotifyTokenModel> getToken({
    required String clientId,
    required String clientSecret,
  });
  Future<List<SongModel>> searchSongs(String query, String token);
}

@LazySingleton(as: SpotifyRemoteDataSource)
class SpotifyRemoteDataSourceImpl implements SpotifyRemoteDataSource {
  final Dio _dio;

  SpotifyRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<SpotifyTokenModel> getToken({
    required String clientId,
    required String clientSecret,
  }) async {
    try {
      final response = await _dio.post(
        'https://accounts.spotify.com/api/token', // Full URL
        data: {
          'grant_type': 'client_credentials',
          'client_id': clientId,
          'client_secret': clientSecret,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        return SpotifyTokenModel.fromJson(response.data);
      } else {
        throw Exception(
          'Failed to get Spotify token: Status ${response.statusCode}, Data: ${response.data}',
        );
      }
    } on DioException catch (e) {
      var errorMessage = 'Failed to get Spotify token (DioError): ${e.message}';
      if (e.response != null) {
        errorMessage += '\nResponse Data: ${e.response?.data}';
        errorMessage += '\nStatus Code: ${e.response?.statusCode}';
      }
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('Failed to get Spotify token: $e');
    }
  }

  @override
  Future<List<SongModel>> searchSongs(String query, String token) async {
    try {
      final response = await _dio.get(
        'https://api.spotify.com/v1/search', // Full URL
        queryParameters: {
          'q': query,
          'type': 'track',
          'limit': 20, // Example limit
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        // Dio automatically decodes JSON
        final List<dynamic> trackItems = response.data['tracks']['items'];
        return trackItems
            .map((item) => SongModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(
            'Failed to search songs: Status ${response.statusCode}, Data: ${response.data}');
      }
    } on DioException catch (e) {
      String errorMessage = 'Failed to search songs (DioError): ${e.message}';
      if (e.response != null) {
        errorMessage += '\nResponse Data: ${e.response?.data}';
        errorMessage += '\nStatus Code: ${e.response?.statusCode}';
      }
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('Failed to search songs: $e');
    }
  }
}
