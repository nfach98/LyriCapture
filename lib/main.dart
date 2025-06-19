// import 'package:dio/dio.dart'; // No longer directly needed here
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// import 'package:lyricapture/data/network/dio_client.dart'; // No longer needed
// import 'package:lyricapture/data/datasources/spotify_remote_data_source.dart'; // No longer needed
// import 'package:lyricapture/data/datasources/lrclib_remote_data_source.dart'; // No longer needed
// import 'package:lyricapture/data/repositories/spotify_repository_impl.dart'; // No longer needed
// import 'package:lyricapture/data/repositories/lyrics_repository_impl.dart'; // No longer needed
// Import ImageCaptureRepository if you were to implement its provider/usecase
// import 'package:lyricapture/data/repositories/image_capture_repository_impl.dart';


// import 'package:lyricapture/domain/usecases/get_spotify_token.dart'; // No longer needed
// import 'package:lyricapture/domain/usecases/search_song_on_spotify.dart'; // No longer needed
// import 'package:lyricapture/domain/usecases/get_lyrics_from_lrclib.dart'; // No longer needed
// Import CaptureLyricsToImage if you were to implement its provider/usecase
// import 'package:lyricapture/domain/usecases/capture_lyrics_to_image.dart';

import 'package:lyricapture/presentation/providers/song_search_provider.dart';
import 'package:lyricapture/presentation/providers/lyrics_provider.dart';
import 'package:lyricapture/presentation/navigation/app_router.dart'; // Import AppRouter
import 'package:lyricapture/injection.dart'; // Import DI setup

Future<void> main() async { // Make main async
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter bindings are initialized
  await configureDependencies(); // Call your DI setup

  // Manual instantiations removed, GetIt will handle them.

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => getIt<SongSearchProvider>(), // Get from GetIt
        ),
        ChangeNotifierProvider(
          create: (_) => getIt<LyricsProvider>(), // Get from GetIt
        ),
        // Provider for ImageCapture if implemented and made injectable
        // ChangeNotifierProvider(
        //   create: (_) => getIt<ImageCaptureProvider>(),
        // ),
      ],
      child: MaterialApp.router(
        title: 'Lyricapture',
        theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.blue,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routerConfig: AppRouter.router,
      ),
    ),
  );
}
