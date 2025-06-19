import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:lyricapture/domain/entities/lyrics.dart';
import 'package:lyricapture/domain/usecases/get_lyrics_from_lrclib.dart';
import 'package:lyricapture/domain/usecases/capture_lyrics_to_image.dart';
import 'package:screenshot/screenshot.dart';
import 'package:permission_handler/permission_handler.dart';

@injectable // Added annotation
class LyricsProvider extends ChangeNotifier {
  final GetLyricsFromLrclib _getLyricsFromLrclib; // Changed to _
  final CaptureLyricsToImage _captureLyricsToImage;

  ScreenshotController screenshotController = ScreenshotController();

  bool _isLoading = false;
  Lyrics? _lyrics;
  String? _error;
  final Set<String> _selectedLyricsLines = {};

  LyricsProvider({
    required GetLyricsFromLrclib getLyricsFromLrclib, // Constructor updated
    required CaptureLyricsToImage captureLyricsToImage,
    // required LyricsRepository lyricsRepository, // Removed
  })  : _getLyricsFromLrclib = getLyricsFromLrclib,
        _captureLyricsToImage = captureLyricsToImage;
  // _lyricsRepository = lyricsRepository; // Removed

  bool get isLoading => _isLoading;
  Lyrics? get lyrics => _lyrics;
  String? get error => _error;
  Set<String> get selectedLyricsLines => _selectedLyricsLines;
  String get selectedLyricsText => _selectedLyricsLines.join('\n');

  void toggleLyricLineSelection(String line) {
    if (_selectedLyricsLines.contains(line)) {
      _selectedLyricsLines.remove(line);
    } else {
      _selectedLyricsLines.add(line);
    }
    notifyListeners();
  }

  void clearSelectedLyrics() {
    _selectedLyricsLines.clear();
    notifyListeners();
  }

  Future<void> fetchLyrics(String trackName, String artistName) async {
    clearSelectedLyrics();
    if (trackName.isEmpty || artistName.isEmpty) {
      _error = "Track name and artist name cannot be empty.";
      notifyListeners();
      return;
    }
    _isLoading = true;
    _lyrics = null;
    _error = null;
    notifyListeners();

    try {
      // Use case call doesn't need repository passed here anymore
      _lyrics = await _getLyricsFromLrclib.call(trackName, artistName);
      if (_lyrics?.plainLyrics == null && _lyrics?.syncedLyrics == null) {
        // If lyrics content is empty/null after successful fetch.
        _error = "No lyrics content found for this track.";
        _lyrics = null; // Ensure lyrics is null if content is not there
      }
    } catch (e) {
      _error = 'Failed to fetch lyrics: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> captureAndSaveLyrics(
      String songTitle, String artistName) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    PermissionStatus status;
    if (defaultTargetPlatform == TargetPlatform.android) {
      status = await Permission.storage.request();
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      status = await Permission.photos.request();
    } else {
      _error = "Platform not supported for image saving.";
      _isLoading = false;
      notifyListeners();
      return null;
    }

    if (status.isGranted) {
      try {
        final Uint8List? imageBytes = await screenshotController.capture();

        if (imageBytes != null) {
          final fileName =
              "${songTitle.replaceAll(' ', '_').replaceAll(r'[^\w\s]+', '_')}_lyrics.png";
          // Use the injected use case to save the image
          final String filePath =
              await _captureLyricsToImage.saveImage(imageBytes, fileName);

          // Use the injected use case to share the image
          await _captureLyricsToImage.shareImage(
              filePath, 'Lyrics for $songTitle by $artistName');

          _isLoading = false;
          notifyListeners();
          return filePath;
        } else {
          _error = 'Failed to capture lyrics image (imageBytes is null).';
        }
      } catch (e) {
        _error = 'Error during capture/save: $e';
      }
    } else {
      _error = 'Storage/Photos permission denied. Status: $status';
    }
    return null;
  }
}
