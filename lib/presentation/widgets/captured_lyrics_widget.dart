import 'package:flutter/material.dart';

class CapturedLyricsWidget extends StatelessWidget {
  final String lyrics;
  final String songTitle;
  final String artistName;

  const CapturedLyricsWidget({
    super.key, // Standard key parameter
    required this.lyrics,
    required this.songTitle,
    required this.artistName,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      // Ensure this widget is built within a context that provides Material theming,
      // or wrap with a specific Material widget if it might be used standalone in a non-Material app part.
      // Since this will be used within a MaterialApp screen, it should be fine.
      color: Colors.transparent, // Make Material widget transparent if Container handles color
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.grey[900], // Dark background
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: Colors.blueAccent, width: 2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Important for screenshot of content
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              songTitle,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Roboto'), // Example font
            ),
            const SizedBox(height: 8),
            Text(
              artistName,
              style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic, color: Colors.grey[400], fontFamily: 'Roboto'),
            ),
            const SizedBox(height: 15),
            Text(
              lyrics,
              style: const TextStyle(fontSize: 16, color: Colors.white, height: 1.5, fontFamily: 'Roboto'),
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
    );
  }
}
