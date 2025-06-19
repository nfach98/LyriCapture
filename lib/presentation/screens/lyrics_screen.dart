import 'package:flutter/material.dart';
import 'package:lyricapture/domain/entities/song.dart';
import 'package:lyricapture/presentation/providers/lyrics_provider.dart';
import 'package:lyricapture/presentation/widgets/captured_lyrics_widget.dart';
import 'package:provider/provider.dart';

class LyricsScreen extends StatefulWidget {
  final Song song;

  const LyricsScreen({super.key, required this.song});

  @override
  State<LyricsScreen> createState() => _LyricsScreenState();
}

class _LyricsScreenState extends State<LyricsScreen> {
  // GlobalKey for the Screenshot widget is not needed here if
  // the ScreenshotController is instance-level in the Provider.
  // final GlobalKey _lyricsCaptureKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // Fetch lyrics when the screen is initialized
    // Ensure context is available and mounted before trying to read provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<LyricsProvider>(context, listen: false)
            .fetchLyrics(widget.song.name, widget.song.artistName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.song.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.song.name,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              widget.song.artistName,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (widget.song.albumName.isNotEmpty)
              Text(
                widget.song.albumName,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            const SizedBox(height: 20),
            Expanded(
              child: Consumer<LyricsProvider>(
                builder: (context, lyricsProvider, child) {
                  if (lyricsProvider.isLoading &&
                      lyricsProvider.lyrics == null) {
                    // Show loading only if lyrics are not yet loaded
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (lyricsProvider.error != null &&
                      lyricsProvider.lyrics == null) {
                    // Show error only if lyrics are not yet loaded
                    return Center(
                        child: Text('Error: ${lyricsProvider.error}'));
                  }
                  if (lyricsProvider.lyrics == null ||
                      (lyricsProvider.lyrics?.plainLyrics == null &&
                          lyricsProvider.lyrics?.syncedLyrics == null)) {
                    return const Center(
                        child: Text('No lyrics available for this song.'));
                  }

                  final String? lyricsContent =
                      lyricsProvider.lyrics?.plainLyrics ??
                          lyricsProvider.lyrics?.syncedLyrics;
                  if (lyricsContent == null || lyricsContent.trim().isEmpty) {
                    return const Center(
                        child: Text('Lyrics content is empty.'));
                  }

                  final lines = lyricsContent.split('\n');

                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: lines.length,
                          itemBuilder: (context, index) {
                            final line = lines[index];
                            final isSelected = lyricsProvider
                                .selectedLyricsLines
                                .contains(line);
                            return InkWell(
                              onTap: () {
                                lyricsProvider.toggleLyricLineSelection(line);
                              },
                              child: Container(
                                color: isSelected
                                    ? Colors.blue.withOpacity(0.3)
                                    : Colors.transparent,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 16.0),
                                child: Text(
                                  line,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        backgroundColor: isSelected
                                            ? Colors.blue.withOpacity(0.1)
                                            : null,
                                      ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      // This Screenshot widget is for capturing the selected lyrics.
                      // It's always in the tree but only visible if there are selected lines.
                      // The actual content to be captured is defined by CapturedLyricsWidget.
                      /*  if (lyricsProvider.selectedLyricsLines.isNotEmpty)
                        Offstage( // Use Offstage to have it in the tree for capture but not visible until needed
                          offstage: true, // This should ideally be false when capturing, or simply remove it for capture
                                          // For simplicity, we'll have it in the tree, capture will grab it.
                                          // A better way for "invisible capture" is to build it on demand before capture.
                                          // But for this subtask, let's keep it simple.
                          child: Screenshot(
                            controller: lyricsProvider.screenshotController,
                            child: CapturedLyricsWidget(
                              lyrics: lyricsProvider.selectedLyricsText,
                              songTitle: widget.song.name,
                              artistName: widget.song.artistName,
                            ),
                          ),
                        ), */
                      if (lyricsProvider.selectedLyricsLines.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: lyricsProvider.isLoading
                                ? null
                                : () async {
                                    // Disable button when loading
                                    if (lyricsProvider
                                        .selectedLyricsLines.isNotEmpty) {
                                      final successPath = await lyricsProvider
                                          .captureAndSaveLyrics(
                                        widget.song.name,
                                        widget.song.artistName,
                                      );
                                      if (mounted) {
                                        // Check if the widget is still in the tree
                                        if (successPath != null) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    'Lyrics captured and shared! Saved at $successPath')),
                                          );
                                        } else if (lyricsProvider.error !=
                                            null) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    'Error: ${lyricsProvider.error}')),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    'Capture/Save failed for an unknown reason.')),
                                          );
                                        }
                                      }
                                    }
                                  },
                            child: lyricsProvider.isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2, color: Colors.white))
                                : const Text('Capture Selected Lyrics'),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
