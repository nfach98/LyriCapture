import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lyricapture/domain/entities/song.dart';
import 'package:lyricapture/presentation/arguments/capture_argument.dart';
import 'package:lyricapture/presentation/screens/capture_screen.dart';
import 'package:lyricapture/presentation/screens/search_screen.dart';
import 'package:lyricapture/presentation/screens/lyrics_screen.dart';

class AppRouter {
  static const search = 'search';
  static const lyrics = 'lyrics';
  static const capture = 'capture';

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        name: search,
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        path: '/lyrics',
        name: lyrics,
        builder: (context, state) {
          if (state.extra is Song) {
            final song = state.extra as Song;
            return LyricsScreen(song: song);
          } else {
            return Scaffold(
              appBar: AppBar(title: const Text('Error')),
              body: const Center(
                child: Text('Error: Song data not provided correctly.'),
              ),
            );
          }
        },
      ),
      GoRoute(
        path: '/capture',
        name: capture,
        builder: (context, state) {
          if (state.extra is CaptureArgument) {
            final args = state.extra as CaptureArgument;
            return CaptureScreen(args: args);
          } else {
            return Scaffold(
              appBar: AppBar(title: const Text('Error')),
              body: const Center(
                child: Text('Error: Song data not provided correctly.'),
              ),
            );
          }
        },
      ),
    ],
    // Optional: Add error handling for routes
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: Center(
          child: Text('Error: ${state.error?.message ?? 'Page not found.'}')),
    ),
  );
}
