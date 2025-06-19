import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart'; // Not strictly needed in this file, but often in actual tests
import 'package:lyricapture/domain/repositories/spotify_repository.dart';
import 'package:lyricapture/domain/repositories/lyrics_repository.dart';
import 'package:lyricapture/domain/repositories/image_capture_repository.dart';
import 'package:lyricapture/data/datasources/spotify_remote_data_source.dart';
import 'package:lyricapture/data/datasources/lrclib_remote_data_source.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:lyricapture/domain/usecases/get_spotify_token.dart';
import 'package:lyricapture/domain/usecases/search_song_on_spotify.dart';
import 'package:lyricapture/domain/usecases/get_lyrics_from_lrclib.dart';
import 'package:lyricapture/domain/usecases/capture_lyrics_to_image.dart';

@GenerateMocks([
  SpotifyRepository,
  LyricsRepository,
  ImageCaptureRepository,
  SpotifyRemoteDataSource,
  LrcLibRemoteDataSource,
  http.Client,
  Dio,
  GetSpotifyToken,
  SearchSongOnSpotify,
  GetLyricsFromLrclib,
  CaptureLyricsToImage,
])
void main() {} // Dummy main to trigger build_runner
