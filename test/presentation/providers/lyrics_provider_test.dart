import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:lyricapture/presentation/providers/lyrics_provider.dart';
import 'package:lyricapture/domain/usecases/get_lyrics_from_lrclib.dart';
import 'package:lyricapture/domain/entities/lyrics.dart';
import '../../mocks.mocks.dart';

void main() {
  late LyricsProvider provider;
  late MockLyricsRepository mockLyricsRepository;
  late GetLyricsFromLrclib getLyricsFromLrclib;

  setUp(() {
    mockLyricsRepository = MockLyricsRepository();
    // The use case is instantiated directly, it will call the mocked repository
    getLyricsFromLrclib = GetLyricsFromLrclib();

    provider = LyricsProvider(
      getLyricsFromLrclib: getLyricsFromLrclib,
      lyricsRepository: mockLyricsRepository,
    );
  });

  final tLyrics = Lyrics(
    id: '1',
    trackName: 'Test Song',
    artistName: 'Test Artist',
    albumName: 'Test Album',
    plainLyrics: 'Hello world',
    syncedLyrics: null, // Or some test data
  );

  test('initial state is correct', () {
    expect(provider.isLoading, false);
    expect(provider.lyrics, null);
    expect(provider.error, null);
    expect(provider.selectedLyricsLines.isEmpty, true);
  });

  group('fetchLyrics', () {
    test('should get lyrics using the use case and repository', () async {
      // Arrange
      when(mockLyricsRepository.getLyrics('Test Song', 'Test Artist'))
          .thenAnswer((_) async => tLyrics);

      // Act
      await provider.fetchLyrics('Test Song', 'Test Artist');

      // Assert
      expect(provider.lyrics, tLyrics);
      expect(provider.isLoading, false);
      expect(provider.error, null);
      // Verify that the repository's getLyrics method was called via the use case
      verify(mockLyricsRepository.getLyrics('Test Song', 'Test Artist')).called(1);
      verifyNoMoreInteractions(mockLyricsRepository);
    });

    test('should set error when use case (via repository) fails', () async {
      // Arrange
      when(mockLyricsRepository.getLyrics('Test Song', 'Test Artist'))
          .thenThrow(Exception('Failed to fetch lyrics'));

      // Act
      await provider.fetchLyrics('Test Song', 'Test Artist');

      // Assert
      expect(provider.lyrics, null);
      expect(provider.isLoading, false);
      expect(provider.error, isNotNull);
      expect(provider.error, 'Failed to fetch lyrics: Exception: Failed to fetch lyrics');
      verify(mockLyricsRepository.getLyrics('Test Song', 'Test Artist')).called(1);
      verifyNoMoreInteractions(mockLyricsRepository);
    });

     test('should clear selected lyrics when fetching new lyrics', () async {
      // Arrange
      provider.toggleLyricLineSelection("some old selected line");
      expect(provider.selectedLyricsLines.isNotEmpty, true);
      when(mockLyricsRepository.getLyrics(any, any)).thenAnswer((_) async => tLyrics);

      // Act
      await provider.fetchLyrics('New Song', 'New Artist');

      // Assert
      expect(provider.selectedLyricsLines.isEmpty, true);
    });
  });

  group('toggleLyricLineSelection', () {
    const testLine = "This is a test line";
    test('should add line to selectedLyricsLines if not present', () {
      // Act
      provider.toggleLyricLineSelection(testLine);
      // Assert
      expect(provider.selectedLyricsLines.contains(testLine), true);
    });

    test('should remove line from selectedLyricsLines if present', () {
      // Arrange
      provider.toggleLyricLineSelection(testLine); // Add it first
      // Act
      provider.toggleLyricLineSelection(testLine); // Then remove it
      // Assert
      expect(provider.selectedLyricsLines.contains(testLine), false);
    });
  });

  test('selectedLyricsText getter should join selected lines with newline', () {
    // Arrange
    const line1 = "First line";
    const line2 = "Second line";
    provider.toggleLyricLineSelection(line1);
    provider.toggleLyricLineSelection(line2);
    // Act
    final text = provider.selectedLyricsText;
    // Assert
    // The order might vary based on Set implementation, so check for contains
    expect(text.contains(line1), true);
    expect(text.contains(line2), true);
    expect(text.contains('\n'), true);
  });

  // TODO: Tests for captureAndSaveLyrics would require mocking ScreenshotController, ImageGallerySaver, Share, PermissionHandler
  // This is more complex and might be better suited for integration tests or more involved unit tests.
}
