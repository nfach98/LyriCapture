import 'package:flutter/foundation.dart';
import 'package:lyricapture/domain/entities/lyrics.dart';
import 'package:lyricapture/domain/usecases/get_lyrics_from_lrclib.dart';
import 'package:lyricapture/domain/repositories/lyrics_repository.dart';
// import 'package:screenshot/screenshot.dart';
// import 'package:share_plus/share_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class LyricsProvider extends ChangeNotifier {
  final GetLyricsFromLrclib getLyricsFromLrclib;
  final LyricsRepository lyricsRepository; // Needed to pass to use case
  // ScreenshotController screenshotController = ScreenshotController();

  bool _isLoading = false;
  Lyrics? _lyrics;
  String? _error;
  final Set<String> _selectedLyricsLines = {}; // New state variable

  LyricsProvider({
    required this.getLyricsFromLrclib,
    required this.lyricsRepository,
  });

  bool get isLoading => _isLoading;
  Lyrics? get lyrics => _lyrics;
  String? get error => _error;
  Set<String> get selectedLyricsLines =>
      _selectedLyricsLines; // Getter for selected lines
  String get selectedLyricsText =>
      _selectedLyricsLines.join('\n'); // Getter for combined text

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
    // Clear previous selections when fetching new lyrics
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
      final result = await getLyricsFromLrclib.call(
          lyricsRepository, trackName, artistName);
      if (result.plainLyrics == null && result.syncedLyrics == null) {
        _lyrics = null; // Explicitly set to null if no lyrics content
        _error = "No lyrics found for this track.";
      } else {
        _lyrics = result;
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
    // Checking platform at runtime can be tricky for permissions.
    // It's generally better to use a compile-time approach if possible,
    // but for permission_handler, this runtime check is common.
    // Consider that TargetPlatform might not be universally reliable for web vs mobile.
    // However, for storage/photos, it's usually fine.

    // Simplified permission request:
    // For Android, WRITE_EXTERNAL_STORAGE (for older SDKs) or manage media for newer.
    // For iOS, PHPhotoLibraryAddUsageDescription.
    // permission_handler usually abstracts this well.
    if (defaultTargetPlatform == TargetPlatform.android) {
      status = await Permission.storage.request();
      // For Android 13+ (API 33+), if targeting higher SDKs, READ_MEDIA_IMAGES might be needed
      // if ImageGallerySaver doesn't handle it. But typically storage permission is enough for saving.
      // If issues arise, specific media permissions might be needed.
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      status = await Permission.photos.request(); // Covers saving to gallery
    } else {
      // Handle other platforms or return error if not supported
      _error = "Platform not supported for image saving.";
      _isLoading = false;
      notifyListeners();
      return null;
    }

    /* if (status.isGranted) {
      try {
        // Capture the image from the Screenshot widget's child
        final Uint8List? imageBytes = await screenshotController.capture();

        if (imageBytes != null) {
          final result = await ImageGallerySaver.saveImage(
            imageBytes,
            name: "${songTitle.replaceAll(' ', '_').replaceAll(r'[^\w\s]+','_')}_lyrics.png", // Sanitize filename
            quality: 95,
          );

          if (result != null && result['isSuccess'] == true) {
            String? filePath = result['filePath'];
            if (filePath != null) {
              // Remove 'file://' prefix if present, for XFile compatibility for share_plus
              if (filePath.startsWith('file://')) {
                filePath = filePath.substring(7);
              }
              // Share the file using share_plus
              // Ensure the path is valid and accessible by share_plus
              await Share.shareXFiles([XFile(filePath)], text: 'Lyrics for $songTitle by $artistName');
              _isLoading = false;
              notifyListeners();
              return filePath;
            } else {
              _error = 'Failed to retrieve saved image path from gallery saver.';
            }
          } else {
            _error = 'Failed to save image to gallery. Result: $result';
          }
        } else {
          _error = 'Failed to capture lyrics image (imageBytes is null).';
        }
      } catch (e) {
        _error = 'Error during capture/save: $e';
      }
    } else {
      _error = 'Storage/Photos permission denied. Status: $status';
    } */

    _isLoading = false;
    notifyListeners();
    return null;
  }
}
