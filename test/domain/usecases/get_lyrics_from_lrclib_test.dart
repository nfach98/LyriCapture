import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:lyricapture/domain/usecases/get_lyrics_from_lrclib.dart';
import 'package:lyricapture/domain/entities/lyrics.dart';
import '../../mocks.mocks.dart'; // Adjust path if needed

void main() {
  late GetLyricsFromLrclib usecase;
  late MockLyricsRepository mockLyricsRepository;

  setUp(() {
    mockLyricsRepository = MockLyricsRepository();
    usecase = GetLyricsFromLrclib(mockLyricsRepository);
  });

  const tTrackName = 'Test Track';
  const tArtistName = 'Test Artist';
  final tLyrics = Lyrics(
    id: '123',
    trackName: tTrackName,
    artistName: tArtistName,
    albumName: 'Test Album',
    plainLyrics: 'Test lyrics content...',
    syncedLyrics: null,
  );

  test('should get lyrics from the repository', () async {
    // Arrange
    when(mockLyricsRepository.getLyrics(tTrackName, tArtistName))
        .thenAnswer((_) async => tLyrics);
    // Act
    final result = await usecase.call(tTrackName, tArtistName);
    // Assert
    expect(result, tLyrics);
    verify(mockLyricsRepository.getLyrics(tTrackName, tArtistName));
    verifyNoMoreInteractions(mockLyricsRepository);
  });
}
