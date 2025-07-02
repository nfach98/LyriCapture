import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lyricapture/presentation/arguments/capture_argument.dart';
import 'package:lyricapture/utils/color_extension.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

class CaptureScreen extends StatefulWidget {
  const CaptureScreen({
    super.key,
    required this.args,
  });

  final CaptureArgument args;

  @override
  State<CaptureScreen> createState() => _CaptureScreenState();
}

class _CaptureScreenState extends State<CaptureScreen> {
  final _screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final backgroundColor = widget.args.backgroundColor;
    final foregroundColor =
        backgroundColor.luminance > 0.5 ? Colors.black87 : Colors.white;

    final song = widget.args.song;
    final lyrics = widget.args.lyrics;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Capture Lyrics'),
      ),
      body: Center(
        child: AspectRatio(
          aspectRatio: 1,
          child: Screenshot(
            controller: _screenshotController,
            child: Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: widget.args.backgroundColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CachedNetworkImage(
                        imageUrl: song.albumArtUrl ?? '',
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) => Container(
                          width: 48,
                          height: 48,
                          color: theme.colorScheme.surfaceContainer,
                          child: const Center(
                            child: Icon(Icons.music_note),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              song.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: foregroundColor,
                              ),
                            ),
                            Text(
                              song.artistName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: foregroundColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: lyrics.length,
                      itemBuilder: (_, index) {
                        return Text(
                          lyrics[index],
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: foregroundColor,
                          ),
                        );
                      },
                    ),
                  ),
                  Image.asset(
                    'assets/images/spotify.png',
                    height: 24,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: FilledButton.icon(
          onPressed: () async {
            final capture = await _screenshotController.capture();
            if (capture?.isNotEmpty ?? false) {
              var directory = Directory('');
              if (Platform.isAndroid) {
                directory = Directory('/storage/emulated/0/Download');
              } else {
                directory = await getApplicationDocumentsDirectory();
              }

              final exPath = directory.path;
              await Directory(exPath).create(recursive: true);

              final file = File(
                '$exPath/${DateTime.now().toIso8601String()}.png',
              );
              await file.writeAsBytes(capture?.toList() ?? []);
            }
          },
          icon: const Icon(Icons.save_alt),
          label: const Text('Save'),
        ),
      ),
    );
  }
}
