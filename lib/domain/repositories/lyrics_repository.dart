import 'package:lyricapture/domain/entities/lyrics.dart';

abstract class LyricsRepository {
  Future<Lyrics> getLyrics(String trackName, String artistName);
}
