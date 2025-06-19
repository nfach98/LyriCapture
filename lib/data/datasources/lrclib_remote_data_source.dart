import 'package:dio/dio.dart';
import 'package:lyricapture/data/models/lyrics_model.dart';

abstract class LrcLibRemoteDataSource {
  Future<LyricsModel> getLyrics(String trackName, String artistName);
}

class LrcLibRemoteDataSourceImpl implements LrcLibRemoteDataSource {
  final Dio _dio;
  // final String _lrcLibApiBaseUrl = 'https://lrclib.net/api'; // Not strictly needed if full URL used

  LrcLibRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<LyricsModel> getLyrics(String trackName, String artistName) async {
    try {
      final response = await _dio.get(
        'https://lrclib.net/api/get', // Full URL
        queryParameters: {
          'track_name': trackName,
          'artist_name': artistName,
          // Consider adding album_name for better accuracy if available
          // 'album_name': albumName,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        // lrclib.net can return a list of lyrics objects or sometimes a single object directly
        // if a perfect match is found, or an error object.
        if (response.data is List) {
          final List<dynamic> results = response.data as List<dynamic>;
          if (results.isNotEmpty) {
            // Prioritize results that have either plainLyrics or syncedLyrics
            final validResult = results.firstWhere(
              (item) => (item is Map<String, dynamic>) && (item['plainLyrics'] != null || item['syncedLyrics'] != null),
              orElse: () => null, // Return null if no valid result found
            );
            if (validResult != null) {
              return LyricsModel.fromJson(validResult as Map<String, dynamic>);
            } else {
              // No result with actual lyrics content
              throw Exception('No lyrics content found for this song on LrcLib (empty lyrics).');
            }
          } else {
            // Empty list means no lyrics found
            throw Exception('No lyrics found for this song on LrcLib (empty list).');
          }
        } else if (response.data is Map<String, dynamic>) {
           // It could be a single direct match or an error object
           final Map<String, dynamic> dataMap = response.data as Map<String, dynamic>;
           if (dataMap.containsKey('error') && dataMap['error'] != null) {
             throw Exception('Failed to get lyrics from LrcLib: ${dataMap['error']}');
           } else if (dataMap.containsKey('id')) { // Assuming 'id' means it's a valid lyrics object
             return LyricsModel.fromJson(dataMap);
           } else {
             throw Exception('Unexpected response format from LrcLib (Map without error or id).');
           }
        }
        else {
          // If the response is not a list or a map, or is an unexpected format
          throw Exception('Unexpected response format from LrcLib. Data: ${response.data}');
        }
      } else if (response.statusCode == 404) {
        // LrcLib might return 404 if no track is found at all.
        throw Exception('No lyrics found for this song on LrcLib (404 Not Found).');
      }
      else {
        throw Exception('Failed to get lyrics from LrcLib: Status ${response.statusCode}, Data: ${response.data}');
      }
    } on DioException catch (e) {
      String errorMessage = 'Failed to get lyrics from LrcLib (DioError): ${e.message}';
      if (e.response != null) {
        errorMessage += '\nResponse Data: ${e.response?.data}';
        errorMessage += '\nStatus Code: ${e.response?.statusCode}';
      }
      if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout || e.type == DioExceptionType.sendTimeout){
        errorMessage = 'Network timeout when fetching lyrics. Please check your connection.';
      }
      if (e.type == DioExceptionType.unknown && e.error is SocketException) {
         errorMessage = 'Network error. Could not connect to LrcLib.';
      }
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('Failed to get lyrics from LrcLib: $e');
    }
  }
}
