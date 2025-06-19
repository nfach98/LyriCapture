import 'package:dio/dio.dart'; // Import Dio
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:http/http.dart' as http; // No longer needed

import 'package:lyricapture/data/network/dio_client.dart'; // Import DioClient
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
  // Initialize DioClient
  final DioClient dioClient = DioClient();
  final Dio dioInstance = dioClient.dio; // Get the Dio instance

  // Data Layer Instances
  final spotifyRemoteDataSource =
      SpotifyRemoteDataSourceImpl(dio: dioInstance); // Pass Dio instance
  final lrcLibRemoteDataSource =
      LrcLibRemoteDataSourceImpl(dio: dioInstance); // Pass Dio instance
  // final imageCaptureLocalDataSource = ImageCaptureLocalDataSourceImpl(); // Example if it existed

  final spotifyRepository =
      SpotifyRepositoryImpl(remoteDataSource: spotifyRemoteDataSource);
  final lyricsRepository =
      LyricsRepositoryImpl(remoteDataSource: lrcLibRemoteDataSource);
  // final imageCaptureRepository = ImageCaptureRepositoryImpl(localDataSource: imageCaptureLocalDataSource); // Example

  // Domain Layer Instances (Use Cases)
  // These are typically simple classes, so direct instantiation is fine.
  // For more complex scenarios, a dependency injection solution might be used for use cases too.
  final getSpotifyTokenUseCase = GetSpotifyToken();
  final searchSongOnSpotifyUseCase = SearchSongOnSpotify();
  final getLyricsFromLrclibUseCase = GetLyricsFromLrclib();
  // final captureLyricsToImageUseCase = CaptureLyricsToImage(); // Example

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SongSearchProvider(
            getSpotifyToken: getSpotifyTokenUseCase,
            searchSongOnSpotify: searchSongOnSpotifyUseCase,
            spotifyRepository: spotifyRepository,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => LyricsProvider(
            getLyricsFromLrclib: getLyricsFromLrclibUseCase,
            lyricsRepository: lyricsRepository,
            // imageCaptureRepository: imageCaptureRepository, // Example
            // captureLyricsToImage: captureLyricsToImageUseCase, // Example
          ),
        ),
        // Provider for ImageCapture if implemented
        // ChangeNotifierProvider(
        //   create: (_) => ImageCaptureProvider(
        //     captureLyricsToImage: captureLyricsToImageUseCase,
        //     imageCaptureRepository: imageCaptureRepository,
        //   ),
        // ),
      ],
      child: MaterialApp.router(
        title: 'Lyricapture',
        theme: ThemeData(
          // Using a more common dark theme setup
          brightness: Brightness.dark,
          primarySwatch: Colors
              .blue, // This might not have a big effect with brightness: Brightness.dark
          // Consider using colorScheme for more detailed dark theme customization
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue, brightness: Brightness.dark),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routerConfig: AppRouter.router, // Use routerConfig
      ),
    ),
  );
}
