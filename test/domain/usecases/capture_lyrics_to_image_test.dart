import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:lyricapture/domain/usecases/capture_lyrics_to_image.dart';
import '../../mocks.mocks.dart'; // Adjust path if needed

void main() {
  late CaptureLyricsToImage usecase;
  late MockImageCaptureRepository mockImageCaptureRepository;

  setUp(() {
    mockImageCaptureRepository = MockImageCaptureRepository();
    usecase = CaptureLyricsToImage(mockImageCaptureRepository);
  });

  final tImageBytes = Uint8List.fromList([1, 2, 3]);
  const tFileName = 'test_lyrics.png';
  const tSavedPath = '/path/to/test_lyrics.png';
  const tShareText = 'Shared lyrics';

  group('saveImage', () {
    test('should call saveCapturedImage on the repository and return path', () async {
      // Arrange
      when(mockImageCaptureRepository.saveCapturedImage(tImageBytes, tFileName))
          .thenAnswer((_) async => tSavedPath);
      // Act
      final result = await usecase.saveImage(tImageBytes, tFileName);
      // Assert
      expect(result, tSavedPath);
      verify(mockImageCaptureRepository.saveCapturedImage(tImageBytes, tFileName));
      verifyNoMoreInteractions(mockImageCaptureRepository);
    });
  });

  group('shareImage', () {
    test('should call shareImage on the repository', () async {
      // Arrange
      when(mockImageCaptureRepository.shareImage(tSavedPath, tShareText))
          .thenAnswer((_) async => Future.value()); // Returns Future<void>
      // Act
      await usecase.shareImage(tSavedPath, tShareText);
      // Assert
      verify(mockImageCaptureRepository.shareImage(tSavedPath, tShareText));
      verifyNoMoreInteractions(mockImageCaptureRepository);
    });
  });
}
