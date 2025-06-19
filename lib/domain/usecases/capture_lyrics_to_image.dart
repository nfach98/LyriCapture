import 'package:lyricapture/domain/repositories/image_capture_repository.dart';

class CaptureLyricsToImage {
  Future<String> call(ImageCaptureRepository repository, String lyricsText, {
    String? songTitle,
    String? artistName,
    // TODO: Add other styling parameters as needed
  }) {
    return repository.captureLyricsToImage(lyricsText, songTitle: songTitle, artistName: artistName);
  }
}
