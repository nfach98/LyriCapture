import 'dart:typed_data'; // Required for Uint8List
import 'package:injectable/injectable.dart';
import 'package:lyricapture/domain/repositories/image_capture_repository.dart';

@lazySingleton
class CaptureLyricsToImage {
  final ImageCaptureRepository _repository;

  CaptureLyricsToImage(this._repository);

  // Method to save the image, returns the file path
  // Future<String> saveImage(Uint8List imageBytes, String fileName) {
  //   return _repository.saveCapturedImage(imageBytes, fileName);
  // }

  // Method to share the image
  Future<void> shareImage(String imagePath, String text) {
    return _repository.shareImage(imagePath, text);
  }
}
