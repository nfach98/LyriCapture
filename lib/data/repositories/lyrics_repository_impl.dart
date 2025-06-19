import 'package:lyricapture/domain/entities/lyrics.dart';
import 'package:lyricapture/domain/repositories/lyrics_repository.dart';
import 'package:lyricapture/data/datasources/lrclib_remote_data_source.dart';

class LyricsRepositoryImpl implements LyricsRepository {
  final LrcLibRemoteDataSource remoteDataSource;

  LyricsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Lyrics> getLyrics(String trackName, String artistName) async {
    final lyricsModel = await remoteDataSource.getLyrics(trackName, artistName);
    return lyricsModel.toDomain();
  }
}
