import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;

class ImageUtils {
  static Future<Uint8List> convertXFileToUint8List(XFile xFile) async {
    final bytes = await xFile.readAsBytes();
    return bytes;
  }
  
  static Future<img.Image?> convertXFileToImage(XFile xFile) async {
    final bytes = await xFile.readAsBytes();
    return img.decodeImage(bytes);
  }
  
  static Future<String> saveImageTemporarily(XFile xFile) async {
    final File file = File(xFile.path);
    return file.path;
  }
}
