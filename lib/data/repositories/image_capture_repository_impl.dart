import 'dart:typed_data';
import 'package:injectable/injectable.dart';
import 'package:share_plus/share_plus.dart';
import 'package:lyricapture/domain/repositories/image_capture_repository.dart';

@LazySingleton(as: ImageCaptureRepository)
class ImageCaptureRepositoryImpl implements ImageCaptureRepository {
  // @override
  // Future<String> saveCapturedImage(Uint8List imageBytes, String fileName) async {
  //   final result = await ImageGallerySaver.saveImage(
  //     imageBytes,
  //     name: fileName, // Use the provided filename
  //     quality: 95,
  //   );

  //   if (result != null && result['isSuccess'] == true && result['filePath'] != null) {
  //     String filePath = result['filePath'];
  //     // Remove 'file://' prefix for consistency if present
  //     if (filePath.startsWith('file://')) {
  //       filePath = filePath.substring(7);
  //     }
  //     return filePath;
  //   } else {
  //     throw Exception('Failed to save image to gallery. Result: $result');
  //   }
  // }

  @override
  Future<void> shareImage(String imagePath, String text) async {
    // Ensure the path is valid and accessible by share_plus
    // XFile is preferred by share_plus
    await Share.shareXFiles([XFile(imagePath)], text: text);
  }
}
