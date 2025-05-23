import '../../../imports/common.dart';
import '../../../imports/data.dart';

class PurchaseArguments {
  String eventLocation;
  String date;
  String title;
  String coverImage;
  String assetUrl;
  final CouponModules couponModule;
  List<Products> products;
  List<Athlete> readyForRegistrationAthletes;
  List<Athlete> athleteForSeasonPass;

  PurchaseArguments({
    this.eventLocation = AppStrings.global_empty_string,
    this.date = AppStrings.global_empty_string,
    this.title = AppStrings.global_empty_string,
    this.coverImage = AppStrings.global_empty_string,
    this.assetUrl = AppStrings.global_empty_string,
    this.products = const [],
    this.readyForRegistrationAthletes = const [],
    this.athleteForSeasonPass = const [],
    required this.couponModule,
  });
}
