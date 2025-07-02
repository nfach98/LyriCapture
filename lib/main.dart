import 'package:flutter/material.dart';
import 'package:lyricapture/presentation/app.dart';
import 'package:provider/provider.dart';
import 'package:lyricapture/presentation/providers/search_provider.dart';
import 'package:lyricapture/presentation/providers/lyrics_provider.dart';
import 'package:lyricapture/injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => getIt<SearchProvider>(),
        ),
        ChangeNotifierProvider(
          create: (_) => getIt<LyricsProvider>(),
        ),
      ],
      child: const App(),
    ),
  );
}
