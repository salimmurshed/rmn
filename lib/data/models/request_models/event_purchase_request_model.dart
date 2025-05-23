import 'package:flutter/cupertino.dart';

class RegisterEventRequestModel {
  RegisterEventRequestModel({
    this.coupon,
    this.cardToken,
    this.saveCard,
    this.existing,
    this.registrations,
    this.eventId,
    this.products,
    this.athletesWithSeasonPasses,
    this.questionnaire,
  });

  RegisterEventRequestModel.fromJson(dynamic json) {
    cardToken = json['card_token'];
    coupon = json['coupon'];
    saveCard = json['save_card'];
    eventId = json['event_id'];
    existing = json['existing'];
    if (json['registrations'] != null) {
      registrations = [];
      json['registrations'].forEach((v) {
        registrations?.add(PostRegistrations.fromJson(v));
      });
    }
    if (json['products'] != null) {
      products = [];
      json['products'].forEach((v) {
        products?.add(PostProducts.fromJson(v));
      });
    }
    if (json['purchases'] != null) {
      athletesWithSeasonPasses = [];
      json['purchases'].forEach((v) {
        athletesWithSeasonPasses?.add(PostSeasonPasses.fromJson(v));
      });
    }
    if (questionnaire != null) {
      questionnaire = [];
      json['questionnaire'].forEach((v) {
        questionnaire?.add(Questionnaire.fromJson(v));
      });
    }
  }

  String? coupon;
  String? cardToken;
  String? eventId;
  bool? saveCard;
  bool? existing;
  List<Questionnaire>? questionnaire;
  List<PostRegistrations>? registrations;
  List<PostProducts>? products;
  List<PostSeasonPasses>? athletesWithSeasonPasses;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['coupon'] = coupon;
    map['card_token'] = cardToken;
    map['event_id'] = eventId;
    map['save_card'] = saveCard;
    map['existing'] = existing;
    if (registrations != null) {
      map['registrations'] = registrations?.map((v) => v.toJson()).toList();
    }
    if (products != null) {
      map['products'] = products?.map((v) => v.toJson()).toList();
    }
    if (questionnaire != null) {
      map['questionnaire'] = questionnaire?.map((v) => v.toJson()).toList();
    }
    if (athletesWithSeasonPasses != null) {
      map['purchases'] =
          athletesWithSeasonPasses?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class PostProducts {
  PostProducts({
    this.productId,
    this.qty,
    this.variant,
  });

  PostProducts.fromJson(dynamic json) {
    productId = json['product_id'];
    qty = json['qty'];
    variant = json['variant'];
  }

  String? productId;
  num? qty;
  String? variant;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['product_id'] = productId;
    map['qty'] = qty;
    map['variant'] = variant;
    return map;
  }
}

class PostSeasonPasses {
  PostSeasonPasses({
    this.athleteId,
    this.membershipId,
  });

  PostSeasonPasses.fromJson(dynamic json) {
    athleteId = json['athlete_id'];
    membershipId = json['membership_id'];
  }

  String? athleteId;
  String? membershipId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['athlete_id'] = athleteId;
    map['membership_id'] = membershipId;

    return map;
  }
}

class PostRegistrations {
  PostRegistrations({
    this.athleteId,
    this.divisions,
    this.teamId,
  });

  PostRegistrations.fromJson(dynamic json) {
    athleteId = json['athlete_id'];
    if (json['divisions'] != null) {
      divisions = [];
      json['divisions'].forEach((v) {
        divisions?.add(PostDivisions.fromJson(v));
      });
    }
    teamId = json['team_id'];
  }

  String? athleteId;
  List<PostDivisions>? divisions;
  String? teamId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['athlete_id'] = athleteId;
    if (divisions != null) {
      map['divisions'] = divisions?.map((v) => v.toJson()).toList();
    }
    map['team_id'] = teamId;
    return map;
  }
}

class PostDivisions {
  PostDivisions({
    this.divisionId,
    this.eventDivisionId,
    this.weightClasses,
  });

  PostDivisions.fromJson(dynamic json) {
    divisionId = json['division_id'];
    eventDivisionId = json['event_division_id'];
    weightClasses = json['weight_classes'] != null
        ? json['weight_classes'].cast<String>()
        : [];
  }

  String? divisionId;
  String? eventDivisionId;
  List<String>? weightClasses;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['division_id'] = divisionId;
    map['event_division_id'] = eventDivisionId;
    map['weight_classes'] = weightClasses;
    return map;
  }
}

class Questionnaire {
  String? questionId;
  String? answer;
  TextEditingController? textEditingController;
  FocusNode? focusNode;
  String? radioValue;
  List<String>? checkBoxValues;
  GlobalKey<FormState>? formKey;

  Questionnaire(
      {this.questionId,
      this.answer,
      this.textEditingController,
      this.focusNode,
      this.radioValue,
      this.formKey,
      this.checkBoxValues});

  Questionnaire.fromJson(dynamic json) {
    questionId = json['question_id'];
    answer = json['answer'];
    formKey = json['formKey'];
    textEditingController = json['textEditingController'];
    focusNode = json['focusNode'];
    radioValue = json['radioValue'];
    checkBoxValues = json['checkBoxValues'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['question_id'] = questionId;
    map['answer'] = answer;
    return map;
  }
}
