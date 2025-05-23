import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/widgets/bottomsheets/bottom_sheet_for_no_edit_registration.dart';
import '../../../imports/common.dart';
import '../../../imports/data.dart';
import 'build_athlete_information.dart';
import 'build_card_container.dart';
import 'build_price_information.dart';

Widget buildListOfSeasonPasses({
  required ProductCardType productCardType,
  bool isLoading = false,
  // required bool isMyProductDetail,
  //  bool isEventRegistration = false,
  PurchasedProductData? purchasedProductData,
  required List<EventRegistrations> eventRegistrations,
  required void Function(int) openBottomSheetWithDropDown,
  required void Function(int) openBottomSheetWithRegisteredWcs,
}) {
  return isLoading? SizedBox(
    height: Dimensions.getScreenHeight()*0.5,
    child: CustomLoader(child: listOfRegisteredAthletes(
        eventRegistrations:  eventRegistrations,
        purchasedProductData: purchasedProductData,
        openBottomSheetWithDropDown: openBottomSheetWithDropDown,
        openBottomSheetWithRegisteredWcs: openBottomSheetWithRegisteredWcs,
        productCardType: productCardType)),
  ):Flexible(
    child: listOfRegisteredAthletes(
       eventRegistrations:  eventRegistrations,
        purchasedProductData: purchasedProductData,
        openBottomSheetWithDropDown: openBottomSheetWithDropDown,
        openBottomSheetWithRegisteredWcs: openBottomSheetWithRegisteredWcs,
       productCardType: productCardType),
  );
}

ListView listOfRegisteredAthletes(
    {required List<EventRegistrations> eventRegistrations,
    required PurchasedProductData? purchasedProductData,
   required void Function(int) openBottomSheetWithDropDown,
   required void Function(int)  openBottomSheetWithRegisteredWcs,
   required ProductCardType productCardType}) {
  return ListView.separated(
    itemCount: eventRegistrations.length,
    padding: EdgeInsets.symmetric(horizontal: 2.w),
    itemBuilder: (context, index) {
      return buildCardContainer(children: [
        SizedBox(
          width: 3.w,
        ),
        buildCustomAthleteProfileHolder(
            isScanned: eventRegistrations[index].isAllScanned ?? false,
            imageUrl: eventRegistrations[index].athlete!.profileImage!,
            age: eventRegistrations[index].athlete!.age.toString(),
            weight: eventRegistrations[index].athlete!.weight.toString()),
        buildAthleteInformation(
            isEditActive:
                eventRegistrations[index].athlete!.canUserEditRegistration! &&
                    (purchasedProductData?.isRegistrationAvailable ?? false),
            context: context,
            teamNames: [],
            fullName: StringManipulation.combineFirstNameWithLastName(
                firstName: eventRegistrations[index].athlete!.firstName!,
                lastName: eventRegistrations[index].athlete!.lastName!),
            teamName: eventRegistrations[index].team!.name!,
            registrations: eventRegistrations[index].registrations ?? [],
            openBottomSheetWithDropDown: eventRegistrations[index]
                        .athlete!
                        .canUserEditRegistration! &&
                    (purchasedProductData?.isRegistrationAvailable ?? false)
                ? () {
                    openBottomSheetWithDropDown(index);
                  }
                : () {
                    bottomSheetForNoEditRegistration(
                        isRegistrationAvailable:
                            purchasedProductData?.isRegistrationAvailable ??
                                false,
                        location: purchasedProductData?.address ?? '',
                        eventName: purchasedProductData?.title ?? '',
                        registeredTeamName:
                            eventRegistrations[index].team!.name!,
                        context: context,
                        athleteAge:
                            eventRegistrations[index].athlete!.age.toString(),
                        athleteWeight: eventRegistrations[index]
                            .athlete!
                            .weight
                            .toString(),
                        athleteImageUrl:
                            eventRegistrations[index].athlete!.profileImage!,
                        athleteNameAsTheTitle:
                            StringManipulation.combineFirstNameWithLastName(
                                firstName: eventRegistrations[index]
                                    .athlete!
                                    .firstName!,
                                lastName: eventRegistrations[index]
                                    .athlete!
                                    .lastName!));
                  },
            openBottomSheetWithRegisteredWcs: () {
              openBottomSheetWithRegisteredWcs(index);
            }),
        buildPriceInformation(
            title: StringManipulation.combineFirstNameWithLastName(
                firstName: eventRegistrations[index]
                    .athlete!
                    .firstName!,
                lastName: eventRegistrations[index]
                    .athlete!
                    .lastName!),
            productCardType: productCardType,
            // isMyProductDetail: false,
            registrations: eventRegistrations[index].registrations ?? [],
            price: eventRegistrations[index].registrationPrice!),
        SizedBox(
          width: 3.w,
        ),
      ]);
    },
    separatorBuilder: (context, index) {
      return SizedBox(
        height: 10.h,
        width: double.infinity,
      );
    },
  );
}
