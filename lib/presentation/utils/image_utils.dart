import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:universal_io/io.dart' as io;

class ImageUtils {
  static Future<List<int>> getImageBytes({required String imagePath}) async {
    final response = await http.get(Uri.parse(imagePath));
    if (kIsWeb) {
      return response.bodyBytes;
    } else {
      final tempPath = (await getTemporaryDirectory()).path;
      final file = io.File('${tempPath}_loaded');
      await file.writeAsBytes(
          response.bodyBytes.buffer.asUint8List(response.bodyBytes.offsetInBytes, response.bodyBytes.lengthInBytes));
      return file.readAsBytes();
    }
  }
}
