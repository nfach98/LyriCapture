import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:lyricapture/domain/usecases/search_song_on_spotify.dart';
import 'package:lyricapture/domain/entities/song.dart';
import '../../mocks.mocks.dart'; // Adjust path if needed

void main() {
  late SearchSongOnSpotify usecase;
  late MockSpotifyRepository mockSpotifyRepository;

  setUp(() {
    mockSpotifyRepository = MockSpotifyRepository();
    usecase = SearchSongOnSpotify(mockSpotifyRepository);
  });

  const tQuery = 'test query';
  const tToken = 'test_token';
  final tSongList = [
    Song(id: '1', name: 'Song 1', artistName: 'Artist 1', albumName: 'Album 1', albumArtUrl: null),
    Song(id: '2', name: 'Song 2', artistName: 'Artist 2', albumName: 'Album 2', albumArtUrl: null),
  ];

  test('should search songs from the repository', () async {
    // Arrange
    when(mockSpotifyRepository.searchSongs(tQuery, tToken))
        .thenAnswer((_) async => tSongList);
    // Act
    final result = await usecase.call(tQuery, tToken);
    // Assert
    expect(result, tSongList);
    verify(mockSpotifyRepository.searchSongs(tQuery, tToken));
    verifyNoMoreInteractions(mockSpotifyRepository);
  });
}
