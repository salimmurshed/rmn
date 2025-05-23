import '../request_models/event_purchase_request_model.dart';

class QuestionnaireResponseModel {
  QuestionnaireResponseModel({
    this.status,
    this.responseData,
  });

  QuestionnaireResponseModel.fromJson(dynamic json) {
    status = json['status'];
    responseData = json['responseData'] != null
        ? QuestionnaireResponseData.fromJson(json['responseData'])
        : null;
  }

  bool? status;
  QuestionnaireResponseData? responseData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (responseData != null) {
      map['responseData'] = responseData?.toJson();
    }
    return map;
  }
}

class QuestionnaireResponseData {
  QuestionnaireResponseData({
    this.data,
  });

  QuestionnaireResponseData.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(QuestionnaireData.fromJson(v));
      });
    }
  }

  List<QuestionnaireData>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class QuestionnaireData {
  QuestionnaireData({
    this.eventId,
    this.options,
    this.isMandatory,
    this.id,
    this.answerType,
    this.createdAt,
    this.question,
    this.storedAnswer,
    this.updatedAt,
  });

  QuestionnaireData.fromJson(dynamic json) {
    eventId = json['event_id'];
    options = json['options'] != null ? json['options'].cast<String>() : [];
    isMandatory = json['is_mandatory'];
    id = json['_id'];
    answerType = json['answer_type'];
    createdAt = json['createdAt'];
    question = json['question'];
    updatedAt = json['updatedAt'];
    storedAnswer = json['stored_answer'] != null
        ? Questionnaire.fromJson(json['stored_answer'])
        : null;
  }

  String? eventId;
  List<String>? options;
  bool? isMandatory;
  String? id;
  String? answerType;
  String? createdAt;
  String? question;
  String? updatedAt;
  Questionnaire? storedAnswer;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['event_id'] = eventId;
    map['options'] = options;
    map['stored_answer'] = storedAnswer?.toJson();
    map['is_mandatory'] = isMandatory;
    map['_id'] = id;
    map['answer_type'] = answerType;
    map['createdAt'] = createdAt;
    map['question'] = question;
    map['updatedAt'] = updatedAt;
    return map;
  }
}
