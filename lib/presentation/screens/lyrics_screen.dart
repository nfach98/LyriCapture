import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:lyricapture/domain/entities/song.dart';
import 'package:lyricapture/presentation/arguments/capture_argument.dart';
import 'package:lyricapture/presentation/navigation/app_router.dart';
import 'package:lyricapture/presentation/providers/lyrics_provider.dart';
import 'package:lyricapture/utils/color_extension.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:provider/provider.dart';

class LyricsScreen extends StatefulWidget {
  final Song song;

  const LyricsScreen({super.key, required this.song});

  @override
  State<LyricsScreen> createState() => _LyricsScreenState();
}

class _LyricsScreenState extends State<LyricsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getLyrics();
      _getBackgroundColor();
    });
  }

  _getLyrics() {
    context.read<LyricsProvider>().fetchLyrics(
          track: widget.song.name,
          artist: widget.song.artistName,
        );
  }

  Future<void> _getBackgroundColor() async {
    final palette = await PaletteGenerator.fromImageProvider(
      CachedNetworkImageProvider(widget.song.albumArtUrl ?? ''),
      targets: [PaletteTarget.darkVibrant],
    );

    final colors = palette.selectedSwatches.values.map((e) => e.color).toList();
    if (colors.isNotEmpty && mounted) {
      context.read<LyricsProvider>().setBackgroundColor(colors.first.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final song = widget.song;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              song.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleSmall,
            ),
            Text(
              song.artistName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Consumer<LyricsProvider>(
              builder: (_, provider, __) {
                if (provider.isLoading && provider.lyrics == null) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (provider.error != null && provider.lyrics == null) {
                  return Center(
                    child: Text('Error: ${provider.error}'),
                  );
                }
                if (provider.lyrics == null ||
                    (provider.lyrics?.plainLyrics == null &&
                        provider.lyrics?.syncedLyrics == null)) {
                  return const Center(
                    child: Text('No lyrics available for this song.'),
                  );
                }

                final lyricsContent = provider.lyrics?.plainLyrics ??
                    provider.lyrics?.syncedLyrics;
                if (lyricsContent == null || lyricsContent.trim().isEmpty) {
                  return const Center(child: Text('Lyrics content is empty.'));
                }

                final lines = lyricsContent.split('\n');
                lines.removeWhere((line) => line.trim().isEmpty);
                final selectedLineIndexes = provider.selectedLineIndexes;
                final firstSelected = selectedLineIndexes.firstOrNull ?? -1;
                final lastSelected = selectedLineIndexes.lastOrNull ?? -1;

                final backgroundColor = Color(provider.backgroundColor);
                final backgroundLuminance = backgroundColor.luminance;
                final foregroundColor =
                    backgroundLuminance > 0.5 ? Colors.black87 : Colors.white;

                final selectedColor =
                    backgroundLuminance > 0.5 ? Colors.black54 : Colors.white70;
                final selectedTextColor =
                    backgroundLuminance > 0.5 ? Colors.white : Colors.black87;

                return Column(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Stack(
                            children: [
                              /* Positioned.fill(
                                child: CachedNetworkImage(
                                  imageUrl: song.albumArtUrl ?? '',
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                  errorWidget: (_, __, ___) => Container(
                                    width: 40,
                                    height: 40,
                                    color: theme.colorScheme.surfaceContainer,
                                    child: const Center(
                                      child: Icon(Icons.music_note),
                                    ),
                                  ),
                                ),
                              ), */
                              Positioned.fill(
                                child: Container(color: backgroundColor),
                              ),
                              /* Positioned.fill(
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: 6,
                                    sigmaY: 6,
                                  ),
                                  child: Container(
                                    color: Colors.black.withOpacity(.16),
                                  ),
                                ),
                              ), */
                              Positioned.fill(
                                child: ListView.builder(
                                  padding: const EdgeInsets.fromLTRB(
                                    16,
                                    10,
                                    16,
                                    64,
                                  ),
                                  itemCount: lines.length,
                                  itemBuilder: (_, index) {
                                    final isSelected =
                                        selectedLineIndexes.contains(index);

                                    return InkWell(
                                      onTap: () {
                                        provider.toggleLyricLineSelection(
                                          index,
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 6,
                                          horizontal: 10,
                                        ),
                                        decoration: BoxDecoration(
                                            color: isSelected
                                                ? selectedColor
                                                : null,
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(
                                                index == firstSelected ? 16 : 0,
                                              ),
                                              bottom: Radius.circular(
                                                index == lastSelected ? 16 : 0,
                                              ),
                                            )),
                                        child: Text(
                                          lines[index],
                                          style: theme.textTheme.headlineSmall
                                              ?.copyWith(
                                            color: isSelected
                                                ? selectedTextColor
                                                : foregroundColor,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              if (selectedLineIndexes.isNotEmpty)
                                Positioned(
                                  left: 0,
                                  right: 0,
                                  bottom: 0,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      children: [
                                        ElevatedButton.icon(
                                          onPressed: () {
                                            context
                                                .read<LyricsProvider>()
                                                .clearSelectedLyrics();
                                          },
                                          label: const Icon(Icons.replay),
                                        ),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: ElevatedButton.icon(
                                            onPressed: () {
                                              final selectedLines = <String>[];
                                              for (var i = 0;
                                                  i < lines.length;
                                                  i++) {
                                                if (selectedLineIndexes
                                                    .contains(i)) {
                                                  selectedLines.add(lines[i]);
                                                }
                                              }

                                              context.pushNamed(
                                                AppRouter.capture,
                                                extra: CaptureArgument(
                                                  song: song,
                                                  lyrics: selectedLines,
                                                  backgroundColor:
                                                      backgroundColor,
                                                ),
                                              );
                                            },
                                            icon: const Icon(Icons.camera_alt),
                                            label: const Text('Capture'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
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
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
