import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:rmnevents/data/remote_data_source/card_data_source.dart';

import '../../imports/common.dart';
import '../../imports/data.dart';

class CardRepository {
  static Future<Either<Failure, UploadedCardListResponseModel>>
      getCardList() async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await CardDataSource.getCardList();

        Map<String, dynamic> responseJson = jsonDecode(response.body);

        UploadedCardListResponseModel cardListResponseModel =
            UploadedCardListResponseModel.fromJson(responseJson);

        if (response.statusCode == 200) {
          if (cardListResponseModel.status!) {
            if (cardListResponseModel.responseData!.data!.isNotEmpty) {
              for (var element in cardListResponseModel.responseData!.data!) {
                element.isExisting = true;
                element.isSaved = false;
              }
            }
            return Right(cardListResponseModel);
          } else {
            return Left(AppExceptions.handle(
                    caughtFailure: Failure(
                        code: response.statusCode,
                        message: 'Encountered status: ${response.statusCode}'))
                .failure);
          }
        } else {
          return Left(AppExceptions.handle(
                  caughtFailure: Failure(
                      code: response.statusCode,
                      message: 'Encountered status: ${response.statusCode}'))
              .failure);
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
