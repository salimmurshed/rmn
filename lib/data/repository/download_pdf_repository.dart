import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rmnevents/data/remote_data_source/download_pdfs_data_source.dart';
import 'package:open_file/open_file.dart' as Op;

import '../../imports/common.dart';
import '../../imports/data.dart';

class DownloadPdfRepository {
  static Future<Either<Failure, File>> downloadAndSavePdf(
      {required String url, required String fileName}) async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await DownloadPdfsDataSource.downloadAndSavePdf(
            fileName: fileName, url: url);


        var dir = await getApplicationDocumentsDirectory();
        var file = Platform.isIOS?  File("${dir.path}/$fileName.pdf") : File('/storage/emulated/0/Download/$fileName.pdf');
        await Permission.manageExternalStorage.request();
        File storedFiled = await file.writeAsBytes(response.bodyBytes);
        // RandomAccessFile storedFiled = file.openSync(mode: FileMode.write);
        // storedFiled.writeFromSync(response.bodyBytes);
        // await storedFiled.close();

        await Op.OpenFile.open(storedFiled.path);
        return Right(storedFiled);
      } catch (error) {
        print(error.toString());
        return Left(AppExceptions.handle(
            caughtFailure: Failure(
          code: ResponseCode.DEFAULT,
          message: extractErrorMessage(error),
        )).failure);
      }
    } else {
      return Left(AppExceptions.handle(
              caughtFailure: Failure(code: ResponseCode.NO_INTERNET_CONNECTION))
          .failure);
    }
  }
}
