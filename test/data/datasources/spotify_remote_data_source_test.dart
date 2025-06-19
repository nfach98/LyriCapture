import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:lyricapture/data/datasources/spotify_remote_data_source.dart';
import 'package:lyricapture/data/models/spotify_token_model.dart';
// import 'package:lyricapture/data/models/song_model.dart'; // Uncomment if testing searchSongs
import '../../mocks.mocks.dart';
import 'dart:convert'; // For base64Encode

void main() {
  late SpotifyRemoteDataSourceImpl dataSource;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    dataSource = SpotifyRemoteDataSourceImpl(dio: mockDio);
  });

  group('getToken', () {
    final tSpotifyTokenModel = SpotifyTokenModel(accessToken: 'test_token', tokenType: 'Bearer', expiresIn: 3600);
    // These should match the constants if they are defined and used in the data source,
    // but getToken in the data source takes clientId and clientSecret as parameters.
    const clientId = 'YOUR_SPOTIFY_CLIENT_ID';
    const clientSecret = 'YOUR_SPOTIFY_CLIENT_SECRET';
    final String basicAuth = 'Basic ${base64Encode(utf8.encode('$clientId:$clientSecret'))}';

    test('should perform a POST request to the correct URL with correct headers and data', () async {
      // Arrange
      when(mockDio.post(
        any,
        data: anyNamed('data'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
        requestOptions: RequestOptions(path: 'https://accounts.spotify.com/api/token'),
        data: {'access_token': 'test_token', 'token_type': 'Bearer', 'expires_in': 3600},
        statusCode: 200,
      ));

      // Act
      await dataSource.getToken(clientId, clientSecret);

      // Assert
      verify(mockDio.post(
        'https://accounts.spotify.com/api/token',
        data: {'grant_type': 'client_credentials'},
        options: Options(
          headers: {
            'Authorization': basicAuth,
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
      ));
    });

    test('should return SpotifyTokenModel when the response code is 200 (success)', () async {
      // Arrange
      when(mockDio.post(any, data: anyNamed('data'), options: anyNamed('options')))
          .thenAnswer((_) async => Response(
                        requestOptions: RequestOptions(path: 'https://accounts.spotify.com/api/token'),
                        data: {'access_token': 'test_token', 'token_type': 'Bearer', 'expires_in': 3600},
                        statusCode: 200,
                      ));
      // Act
      final result = await dataSource.getToken(clientId, clientSecret);
      // Assert
      expect(result, equals(tSpotifyTokenModel));
    });

    test('should throw an Exception when the response code is not 200', () async {
      // Arrange
      when(mockDio.post(any, data: anyNamed('data'), options: anyNamed('options')))
          .thenAnswer((_) async => Response(
                        requestOptions: RequestOptions(path: 'https://accounts.spotify.com/api/token'),
                        data: 'Not Found',
                        statusCode: 404,
                      ));
      // Act
      final call = dataSource.getToken;
      // Assert
      expect(() => call(clientId, clientSecret), throwsA(isA<Exception>()));
    });

    test('should throw an Exception on DioException', () async {
      // Arrange
      when(mockDio.post(any, data: anyNamed('data'), options: anyNamed('options')))
          .thenThrow(DioException(
              requestOptions: RequestOptions(path: 'https://accounts.spotify.com/api/token'),
              message: 'Connection timeout'
            ));
      // Act
      final call = dataSource.getToken;
      // Assert
      expect(() => call(clientId, clientSecret), throwsA(isA<Exception>()));
    });
  });

  // TODO: Add tests for searchSongs
  // group('searchSongs', () {
  //   final tSongModelList = [SongModel(...)]; // replace with actual model
  //   const query = "test query";
  //   const token = "test_token";
  //   test('should perform a GET request to search songs', () async {
  //     // Arrange
  //     when(mockDio.get(any, queryParameters: anyNamed('queryParameters'), options: anyNamed('options')))
  //         .thenAnswer((_) async => Response(
  //                       requestOptions: RequestOptions(path: 'https://api.spotify.com/v1/search'),
  //                       data: {'tracks': {'items': [/* mock song item json */]}},
  //                       statusCode: 200));
  //     // Act
  //     await dataSource.searchSongs(query, token);
  //     // Assert
  //     verify(mockDio.get(
  //       'https://api.spotify.com/v1/search',
  //       queryParameters: {'q': query, 'type': 'track', 'limit': 20},
  //       options: Options(headers: {'Authorization': 'Bearer $token'}),
  //     ));
  //   });
  // });
}
