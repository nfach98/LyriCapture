import 'package:flutter/foundation.dart';

class SpotifyToken {
  final String accessToken;
  final String tokenType;
  final int expiresIn;

  SpotifyToken({
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
  });

  SpotifyToken copyWith({
    String? accessToken,
    String? tokenType,
    int? expiresIn,
  }) {
    return SpotifyToken(
      accessToken: accessToken ?? this.accessToken,
      tokenType: tokenType ?? this.tokenType,
      expiresIn: expiresIn ?? this.expiresIn,
    );
  }

  @override
  String toString() {
    return 'SpotifyToken(accessToken: $accessToken, tokenType: $tokenType, expiresIn: $expiresIn)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SpotifyToken &&
        other.accessToken == accessToken &&
        other.tokenType == tokenType &&
        other.expiresIn == expiresIn;
  }

  @override
  int get hashCode => accessToken.hashCode ^ tokenType.hashCode ^ expiresIn.hashCode;
}
