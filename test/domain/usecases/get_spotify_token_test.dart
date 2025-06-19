import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:lyricapture/domain/usecases/get_spotify_token.dart';
import 'package:lyricapture/domain/entities/spotify_token.dart';
import '../../mocks.mocks.dart'; // Adjust path if mocks.mocks.dart is elsewhere

void main() {
  late GetSpotifyToken usecase;
  late MockSpotifyRepository mockSpotifyRepository;

  setUp(() {
    mockSpotifyRepository = MockSpotifyRepository();
    usecase = GetSpotifyToken(mockSpotifyRepository); // Pass mock in constructor
  });

  final tSpotifyToken = SpotifyToken(accessToken: 'test_token', tokenType: 'Bearer', expiresIn: 3600);

  test('should get spotify token from the repository', () async {
    // Arrange
    when(mockSpotifyRepository.getToken()).thenAnswer((_) async => tSpotifyToken);
    // Act
    final result = await usecase.call(); // No repository argument in call()
    // Assert
    expect(result, tSpotifyToken);
    verify(mockSpotifyRepository.getToken());
    verifyNoMoreInteractions(mockSpotifyRepository);
  });
}
