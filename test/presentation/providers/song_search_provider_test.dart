import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:lyricapture/presentation/providers/search_provider.dart';
import 'package:lyricapture/domain/entities/song.dart';
import 'package:lyricapture/domain/entities/spotify_token.dart';
import '../../mocks.mocks.dart'; // Should now contain MockGetSpotifyToken etc.

void main() {
  late SearchProvider provider;
  late MockGetSpotifyToken mockGetSpotifyToken; // Mock the use case
  late MockSearchSongOnSpotify mockSearchSongOnSpotify; // Mock the use case
  // MockSpotifyRepository is no longer directly needed by the provider test if use cases are mocked

  setUp(() {
    mockGetSpotifyToken = MockGetSpotifyToken();
    mockSearchSongOnSpotify = MockSearchSongOnSpotify();

    provider = SearchProvider(
      getSpotifyToken: mockGetSpotifyToken, // Pass mocked use case
      searchSongOnSpotify: mockSearchSongOnSpotify, // Pass mocked use case
      // spotifyRepository: mockSpotifyRepository, // Removed
    );
  });

  final tSpotifyToken = SpotifyToken(
      accessToken: 'test_token', tokenType: 'Bearer', expiresIn: 3600);
  final tSongList = [
    Song(id: '1', name: 'Song 1', artistName: 'Artist 1', albumName: 'Album 1'),
    Song(id: '2', name: 'Song 2', artistName: 'Artist 2', albumName: 'Album 2'),
  ];
  const tQuery = 'test query';

  test('initial state is correct', () {
    expect(provider.isLoading, false);
    expect(provider.songs.isEmpty, true);
    expect(provider.error, null);
  });

  group('search', () {
    test('should get token and search songs when token is not available',
        () async {
      // Arrange
      when(mockGetSpotifyToken.call()).thenAnswer((_) async => tSpotifyToken);
      when(mockSearchSongOnSpotify.call(tQuery, tSpotifyToken.accessToken))
          .thenAnswer((_) async => tSongList);

      // Act
      await provider.search(tQuery);

      // Assert
      expect(provider.songs, tSongList);
      expect(provider.isLoading, false);
      expect(provider.error, null);
      verify(mockGetSpotifyToken.call()).called(1);
      verify(mockSearchSongOnSpotify.call(tQuery, tSpotifyToken.accessToken))
          .called(1);
      verifyNoMoreInteractions(mockGetSpotifyToken);
      verifyNoMoreInteractions(mockSearchSongOnSpotify);
    });

    test(
        'should use existing token if available and not expired (simplified expiry)',
        () async {
      // Arrange: First search to get and store the token
      when(mockGetSpotifyToken.call()).thenAnswer((_) async => tSpotifyToken);
      when(mockSearchSongOnSpotify.call(tQuery, tSpotifyToken.accessToken))
          .thenAnswer((_) async => tSongList);
      await provider.search(tQuery); // This will fetch and store the token

      // Reset interactions for the second call verification
      clearInteractions(mockGetSpotifyToken);
      clearInteractions(mockSearchSongOnSpotify);

      // Re-stub searchSongs for the second call, assuming token is now stored and valid
      when(mockSearchSongOnSpotify.call(tQuery, tSpotifyToken.accessToken))
          .thenAnswer((_) async => tSongList);

      // Act: search again
      await provider.search(tQuery);

      // Assert
      expect(provider.songs, tSongList);
      expect(provider.isLoading, false);
      // getToken use case should not be called again if the token is considered valid
      verifyNever(mockGetSpotifyToken.call());
      verify(mockSearchSongOnSpotify.call(tQuery, tSpotifyToken.accessToken))
          .called(1);
      verifyNoMoreInteractions(mockSearchSongOnSpotify);
    });

    test('should set error when getToken use case fails', () async {
      // Arrange
      when(mockGetSpotifyToken.call())
          .thenThrow(Exception('Failed to get token'));

      // Act
      await provider.search(tQuery);

      // Assert
      expect(provider.songs.isEmpty, true);
      expect(provider.isLoading, false);
      expect(provider.error, isNotNull);
      expect(provider.error, contains('Failed to get token'));
      verify(mockGetSpotifyToken.call()).called(1);
      verifyNever(mockSearchSongOnSpotify.call(any, any));
      verifyNoMoreInteractions(mockGetSpotifyToken);
    });

    test('should set error when searchSongs use case fails', () async {
      // Arrange
      when(mockGetSpotifyToken.call()).thenAnswer((_) async => tSpotifyToken);
      when(mockSearchSongOnSpotify.call(tQuery, tSpotifyToken.accessToken))
          .thenThrow(Exception('Search failed'));

      // Act
      await provider.search(tQuery);

      // Assert
      expect(provider.songs.isEmpty, true);
      expect(provider.isLoading, false);
      expect(provider.error, isNotNull);
      expect(provider.error, contains('Search failed'));
      verify(mockGetSpotifyToken.call()).called(1);
      verify(mockSearchSongOnSpotify.call(tQuery, tSpotifyToken.accessToken))
          .called(1);
      verifyNoMoreInteractions(mockGetSpotifyToken);
      verifyNoMoreInteractions(mockSearchSongOnSpotify);
    });

    test('should clear songs and error when query is empty', () async {
      // Arrange: Populate with some data first
      when(mockGetSpotifyToken.call()).thenAnswer((_) async => tSpotifyToken);
      when(mockSearchSongOnSpotify.call(tQuery, tSpotifyToken.accessToken))
          .thenAnswer((_) async => tSongList);
      await provider.search(tQuery);
      expect(provider.songs.isNotEmpty, true); // Ensure songs are populated

      clearInteractions(
          mockGetSpotifyToken); // Clear interactions before the empty search
      clearInteractions(mockSearchSongOnSpotify);

      // Act
      await provider.search(''); // Search with empty query

      // Assert
      expect(provider.songs.isEmpty, true);
      expect(provider.error, null);
      expect(provider.isLoading,
          false); // Should not be loading for an empty query
      verifyNever(
          mockGetSpotifyToken.call()); // Should not attempt to get token
      verifyNever(mockSearchSongOnSpotify.call(
          any, any)); // Should not attempt to search
    });
  });
}
