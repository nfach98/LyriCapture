import 'package:injectable/injectable.dart';
import 'package:lyricapture/domain/entities/lyrics.dart';
import 'package:lyricapture/domain/repositories/lyrics_repository.dart';

@lazySingleton
class GetLyricsFromLrclib {
  final LyricsRepository _repository;

  GetLyricsFromLrclib(this._repository);

  Future<Lyrics> call(String trackName, String artistName) {
    return _repository.getLyrics(trackName, artistName);
  }
}
