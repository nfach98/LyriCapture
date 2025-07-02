import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lyricapture/presentation/navigation/app_router.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.light,
    );

    var textTheme = GoogleFonts.interTextTheme();
    textTheme = textTheme.copyWith(
      bodySmall: textTheme.bodySmall?.copyWith(
        color: colorScheme.onSurface,
      ),
      bodyMedium: textTheme.bodyMedium?.copyWith(
        color: colorScheme.onSurface,
      ),
      bodyLarge: textTheme.bodyLarge?.copyWith(
        color: colorScheme.onSurface,
      ),
      titleSmall: textTheme.titleSmall?.copyWith(
        color: colorScheme.onSurface,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: textTheme.titleMedium?.copyWith(
        color: colorScheme.onSurface,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: textTheme.titleLarge?.copyWith(
        color: colorScheme.onSurface,
        fontWeight: FontWeight.bold,
      ),
      headlineSmall: textTheme.headlineSmall?.copyWith(
        color: colorScheme.onSurface,
        fontWeight: FontWeight.bold,
      ),
    );

    return MaterialApp.router(
      title: 'LyriCapture',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        colorScheme: colorScheme,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: textTheme,
        appBarTheme: AppBarTheme(
          centerTitle: true,
          titleTextStyle: textTheme.titleMedium,
        ),
        inputDecorationTheme: InputDecorationTheme(
          fillColor: colorScheme.surfaceContainer,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          hintStyle: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant.withOpacity(0.4),
          ),
          isDense: true,
        ),
      ),
      routerConfig: AppRouter.router,
    );
  }
}
