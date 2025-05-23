part of 'register_and_sell_bloc.dart';

@immutable
sealed class RegisterAndSellEvent extends Equatable {
  const RegisterAndSellEvent();

  @override
  List<Object> get props => [];
}

class TriggerToCheckSaveButtonStatus extends RegisterAndSellEvent {}

class TriggerFormExpansion extends RegisterAndSellEvent {}
class TriggerInteractWithContactField extends RegisterAndSellEvent {}

class TriggerOnClickOfBack extends RegisterAndSellEvent {}
class TriggerInitialize extends RegisterAndSellEvent {
  final bool isInit;
  TriggerInitialize({required this.isInit});
  @override
  List<Object> get props => [isInit];
}
class TriggerApplyCoupon extends RegisterAndSellEvent {
  final num? couponAmount;
  final bool isFix;
  String? couponError;
  TriggerApplyCoupon({required this.couponAmount, required this.isFix,this.couponError});
  @override
  List<Object> get props => [ isFix, ];
}

class TriggerRemoveCoupon extends RegisterAndSellEvent {}

class TriggerClickGoogleCity extends RegisterAndSellEvent {
  final Prediction item;

  const TriggerClickGoogleCity({required this.item});

  @override
  List<Object> get props => [item];
}

class TriggerRetrieveGoogleCityInfo extends RegisterAndSellEvent {
  final String zip;
  final String city;
  final String state;
  final String address;

  const TriggerRetrieveGoogleCityInfo(
      {required this.zip,
      required this.city,
      required this.state,
      required this.address});

  @override
  List<Object> get props => [zip, city, state, address];
}

class TriggerSaveAndContinue extends RegisterAndSellEvent {}

class TriggerGenerateAthleteList extends RegisterAndSellEvent {
  final Athlete athlete;

  const TriggerGenerateAthleteList({required this.athlete});

  @override
  List<Object> get props => [athlete];
}
class TriggerRemoveAthlete extends RegisterAndSellEvent {
  final String athleteId;

  const TriggerRemoveAthlete({required this.athleteId});

  @override
  List<Object> get props => [athleteId];
}
class TriggerSwitchTab extends RegisterAndSellEvent {
  final int index;

  const TriggerSwitchTab({required this.index});

  @override
  List<Object> get props => [index];
}
class TriggerFetchEmployeeEventDetails extends RegisterAndSellEvent {
  final String eventId;

  const TriggerFetchEmployeeEventDetails({required this.eventId});

  @override
  List<Object> get props => [eventId];
}
class TriggerUpdateProductUI extends RegisterAndSellEvent {
  final List<Products> products;
  final int index;

  const TriggerUpdateProductUI({required this.index, required this.products});

  @override
  List<Object> get props => [index, products];
}


class TriggerAddToCart extends RegisterAndSellEvent {

}

class TriggerRemoveAllItems extends RegisterAndSellEvent {

}
class TriggerCheckOut extends RegisterAndSellEvent {
  final String couponCode;
  const TriggerCheckOut({required this.couponCode});
  @override
  List<Object> get props => [couponCode];
}

class TriggerSuccessDialog extends RegisterAndSellEvent{
   PurchaseSocketResponseModel? purchaseResponse;
   TriggerSuccessDialog({required this.purchaseResponse});
  @override
  List<Object> get props => [];
}
class TriggerRefreshRegistrationAndSellForm extends RegisterAndSellEvent {}
class TriggerPurchaseFail extends RegisterAndSellEvent {
}
class TriggerDownloadPdf extends RegisterAndSellEvent{
  final String invoiceUrl;
  const TriggerDownloadPdf({required this.invoiceUrl});
  @override
  List<Object> get props => [invoiceUrl];
}

class TriggerChangeProductQuantity extends RegisterAndSellEvent {
  final num quantity;
  final List<Products> product;
  final int index;
  final bool isMinus;
  final bool isFromMBS;

  const TriggerChangeProductQuantity(
      {required this.quantity,
        required this.product,
        required this.index,
        required this.isFromMBS,
        required this.isMinus});

  @override
  List<Object> get props => [quantity, isFromMBS, product, index, isMinus];
}
// class TriggerChangeVariant extends RegisterAndSellEvent {
//   final int index;
//   final String variant;
//   const TriggerChangeVariant({required this.index, required this.variant});
//   @override
//   List<Object> get props => [index, variant];
// }

class TriggerAddSelectedProductToCart extends RegisterAndSellEvent{
  final Products product;

  const TriggerAddSelectedProductToCart({required this.product});

  @override
  List<Object> get props => [product];
}

class TriggerSelectVariant extends RegisterAndSellEvent {
   String? selectedValue;
  final List<Products> product;
  final int index;
  final bool isFromMBS;

   TriggerSelectVariant(
      {required this.selectedValue,
        required this.product,
        required this.isFromMBS,
        required this.index});

  @override
  List<Object> get props =>  [ product, index];
}

class TriggerOpenDropDown extends RegisterAndSellEvent {
  final bool isOpened;
  final bool isAthlete;
  int? index;
  TriggerOpenDropDown({required this.isOpened, this.index, required this.isAthlete});

  @override
  List<Object> get props => [isOpened, isAthlete];
}

class TriggerChangeCartQuantity extends RegisterAndSellEvent {
  final int index;
  final bool reduce;

  const TriggerChangeCartQuantity({required this.index, required this.reduce});

  @override
  List<Object> get props => [index, reduce];
}

class TriggerMakeItAtToCart extends RegisterAndSellEvent{}

class TriggerCancelPurchase extends RegisterAndSellEvent{
  final String readerId;
  final String paymentId;
  const TriggerCancelPurchase({required this.readerId, required this.paymentId});
  @override
  List<Object> get props => [readerId, paymentId];
}

class TriggerFetchCustomerAthletes extends RegisterAndSellEvent{}
class TriggerRegenerateAthleteListAfterDeletion extends RegisterAndSellEvent{
  final List<Athlete> athletes;
  const TriggerRegenerateAthleteListAfterDeletion({required this.athletes});
  @override
  List<Object> get props => [athletes];
}

class TriggerCheckMandatoryT extends RegisterAndSellEvent{}
class TriggerRemoveItemsT extends RegisterAndSellEvent{}
class TriggerCheckIfApplyActiveT extends RegisterAndSellEvent{}
class TriggerCouponApplicationT extends RegisterAndSellEvent{}
class TriggerCouponRemovalT extends RegisterAndSellEvent{}
class TriggerArrangeDataForSummaryT extends RegisterAndSellEvent{}
class TriggerOpenMBSFORGiveAwayT extends RegisterAndSellEvent{}
class TriggerChangeProductCartQuantity extends RegisterAndSellEvent{
  final Products product;
  final bool isMinus;
  const TriggerChangeProductCartQuantity({required this.product, required this.isMinus,});

  @override
  List<Object> get props => [product, isMinus,];
}


