import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:lyricapture/domain/entities/lyrics.dart';
import 'package:lyricapture/domain/usecases/get_lyrics_from_lrclib.dart';
import 'package:lyricapture/domain/usecases/capture_lyrics_to_image.dart';
import 'package:screenshot/screenshot.dart';
import 'package:permission_handler/permission_handler.dart';

@injectable
class LyricsProvider extends ChangeNotifier {
  final GetLyricsFromLrclib _getLyricsFromLrclib;
  final CaptureLyricsToImage _captureLyricsToImage;

  final screenshotController = ScreenshotController();

  bool _isLoading = false;
  Lyrics? _lyrics;
  String? _error;
  final _selectedLineIndexes = <int>[];
  int? _backgroundColor;

  LyricsProvider({
    required GetLyricsFromLrclib getLyricsFromLrclib,
    required CaptureLyricsToImage captureLyricsToImage,
  })  : _getLyricsFromLrclib = getLyricsFromLrclib,
        _captureLyricsToImage = captureLyricsToImage;

  bool get isLoading => _isLoading;
  Lyrics? get lyrics => _lyrics;
  String? get error => _error;

  List<int> get selectedLineIndexes => _selectedLineIndexes;
  String get selectedLyricsText => _selectedLineIndexes.join('\n');

  int get backgroundColor => _backgroundColor ?? 0xFF000000;

  void toggleLyricLineSelection(int index) {
    final firstIndex = _selectedLineIndexes.firstOrNull ?? index + 1;
    final lastIndex = _selectedLineIndexes.lastOrNull ?? index - 1;

    if (_selectedLineIndexes.contains(index)) {
      if (firstIndex == index || lastIndex == index) {
        _selectedLineIndexes.remove(index);
      }
      /*  else {
        if (index > firstIndex) {
          _selectedLineIndexes.removeWhere((e) => e <= index);
        } else if (index < lastIndex) {
          _selectedLineIndexes.removeWhere((e) => e >= index);
        }
      } */
    } else {
      if (_selectedLineIndexes.isEmpty) {
        _selectedLineIndexes.add(index);
      } else {
        if (index < firstIndex) {
          _selectedLineIndexes
              .addAll(List.generate(firstIndex - index, (i) => index + i));
        } else if (index > lastIndex) {
          _selectedLineIndexes.addAll(
              List.generate(index - lastIndex, (i) => lastIndex + i + 1));
        }
      }
    }
    _selectedLineIndexes.sort((a, b) => a.compareTo(b));
    notifyListeners();
  }

  void clearSelectedLyrics() {
    _selectedLineIndexes.clear();
    notifyListeners();
  }

  void setBackgroundColor(int color) {
    _backgroundColor = color;
    notifyListeners();
  }

  Future<void> fetchLyrics({
    required String track,
    required String artist,
  }) async {
    if (_isLoading) return;

    clearSelectedLyrics();
    if (track.isEmpty || artist.isEmpty) {
      _error = 'Track name and artist name cannot be empty.';
      notifyListeners();
      return;
    }
    _isLoading = true;
    _lyrics = null;
    _error = null;
    notifyListeners();

    try {
      _lyrics = await _getLyricsFromLrclib.call(track, artist);
      if (_lyrics?.plainLyrics == null && _lyrics?.syncedLyrics == null) {
        _error = 'No lyrics content found for this track.';
        _lyrics = null;
      }
    } catch (e) {
      _error = 'Failed to fetch lyrics: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> captureAndSaveLyrics(
    String songTitle,
    String artistName,
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    PermissionStatus status;
    if (defaultTargetPlatform == TargetPlatform.android) {
      status = await Permission.storage.request();
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      status = await Permission.photos.request();
    } else {
      _error = 'Platform not supported for image saving.';
      _isLoading = false;
      notifyListeners();
      return null;
    }

    if (status.isGranted) {
      /* try {
        final Uint8List? imageBytes = await screenshotController.capture();

        if (imageBytes != null) {
          final fileName =
              '${songTitle.replaceAll(' ', '_').replaceAll(r'[^\w\s]+', '_')}_lyrics.png';
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
      } */
    } else {
      _error = 'Storage/Photos permission denied. Status: $status';
    }
    return null;
  }
}
