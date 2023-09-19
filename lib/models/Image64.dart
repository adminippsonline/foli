import 'dart:convert';
import 'dart:typed_data';

// ignore: unused_import
import 'package:flutter/cupertino.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

class Image64 {
  String resourceName;
  String? imageEncoded;
  XFile? cachedFile;
  Image64(this.resourceName, this.cachedFile);
  codeBase64() async {
    if (cachedFile != null) {
      List<int> imageBytes = [];

      await testComporessList(await cachedFile!.readAsBytes())
          .then((bytes) async {
        if (bytes == null) {
          imageBytes = await cachedFile!.readAsBytes();
        } else {
          imageBytes = bytes;
        }
      });
      imageEncoded = base64Encode(imageBytes);
    }
  }

  Future<Uint8List?> testComporessList(Uint8List list) async {
    var result = await FlutterImageCompress.compressWithList(
      list,
      minHeight: 1920,
      minWidth: 1080,
      quality: 50,
    );
    return result;
  }

  Future<List<int>?> testCompressAndGetFile(
      XFile? file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file!.path,
      targetPath,
      minHeight: 1000,
      minWidth: 1000,
      quality: 50,
    ).catchError((_) {});
    return result?.readAsBytes();
  }
}
