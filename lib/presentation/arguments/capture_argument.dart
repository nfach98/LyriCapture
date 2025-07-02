import 'package:flutter/material.dart';
import 'package:lyricapture/domain/entities/song.dart';

class CaptureArgument {
  final Song song;
  final List<String> lyrics;
  final Color backgroundColor;

  CaptureArgument({
    required this.song,
    required this.lyrics,
    required this.backgroundColor,
  });
}
