import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:rmnevents/data/remote_data_source/faq_data_source.dart';

import '../../imports/common.dart';
import '../../imports/data.dart';
import '../models/response_models/faq_response_model.dart';

class FaqRepository {
  static Future<Either<Failure, FaqResponseModel>> getFaqs(
  ) async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await FAQDataSource.getFaqs();

        Map<String, dynamic> responseJson = jsonDecode(response.body);

        FaqResponseModel faqResponseModel =
            FaqResponseModel.fromJson(responseJson);

        if (response.statusCode == 200) {
          if (faqResponseModel.status!) {
            return Right(faqResponseModel);
          } else {
            return Left(AppExceptions.handle(
                caughtFailure: Failure(
              code: response.statusCode,
              message:
                  AppStrings.global_error_string,
            )).failure);
          }
        } else {
          return Left(AppExceptions.handle(
              caughtFailure: Failure(
            code: response.statusCode,
            message:
                AppStrings.global_error_string,
          )).failure);
        }
      } catch (error) {
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
