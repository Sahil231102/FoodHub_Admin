import 'dart:typed_data';
import 'package:flutter_image_compress/flutter_image_compress.dart'
    as compress_lib;

class ImageCompressorUtil {
  // Static method for image compression
  static Future<Uint8List?> compressImage(Uint8List fileBytes) async {
    int quality = 85; // Local variable since we're in a static method

    try {
      Uint8List? compressedBytes =
          await compress_lib.FlutterImageCompress.compressWithList(
        fileBytes,
        minWidth: 800,
        minHeight: 800,
        quality: quality,
      );

      // Ensure the compressed image is under 800KB
      while (compressedBytes != null &&
          compressedBytes.lengthInBytes > 800 * 1024 &&
          quality > 20) {
        quality = (quality * 0.9).toInt(); // Reduce quality gradually
        compressedBytes =
            await compress_lib.FlutterImageCompress.compressWithList(
          fileBytes,
          minWidth: 800,
          minHeight: 800,
          quality: quality,
        );
      }
      return compressedBytes;
    } catch (e) {
      print("Image compression error: $e");
      return null;
    }
  }
}
