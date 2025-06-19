import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:lyricapture/presentation/providers/lyrics_provider.dart';
import 'package:lyricapture/domain/usecases/get_lyrics_from_lrclib.dart';
import 'package:lyricapture/domain/usecases/capture_lyrics_to_image.dart'; // Import new use case
import 'package:lyricapture/domain/entities/lyrics.dart';
import '../../mocks.mocks.dart'; // Should contain MockGetLyricsFromLrclib and MockCaptureLyricsToImage

void main() {
  late LyricsProvider provider;
  late MockGetLyricsFromLrclib mockGetLyricsFromLrclib; // Mock the use case
  late MockCaptureLyricsToImage mockCaptureLyricsToImage; // Mock the use case
  // MockLyricsRepository not directly needed if use cases are mocked

  setUp(() {
    mockGetLyricsFromLrclib = MockGetLyricsFromLrclib();
    mockCaptureLyricsToImage = MockCaptureLyricsToImage();

    provider = LyricsProvider(
      getLyricsFromLrclib: mockGetLyricsFromLrclib, // Pass mocked use case
      captureLyricsToImage: mockCaptureLyricsToImage, // Pass mocked use case
      // lyricsRepository: mockLyricsRepository, // Removed
    );
  });

  final tLyrics = Lyrics(
    id: '1',
    trackName: 'Test Song',
    artistName: 'Test Artist',
    albumName: 'Test Album',
    plainLyrics: 'Hello world',
    syncedLyrics: null,
  );

  const tTrackName = 'Test Song';
  const tArtistName = 'Test Artist';

  test('initial state is correct', () {
    expect(provider.isLoading, false);
    expect(provider.lyrics, null);
    expect(provider.error, null);
    expect(provider.selectedLyricsLines.isEmpty, true);
  });

  group('fetchLyrics', () {
    test('should get lyrics using the GetLyricsFromLrclib use case', () async {
      // Arrange
      when(mockGetLyricsFromLrclib.call(tTrackName, tArtistName))
          .thenAnswer((_) async => tLyrics);

      // Act
      await provider.fetchLyrics(tTrackName, tArtistName);

      // Assert
      expect(provider.lyrics, tLyrics);
      expect(provider.isLoading, false);
      expect(provider.error, null);
      verify(mockGetLyricsFromLrclib.call(tTrackName, tArtistName)).called(1);
      verifyNoMoreInteractions(mockGetLyricsFromLrclib);
    });

    test('should set error when GetLyricsFromLrclib use case fails', () async {
      // Arrange
      when(mockGetLyricsFromLrclib.call(tTrackName, tArtistName))
          .thenThrow(Exception('Failed to fetch lyrics'));

      // Act
      await provider.fetchLyrics(tTrackName, tArtistName);

      // Assert
      expect(provider.lyrics, null);
      expect(provider.isLoading, false);
      expect(provider.error, isNotNull);
      expect(provider.error, 'Failed to fetch lyrics: Exception: Failed to fetch lyrics');
      verify(mockGetLyricsFromLrclib.call(tTrackName, tArtistName)).called(1);
      verifyNoMoreInteractions(mockGetLyricsFromLrclib);
    });

     test('should clear selected lyrics when fetching new lyrics', () async {
      // Arrange
      provider.toggleLyricLineSelection("some old selected line");
      expect(provider.selectedLyricsLines.isNotEmpty, true);
      when(mockGetLyricsFromLrclib.call(any, any)).thenAnswer((_) async => tLyrics);

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
