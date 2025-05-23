import 'dart:io';

import '../../imports/common.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'package:path/path.dart';

class MediaManager {
  static String? validateImageSize({required File file}) {
    final bytes = file.readAsBytesSync().lengthInBytes;
    final kb = bytes / 1024;
    final mb = kb / 1024;
    int mbRounded = mb.round();
    if (mbRounded > 5) {
      return AppStrings.image_uploadTooLargeFile_error;
    } else {
      return null;
    }
  }

  static Future<List<MultipartFile>> convertFileToMultipartFile(
      {required File file, required bool isAthleteProfile}) async {
    List<MultipartFile> multipartFiles = [];
    File imagesFile = file;
    var stream = http.ByteStream(DelegatingStream(imagesFile.openRead()));
    var length = await imagesFile.length();
    var multipartFile = isAthleteProfile
        ? http.MultipartFile("image", stream, length,
            filename: basename(imagesFile.path))
        : http.MultipartFile("profile_image", stream, length,
            filename: basename(imagesFile.path));
    multipartFiles.add(multipartFile);
    return multipartFiles;
  }
}
