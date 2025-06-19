import 'package:lyricapture/domain/entities/lyrics.dart';
import 'package:lyricapture/domain/repositories/lyrics_repository.dart';

class GetLyricsFromLrclib {
  Future<Lyrics> call(LyricsRepository repository, String trackName, String artistName) {
    return repository.getLyrics(trackName, artistName);
  }
}
