import 'dart:typed_data'; // Required for Uint8List

abstract class ImageCaptureRepository {
  // Changed to accept image bytes and a filename
  Future<String> saveCapturedImage(Uint8List imageBytes, String fileName);

  // Added a method for sharing
  Future<void> shareImage(String imagePath, String text);
}
