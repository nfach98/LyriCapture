import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:lyricapture/data/repositories/spotify_repository_impl.dart';
import 'package:lyricapture/data/models/spotify_token_model.dart';
import 'package:lyricapture/domain/entities/spotify_token.dart';
import '../../mocks.mocks.dart'; // Adjust path

// These constants should match those in spotify_repository_impl.dart
const String expectedClientId = 'YOUR_SPOTIFY_CLIENT_ID';
const String expectedClientSecret = 'YOUR_SPOTIFY_CLIENT_SECRET';

void main() {
  late SpotifyRepositoryImpl repository;
  late MockSpotifyRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockSpotifyRemoteDataSource();
    // When instantiating SpotifyRepositoryImpl, it doesn't take clientId/secret in constructor
    // It uses constants defined within its own file.
    repository = SpotifyRepositoryImpl(remoteDataSource: mockRemoteDataSource);
  });

  group('getToken', () {
    final tSpotifyTokenModel = SpotifyTokenModel(accessToken: 'test_token', tokenType: 'Bearer', expiresIn: 3600);
    // Ensure your SpotifyTokenModel.toDomain() correctly maps to SpotifyToken
    final SpotifyToken tSpotifyToken = tSpotifyTokenModel.toDomain();

    test('should return SpotifyToken when the call to remote data source is successful', () async {
      // Arrange
      // The getToken method in the data source is called with the constants from SpotifyRepositoryImpl
      when(mockRemoteDataSource.getToken(expectedClientId, expectedClientSecret))
          .thenAnswer((_) async => tSpotifyTokenModel);
      // Act
      final result = await repository.getToken();
      // Assert
      // Verify that the data source's getToken was called with the correct (hardcoded) credentials
      verify(mockRemoteDataSource.getToken(expectedClientId, expectedClientSecret));
      expect(result, equals(tSpotifyToken));
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test('should throw an exception when the call to remote data source is unsuccessful', () async {
      // Arrange
      when(mockRemoteDataSource.getToken(expectedClientId, expectedClientSecret))
          .thenThrow(Exception('API Error'));
      // Act
      final call = repository.getToken;
      // Assert
      expect(() => call(), throwsA(isA<Exception>()));
      verify(mockRemoteDataSource.getToken(expectedClientId, expectedClientSecret));
      verifyNoMoreInteractions(mockRemoteDataSource);
    });
  });

  // TODO: Add tests for searchSongs if time permits
  // group('searchSongs', () {
  //   // Define SongModel, Song entity, etc.
  //   // Test success and failure cases similar to getToken
  // });
}
