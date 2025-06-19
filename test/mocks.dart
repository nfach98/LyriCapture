import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart'; // Not strictly needed in this file, but often in actual tests
import 'package:lyricapture/domain/repositories/spotify_repository.dart';
import 'package:lyricapture/domain/repositories/lyrics_repository.dart';
import 'package:lyricapture/domain/repositories/image_capture_repository.dart';
import 'package:lyricapture/data/datasources/spotify_remote_data_source.dart';
import 'package:lyricapture/data/datasources/lrclib_remote_data_source.dart';
import 'package:http/http.dart' as http; // Still needed if http.Client was mocked for other things
import 'package:dio/dio.dart'; // Import Dio

@GenerateMocks([
  SpotifyRepository,
  LyricsRepository,
  ImageCaptureRepository,
  SpotifyRemoteDataSource,
  LrcLibRemoteDataSource,
  http.Client, // Keep if it's used by other test mocks not being updated now
  Dio, // Add Dio
])
void main() {} // Dummy main to trigger build_runner
