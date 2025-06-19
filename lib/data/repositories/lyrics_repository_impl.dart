import 'package:injectable/injectable.dart'; // Added injectable
import 'package:lyricapture/domain/entities/lyrics.dart';
import 'package:lyricapture/domain/repositories/lyrics_repository.dart';
import 'package:lyricapture/data/datasources/lrclib_remote_data_source.dart';

@LazySingleton(as: LyricsRepository) // Added annotation
class LyricsRepositoryImpl implements LyricsRepository {
  final LrcLibRemoteDataSource _remoteDataSource; // Changed to _remoteDataSource for convention

  // Constructor updated for DI
  LyricsRepositoryImpl({required LrcLibRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<Lyrics> getLyrics(String trackName, String artistName) async {
    // Using the field _remoteDataSource now
    final lyricsModel = await _remoteDataSource.getLyrics(trackName, artistName);
    return lyricsModel.toDomain();
  }
}
