import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:rmnevents/data/models/response_models/questionnaire_response_model.dart';
import 'package:rmnevents/data/remote_data_source/questionnaire_data_source.dart';

import '../../imports/common.dart';
import '../../imports/data.dart';

class QuestionnaireRepository{
  static Future<Either<Failure, QuestionnaireResponseModel>>
  getQuestionnaire({required String eventId}) async {
    if (await RepositoryDependencies.httpConnectionInfo.isConnected) {
      dynamic response;
      try {
        response = await QuestionnaireDataSource.getQuestionnaire(eventId: eventId);

        Map<String, dynamic> responseJson = jsonDecode(response.body);

        QuestionnaireResponseModel qModel =
        QuestionnaireResponseModel.fromJson(responseJson);

        if (response.statusCode == 200) {
          if (qModel.status!) {
            return Right(qModel);
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
      return Left(AppExceptions
          .handle(
          caughtFailure: Failure(code: ResponseCode.NO_INTERNET_CONNECTION))
          .failure);
    }
  }
}