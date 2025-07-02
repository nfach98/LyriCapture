// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import 'data/datasources/lrclib_remote_data_source.dart' as _i446;
import 'data/datasources/spotify_remote_data_source.dart' as _i744;
import 'data/network/dio_client.dart' as _i989;
import 'data/network/dio_module.dart' as _i491;
import 'data/repositories/image_capture_repository_impl.dart' as _i899;
import 'data/repositories/lyrics_repository_impl.dart' as _i682;
import 'data/repositories/spotify_repository_impl.dart' as _i1052;
import 'domain/repositories/image_capture_repository.dart' as _i517;
import 'domain/repositories/lyrics_repository.dart' as _i730;
import 'domain/repositories/spotify_repository.dart' as _i69;
import 'domain/usecases/capture_lyrics_to_image.dart' as _i1005;
import 'domain/usecases/get_lyrics_from_lrclib.dart' as _i219;
import 'domain/usecases/get_spotify_token.dart' as _i799;
import 'domain/usecases/search_song_on_spotify.dart' as _i608;
import 'presentation/providers/lyrics_provider.dart' as _i480;
import 'presentation/providers/search_provider.dart' as _i527;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt $initGetIt(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  final dioModule = _$DioModule();
  gh.lazySingleton<_i989.DioClient>(() => dioModule.dioClient);
  gh.lazySingleton<_i517.ImageCaptureRepository>(
      () => _i899.ImageCaptureRepositoryImpl());
  gh.lazySingleton<_i361.Dio>(() => dioModule.dio(gh<_i989.DioClient>()));
  gh.lazySingleton<_i446.LrcLibRemoteDataSource>(
      () => _i446.LrcLibRemoteDataSourceImpl(dio: gh<_i361.Dio>()));
  gh.lazySingleton<_i1005.CaptureLyricsToImage>(
      () => _i1005.CaptureLyricsToImage(gh<_i517.ImageCaptureRepository>()));
  gh.lazySingleton<_i730.LyricsRepository>(() => _i682.LyricsRepositoryImpl(
      remoteDataSource: gh<_i446.LrcLibRemoteDataSource>()));
  gh.lazySingleton<_i219.GetLyricsFromLrclib>(
      () => _i219.GetLyricsFromLrclib(gh<_i730.LyricsRepository>()));
  gh.lazySingleton<_i744.SpotifyRemoteDataSource>(
      () => _i744.SpotifyRemoteDataSourceImpl(dio: gh<_i361.Dio>()));
  gh.factory<_i480.LyricsProvider>(() => _i480.LyricsProvider(
        getLyricsFromLrclib: gh<_i219.GetLyricsFromLrclib>(),
        captureLyricsToImage: gh<_i1005.CaptureLyricsToImage>(),
      ));
  gh.lazySingleton<_i69.SpotifyRepository>(() => _i1052.SpotifyRepositoryImpl(
      remoteDataSource: gh<_i744.SpotifyRemoteDataSource>()));
  gh.lazySingleton<_i608.SearchSongOnSpotify>(
      () => _i608.SearchSongOnSpotify(gh<_i69.SpotifyRepository>()));
  gh.lazySingleton<_i799.GetSpotifyToken>(
      () => _i799.GetSpotifyToken(gh<_i69.SpotifyRepository>()));
  gh.factory<_i527.SearchProvider>(() => _i527.SearchProvider(
        getSpotifyToken: gh<_i799.GetSpotifyToken>(),
        searchSongOnSpotify: gh<_i608.SearchSongOnSpotify>(),
      ));
  return getIt;
}

class _$DioModule extends _i491.DioModule {}
