import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lyricapture/domain/entities/song.dart';
import 'package:lyricapture/presentation/screens/search_screen.dart';
import 'package:lyricapture/presentation/screens/lyrics_screen.dart';

class AppRouter {
  static const search = 'search';
  static const lyrics = 'lyrics';

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        name: search,
        builder: (BuildContext context, GoRouterState state) {
          return const SongSearchScreen();
        },
      ),
      GoRoute(
        path: '/lyrics',
        name: lyrics,
        builder: (BuildContext context, GoRouterState state) {
          // Retrieve the Song object passed as 'extra'
          // Make sure to handle the case where extra might not be a Song or is null,
          // though for this specific navigation, we expect it.
          if (state.extra is Song) {
            final Song song = state.extra as Song;
            return LyricsScreen(song: song);
          } else {
            // Handle error or return a fallback widget if 'extra' is not a Song.
            // This could be navigating back or showing an error message.
            // For now, let's assume 'extra' will always be a valid Song object when navigating to this route.
            // Or, provide a sensible default or error screen.
            return Scaffold(
              appBar: AppBar(title: const Text('Error')),
              body: const Center(
                  child: Text('Error: Song data not provided correctly.')),
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
