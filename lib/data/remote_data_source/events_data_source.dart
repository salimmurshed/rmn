import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../../imports/common.dart';
import '../../imports/services.dart';
import '../models/request_models/event_purchase_request_model.dart';

class EventDataSource {
  static Future getAllEvents({required num page}) async {
    final String url =
        '${UrlPrefixes.baseUrl}${UrlSuffixes.getAllEvents(page: page)}';
    dynamic response =
        await HttpFactoryServices.getMethod(url, header: await setHeader(true));

    return response;
  }

  static Future getEmployeeEventList() async {
    final String url =
        '${UrlPrefixes.baseUrl}${UrlSuffixes.getEmployeeEventList}';
    dynamic response =
        await HttpFactoryServices.getMethod(url, header: await setHeader(true));

    return response;
  }

  static Future getEventsOnMap() async {
    // final String url = '${UrlPrefixes.baseUrl}${UrlSuffixes.getEventsOnMap}';
    final String url =
        '${UrlPrefixes.baseUrl}${UrlSuffixes.getFilteredEventsOnMaps(filterType: FilterType.upcoming)}';
    dynamic response =
        await HttpFactoryServices.getMethod(url, header: await setHeader(true));

    return response;
  }

  static Future getSearchEventsOnMap({required String searchKey}) async {
    final String url =
        '${UrlPrefixes.baseUrl}${UrlSuffixes.getSearchEventsOnMap(searchKey: searchKey)}';
    dynamic response =
        await HttpFactoryServices.getMethod(url, header: await setHeader(true));

    return response;
  }

  static Future getFilteredEvents(
      {required num page, required FilterType filterType}) async {
    final String url =
        '${UrlPrefixes.baseUrl}${UrlSuffixes.getFilteredEvents(page: page, filterType: filterType)}';
    dynamic response =
        await HttpFactoryServices.getMethod(url, header: await setHeader(true));

    return response;
  }

  static Future getFilteredEventsOnMaps(
      {required FilterType filterType}) async {
    final String url =
        '${UrlPrefixes.baseUrl}${UrlSuffixes.getFilteredEventsOnMaps(filterType: filterType)}';
    dynamic response =
        await HttpFactoryServices.getMethod(url, header: await setHeader(true));

    return response;
  }

  static Future getSearchResults(
      {required num page,
      required FilterType filterType,
      required String searchKeyword}) async {
    final String url =
        '${UrlPrefixes.baseUrl}${UrlSuffixes.getSearchResults(page: page, filterType: filterType, searchKeyword: searchKeyword)}';
    dynamic response =
        await HttpFactoryServices.getMethod(url, header: await setHeader(true));

    return response;
  }

  static Future getEventDetailsData({required String eventId}) async {
    final String url =
        '${UrlPrefixes.baseUrl}${UrlSuffixes.getEventDetailsData}/$eventId';
    dynamic response =
        await HttpFactoryServices.getMethod(url, header: await setHeader(true));

    return response;
  }

  static Future getEventListSeasonWiseForSpecificAthlete(
      {required String seasonId,
      required String athleteId,
      required String eventType}) async {
    final String url =
        '${UrlPrefixes.baseUrl}${UrlSuffixes.getEventListSeasonWiseForSpecificAthlete(seasonId: seasonId, athleteId: athleteId, eventType: eventType)}';
    dynamic response =
        await HttpFactoryServices.getMethod(url, header: await setHeader(true));

    return response;
  }

  static Future registerEvent(
      {required RegisterEventRequestModel eventRegisterRequestModel,
      required CouponModules couponModule}) async {
    final String url = '${UrlPrefixes.baseUrl}${UrlSuffixes.eventPurchase(eventRegisterRequestModel.eventId!)}';
    // couponModule == CouponModules.tickets
    //     ? '${UrlPrefixes.baseUrl}${UrlSuffixes.eventPurchase(eventRegisterRequestModel.eventId!)}'
    //     : couponModule == CouponModules.registration
    //         ? '${UrlPrefixes.baseUrl}${UrlSuffixes.eventPurchase(eventRegisterRequestModel.eventId!)}'
    //         : '${UrlPrefixes.baseUrl}${UrlSuffixes.eventPurchaseSeasons}';

    final dataMap = {
      "coupon":
          eventRegisterRequestModel.coupon ?? AppStrings.global_empty_string,
      "card_token": eventRegisterRequestModel.cardToken,
      "save_card": eventRegisterRequestModel.saveCard,
      "existing": eventRegisterRequestModel.existing,
    };

    if (couponModule == CouponModules.tickets &&
        eventRegisterRequestModel.products != null) {
      dataMap["products"] = eventRegisterRequestModel.products!;
    }
    if (couponModule == CouponModules.registration) {
      if (eventRegisterRequestModel.products != null) {
        dataMap["products"] = eventRegisterRequestModel.products!;
      }
      if (eventRegisterRequestModel.registrations != null) {
        dataMap["registrations"] = eventRegisterRequestModel.registrations!;
      }
      dataMap["questionnaire"] = eventRegisterRequestModel.questionnaire!
          .map((q) => q.toJson())
          .toList();
    }
    if (couponModule == CouponModules.seasonPasses &&
        eventRegisterRequestModel.athletesWithSeasonPasses != null) {
      dataMap["purchases"] =
          eventRegisterRequestModel.athletesWithSeasonPasses!;
    }

    final data = jsonEncode(dataMap);
    print('data:');
    debugPrint(data, wrapWidth: 2000);
    dynamic
    response
    = await HttpFactoryServices.postMethod(url,
        data: data, header: await setHeader(true));

    return
      response;
  }

  static Future getRegistrationList(String id) async {
    String baseUrl = '${UrlPrefixes.baseUrl}${UrlSuffixes.getRegsList(id)}';
    final response = await HttpFactoryServices.getMethod(baseUrl,
        header: await setHeader(true));
    return response;
  }
}
