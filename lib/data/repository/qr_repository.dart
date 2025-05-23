import 'dart:convert';

import 'package:dartz/dartz.dart';

import '../../imports/common.dart';
import '../../imports/data.dart';

class QRRepository {
  static Future<Either<Failure, QrIdScannedResponseModel>> postOrGetQRID(
      {required String id, required bool isPost}) async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await QRDataSource.postOrGetQRID(id: id, isPost: isPost);

        Map<String, dynamic> responseJson = jsonDecode(response.body);

        QrIdScannedResponseModel qrScannedResponseModel =
            QrIdScannedResponseModel.fromJson(responseJson);

        if (response.statusCode == 200) {
          if (qrScannedResponseModel.status!) {
            return Right(qrScannedResponseModel);
          } else {
            return Left(AppExceptions.handle(
                caughtFailure: Failure(
              code: response.statusCode,
              message: qrScannedResponseModel.responseData?.message ??
                  AppStrings.global_error_string,
            )).failure);
          }
        } else {
          return Left(AppExceptions.handle(
              caughtFailure: Failure(
            code: response.statusCode,
            message: AppStrings.global_error_string,
          )).failure);
        }
      } catch (e) {
        return Left(AppExceptions.handle(
          caughtFailure: Failure(
            code: ResponseCode.DEFAULT,
            message: extractErrorMessage(e),
          ),
        ).failure);
      }
    } else {
      return Left(AppExceptions.handle(
              caughtFailure: Failure(code: ResponseCode.NO_INTERNET_CONNECTION))
          .failure);
    }
  }
}
