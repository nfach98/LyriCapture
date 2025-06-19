abstract class ImageCaptureRepository {
  Future<String> captureLyricsToImage(String lyricsText, {
    String? songTitle,
    String? artistName,
    // TODO: Add other styling parameters as needed
  });
}
