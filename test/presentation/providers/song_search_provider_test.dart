import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:lyricapture/presentation/providers/song_search_provider.dart';
import 'package:lyricapture/domain/usecases/get_spotify_token.dart';
import 'package:lyricapture/domain/usecases/search_song_on_spotify.dart';
import 'package:lyricapture/domain/entities/song.dart';
import 'package:lyricapture/domain/entities/spotify_token.dart';
import '../../mocks.mocks.dart';

void main() {
  late SongSearchProvider provider;
  late MockSpotifyRepository mockSpotifyRepository;
  late GetSpotifyToken getSpotifyTokenUseCase;
  late SearchSongOnSpotify searchSongOnSpotifyUseCase;

  setUp(() {
    mockSpotifyRepository = MockSpotifyRepository();
    getSpotifyTokenUseCase = GetSpotifyToken(); // Real use case, calls mocked repo
    searchSongOnSpotifyUseCase = SearchSongOnSpotify(); // Real use case, calls mocked repo

    provider = SongSearchProvider(
      getSpotifyToken: getSpotifyTokenUseCase,
      searchSongOnSpotify: searchSongOnSpotifyUseCase,
      spotifyRepository: mockSpotifyRepository,
    );
  });

  final tSpotifyToken = SpotifyToken(accessToken: 'test_token', tokenType: 'Bearer', expiresIn: 3600);
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
    test('should get token and search songs when token is not available', () async {
      // Arrange
      when(mockSpotifyRepository.getToken()).thenAnswer((_) async => tSpotifyToken);
      when(mockSpotifyRepository.searchSongs(tQuery, tSpotifyToken.accessToken))
          .thenAnswer((_) async => tSongList);

      // Act
      await provider.search(tQuery);

      // Assert
      expect(provider.songs, tSongList);
      expect(provider.isLoading, false);
      expect(provider.error, null);
      verify(mockSpotifyRepository.getToken()).called(1);
      verify(mockSpotifyRepository.searchSongs(tQuery, tSpotifyToken.accessToken)).called(1);
      verifyNoMoreInteractions(mockSpotifyRepository);
    });

    test('should use existing token if available and not expired', () async {
      // Arrange
      // First search to get and store the token
      when(mockSpotifyRepository.getToken()).thenAnswer((_) async => tSpotifyToken);
      when(mockSpotifyRepository.searchSongs(tQuery, tSpotifyToken.accessToken))
          .thenAnswer((_) async => tSongList);
      await provider.search(tQuery); // This will fetch and store the token

      // Reset interactions for the second call verification
      clearInteractions(mockSpotifyRepository);
      // Re-stub searchSongs for the second call if necessary, assuming token is now stored
      when(mockSpotifyRepository.searchSongs(tQuery, tSpotifyToken.accessToken))
          .thenAnswer((_) async => tSongList);


      // Act: search again
      await provider.search(tQuery);

      // Assert
      expect(provider.songs, tSongList);
      expect(provider.isLoading, false);
      // getToken should not be called again if the token is considered valid
      verifyNever(mockSpotifyRepository.getToken());
      verify(mockSpotifyRepository.searchSongs(tQuery, tSpotifyToken.accessToken)).called(1);
      verifyNoMoreInteractions(mockSpotifyRepository);
    });


    test('should set error when getToken fails', () async {
      // Arrange
      when(mockSpotifyRepository.getToken()).thenThrow(Exception('Failed to get token'));

      // Act
      await provider.search(tQuery);

      // Assert
      expect(provider.songs.isEmpty, true);
      expect(provider.isLoading, false);
      expect(provider.error, isNotNull);
      expect(provider.error, contains('Failed to get token'));
      verify(mockSpotifyRepository.getToken()).called(1);
      verifyNever(mockSpotifyRepository.searchSongs(any, any));
      verifyNoMoreInteractions(mockSpotifyRepository);
    });

    test('should set error when searchSongs fails', () async {
      // Arrange
      when(mockSpotifyRepository.getToken()).thenAnswer((_) async => tSpotifyToken);
      when(mockSpotifyRepository.searchSongs(tQuery, tSpotifyToken.accessToken))
          .thenThrow(Exception('Search failed'));

      // Act
      await provider.search(tQuery);

      // Assert
      expect(provider.songs.isEmpty, true);
      expect(provider.isLoading, false);
      expect(provider.error, isNotNull);
      expect(provider.error, contains('Search failed'));
      verify(mockSpotifyRepository.getToken()).called(1);
      verify(mockSpotifyRepository.searchSongs(tQuery, tSpotifyToken.accessToken)).called(1);
      verifyNoMoreInteractions(mockSpotifyRepository);
    });

    test('should clear songs and error when query is empty', () async {
      // Arrange: Populate with some data first
      when(mockSpotifyRepository.getToken()).thenAnswer((_) async => tSpotifyToken);
      when(mockSpotifyRepository.searchSongs(tQuery, tSpotifyToken.accessToken))
          .thenAnswer((_) async => tSongList);
      await provider.search(tQuery);
      expect(provider.songs.isNotEmpty, true); // Ensure songs are populated

      // Act
      await provider.search(''); // Search with empty query

      // Assert
      expect(provider.songs.isEmpty, true);
      expect(provider.error, null);
      expect(provider.isLoading, false); // Should not be loading for an empty query
      verifyNever(mockSpotifyRepository.getToken()); // Should not attempt to get token
      verifyNever(mockSpotifyRepository.searchSongs(any,any)); // Should not attempt to search
    });
  });
}
