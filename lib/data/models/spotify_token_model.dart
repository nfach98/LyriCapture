import 'package:lyricapture/domain/entities/spotify_token.dart';

class SpotifyTokenModel {
  final String accessToken;
  final String tokenType;
  final int expiresIn;

  SpotifyTokenModel({
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
  });

  factory SpotifyTokenModel.fromJson(Map<String, dynamic> json) {
    return SpotifyTokenModel(
      accessToken: json['access_token'],
      tokenType: json['token_type'],
      expiresIn: json['expires_in'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'token_type': tokenType,
      'expires_in': expiresIn,
    };
  }

  SpotifyToken toDomain() {
    return SpotifyToken(
      accessToken: accessToken,
      tokenType: tokenType,
      expiresIn: expiresIn,
    );
  }
}
