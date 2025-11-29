import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../main.dart';

class BackgroundRemovalService {
  /// Remove background from image bytes
  /// Returns processed image bytes (PNG with transparent background)
  /// Throws exception if processing fails
  static Future<Uint8List> removeBackground(Uint8List imageBytes, String filename) async {
    try {
      final uri = Uri.parse('$rembgUrl/remove-bg');
      
      final request = http.MultipartRequest('POST', uri);
      request.files.add(http.MultipartFile.fromBytes(
        'image',
        imageBytes,
        filename: filename,
      ));
      
      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          throw Exception('Background removal timed out');
        },
      );
      
      if (streamedResponse.statusCode == 200) {
        final responseBytes = await streamedResponse.stream.toBytes();
        return responseBytes;
      } else {
        final body = await streamedResponse.stream.bytesToString();
        throw Exception('Background removal failed: $body');
      }
    } catch (e) {
      throw Exception('Background removal error: $e');
    }
  }
  
  /// Check if the background removal service is available
  static Future<bool> isServiceAvailable() async {
    try {
      final response = await http.get(
        Uri.parse('$rembgUrl/health'),
      ).timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}

