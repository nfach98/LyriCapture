import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'package:lyricapture/data/datasources/spotify_remote_data_source.dart';
import 'package:lyricapture/data/datasources/lrclib_remote_data_source.dart';
import 'package:lyricapture/data/repositories/spotify_repository_impl.dart';
import 'package:lyricapture/data/repositories/lyrics_repository_impl.dart';
// Import ImageCaptureRepository if you were to implement its provider/usecase
// import 'package:lyricapture/data/repositories/image_capture_repository_impl.dart';


import 'package:lyricapture/domain/usecases/get_spotify_token.dart';
import 'package:lyricapture/domain/usecases/search_song_on_spotify.dart';
import 'package:lyricapture/domain/usecases/get_lyrics_from_lrclib.dart';
// Import CaptureLyricsToImage if you were to implement its provider/usecase
// import 'package:lyricapture/domain/usecases/capture_lyrics_to_image.dart';

import 'package:lyricapture/presentation/providers/song_search_provider.dart';
import 'package:lyricapture/presentation/providers/lyrics_provider.dart';
// import 'package:lyricapture/presentation/screens/search_screen.dart'; // No longer needed for home
import 'package:lyricapture/presentation/navigation/app_router.dart'; // Import AppRouter

void main() {
  // Instantiate HTTP client
  final httpClient = http.Client();

  // Data Layer Instances
  final spotifyRemoteDataSource = SpotifyRemoteDataSourceImpl(client: httpClient);
  final lrcLibRemoteDataSource = LrcLibRemoteDataSourceImpl(client: httpClient);
  // final imageCaptureLocalDataSource = ImageCaptureLocalDataSourceImpl(); // Example if it existed

  final spotifyRepository = SpotifyRepositoryImpl(remoteDataSource: spotifyRemoteDataSource);
  final lyricsRepository = LyricsRepositoryImpl(remoteDataSource: lrcLibRemoteDataSource);
  // final imageCaptureRepository = ImageCaptureRepositoryImpl(localDataSource: imageCaptureLocalDataSource); // Example

  // Domain Layer Instances (Use Cases)
  final getSpotifyToken = GetSpotifyToken();
  final searchSongOnSpotify = SearchSongOnSpotify();
  final getLyricsFromLrclib = GetLyricsFromLrclib();
  // final captureLyricsToImage = CaptureLyricsToImage(); // Example

  runApp(
    MyApp(
      spotifyRepository: spotifyRepository,
      lyricsRepository: lyricsRepository,
      // imageCaptureRepository: imageCaptureRepository, // Example
      getSpotifyToken: getSpotifyToken,
      searchSongOnSpotify: searchSongOnSpotify,
      getLyricsFromLrclib: getLyricsFromLrclib,
      // captureLyricsToImage: captureLyricsToImage, // Example
    ),
  );
}

class MyApp extends StatelessWidget {
  final SpotifyRepositoryImpl spotifyRepository;
  final LyricsRepositoryImpl lyricsRepository;
  // final ImageCaptureRepositoryImpl imageCaptureRepository; // Example

  final GetSpotifyToken getSpotifyToken;
  final SearchSongOnSpotify searchSongOnSpotify;
  final GetLyricsFromLrclib getLyricsFromLrclib;
  // final CaptureLyricsToImage captureLyricsToImage; // Example

  const MyApp({
    super.key,
    required this.spotifyRepository,
    required this.lyricsRepository,
    // required this.imageCaptureRepository, // Example
    required this.getSpotifyToken,
    required this.searchSongOnSpotify,
    required this.getLyricsFromLrclib,
    // required this.captureLyricsToImage, // Example
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SongSearchProvider(
            getSpotifyToken: getSpotifyToken,
            searchSongOnSpotify: searchSongOnSpotify,
            spotifyRepository: spotifyRepository,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => LyricsProvider(
            getLyricsFromLrclib: getLyricsFromLrclib,
            lyricsRepository: lyricsRepository,
          ),
        ),
        // Provider for ImageCapture if implemented
        // ChangeNotifierProvider(
        //   create: (_) => ImageCaptureProvider(
        //     captureLyricsToImage: captureLyricsToImage,
        //     imageCaptureRepository: imageCaptureRepository,
        //   ),
        // ),
      ],
      child: MaterialApp.router(
        title: 'Lyricapture',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routerConfig: AppRouter.router, // Use routerConfig
      ),
    );
  }
}
