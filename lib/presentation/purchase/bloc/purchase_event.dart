part of 'purchase_bloc.dart';

@immutable
sealed class PurchaseEvent extends Equatable {
  const PurchaseEvent();

  @override
  List<Object?> get props => [];
}

class TriggerFetchEventWiseData extends PurchaseEvent {
  final CouponModules couponModules;

  const TriggerFetchEventWiseData({required this.couponModules});

  @override
  List<Object?> get props => [couponModules];
}

class TriggerUpdateCardCurrentIndex extends PurchaseEvent {
  final int currentIndex;

  const TriggerUpdateCardCurrentIndex({required this.currentIndex});

  @override
  List<Object?> get props => [currentIndex];
}

class TriggerUnHideDivisionList extends PurchaseEvent {
  final int index;

  const TriggerUnHideDivisionList({required this.index});

  @override
  List<Object?> get props => [index];
}

class TriggerDropDownSelection extends PurchaseEvent {
  final String? selectedValue;
  final Athlete athlete;
  final List<Team> teams;

  const TriggerDropDownSelection(
      {required this.selectedValue,
      required this.athlete,
      required this.teams});

  @override
  List<Object?> get props => [selectedValue, athlete, teams];
}

class TriggerFindOtherTeams extends PurchaseEvent {
  final String typedText;
  final List<Team> teams;

  const TriggerFindOtherTeams({required this.typedText, required this.teams});

  @override
  List<Object?> get props => [typedText, teams];
}

class TriggerTapOnMatchedTeamName extends PurchaseEvent {
  final String teamName;
  final List<Team> teams;
  final Athlete athlete;

  const TriggerTapOnMatchedTeamName(
      {required this.teamName, required this.teams, required this.athlete});

  @override
  List<Object?> get props => [teamName, teams, athlete];
}

class TriggerOpenDropDownP extends PurchaseEvent {
  final bool isOpened;
  final bool isAthlete;
  int? index;
   TriggerOpenDropDownP({required this.isOpened, this.index, required this.isAthlete});

  @override
  List<Object?> get props => [isOpened, isAthlete];
}

class TriggerChangeProductQuantityP extends PurchaseEvent {
  final num quantity;
  final List<Products> product;
  final int index;
  final bool isMinus;
  final bool isFromMBS;

  const TriggerChangeProductQuantityP(
      {required this.quantity,
      required this.product,
      required this.index,
      required this.isFromMBS,
      required this.isMinus});

  @override
  List<Object?> get props => [quantity, isFromMBS, product, index, isMinus];
}

class TriggerSelectVariantP extends PurchaseEvent {
  final String? selectedValue;
  final List<Products> product;
  final int index;
  final bool isFromMBS;

  const TriggerSelectVariantP(
      {required this.selectedValue,
      required this.product,
      required this.isFromMBS,
      required this.index});

  @override
  List<Object?> get props => [selectedValue, product, index];
}

class TriggerCardListFetch extends PurchaseEvent {}

class TriggerSelectCard extends PurchaseEvent {
  final int index;

  const TriggerSelectCard({required this.index});

  @override
  List<Object?> get props => [index];
}

class TriggerArrangeDataForSummary extends PurchaseEvent {
  const TriggerArrangeDataForSummary();

  @override
  List<Object?> get props => [];
}

class TriggerMovingForward extends PurchaseEvent {
  final List<Athlete> athletesForSeasonPass;
  final CouponModules couponModule;
  final bool isContinueButtonActive;

  const TriggerMovingForward({
    this.isContinueButtonActive = false,
    required this.couponModule,
    this.athletesForSeasonPass = const [],
  });

  @override
  List<Object?> get props =>
      [athletesForSeasonPass, couponModule, isContinueButtonActive];
}

class TriggerMovingBackward extends PurchaseEvent {
  final CouponModules couponModule;
  final List<Athlete> athletesForSeasonPass;

  const TriggerMovingBackward(
      {required this.couponModule, this.athletesForSeasonPass = const []});

  @override
  List<Object?> get props => [couponModule, athletesForSeasonPass];
}

class TriggerCouponApplication extends PurchaseEvent {
  final String module;
  String? code;
   TriggerCouponApplication({required this.module, this.code});

  @override
  List<Object?> get props => [module, code];
}

class TriggerCouponRemoval extends PurchaseEvent {}

class TriggerCheckApplyButtonActivity extends PurchaseEvent {}

class TriggerCheckContinueButtonActivity extends PurchaseEvent {
  final List<Athlete> athletesForSeasonPass;

  final bool isContinueButtonActive;

  const TriggerCheckContinueButtonActivity({
    this.athletesForSeasonPass = const [],
    this.isContinueButtonActive = false,
  });

  @override
  List<Object?> get props => [athletesForSeasonPass, isContinueButtonActive];
}

class TriggerPurchase extends PurchaseEvent {
  final CouponModules couponModule;
  final List<Athlete> athletesForSeasonPass;

  const TriggerPurchase(
      {required this.couponModule, this.athletesForSeasonPass = const []});

  @override
  List<Object?> get props => [couponModule, athletesForSeasonPass];
}

class TriggerAddCard extends PurchaseEvent {
  final String cardNumber;
  final String expiryDate;
  final String cvc;
  final String name;

  const TriggerAddCard(
      {required this.cardNumber,
      required this.expiryDate,
      required this.cvc,
      required this.name});

  @override
  List<Object?> get props => [cardNumber, expiryDate, cvc, name];
}

class TriggerSelectMonthYear extends PurchaseEvent {
  final DateTime monthYear;

  const TriggerSelectMonthYear({required this.monthYear});

  @override
  List<Object?> get props => [monthYear];
}

class TriggerSaveCard extends PurchaseEvent {}

class TriggerOpenAddCardView extends PurchaseEvent {}

class TriggerRemoveCard extends PurchaseEvent {
  final int index;

  const TriggerRemoveCard({required this.index});

  @override
  List<Object?> get props => [index];
}

class TriggerEditItem extends PurchaseEvent {
  final SummarySection section;

  const TriggerEditItem({
    required this.section,
  });

  @override
  List<Object?> get props => [
        section,
      ];
}

class TriggerPurchaseEvent extends PurchaseEvent {
  final CouponModules couponModule;

  const TriggerPurchaseEvent({required this.couponModule});

  @override
  List<Object?> get props => [couponModule];
}

class TriggerRemoveSeasonPassAthlete extends PurchaseEvent {
  final int athleteIndex;
  bool isFromPurchaseView;

  TriggerRemoveSeasonPassAthlete(
      {required this.athleteIndex, this.isFromPurchaseView = false});

  @override
  List<Object?> get props => [athleteIndex, isFromPurchaseView];
}

class TriggerUpdateAthleteTier extends PurchaseEvent {
  final int athleteIndex;
  final String seasonPassTitle;

  const TriggerUpdateAthleteTier(
      {required this.seasonPassTitle, required this.athleteIndex});

  @override
  List<Object?> get props => [athleteIndex, seasonPassTitle];
}

class TriggerSelectSeasonPassTier extends PurchaseEvent {
  final String seasonPassTitle;
  final int athleteIndex;

  const TriggerSelectSeasonPassTier({
    required this.athleteIndex,
    required this.seasonPassTitle,
  });

  @override
  List<Object?> get props => [
        athleteIndex,
        seasonPassTitle,
      ];
}

class TriggerValidateCardDate extends PurchaseEvent {
  final String expiryDate;

  const TriggerValidateCardDate({required this.expiryDate});

  @override
  List<Object?> get props => [expiryDate];
}

class TriggerReFresh extends PurchaseEvent {
  const TriggerReFresh();

  @override
  List<Object?> get props => [];
}

class TriggerOnChangeForCardExpiry extends PurchaseEvent {}

class TriggerStopLoader extends PurchaseEvent {}
class TriggerSwitchTabs extends PurchaseEvent {
  final int index;
  final bool isEdit;
  const TriggerSwitchTabs({required this.index, this.isEdit = false });
  @override
  List<Object?> get props => [index, isEdit];
}

class TriggerAddSelectedProductToCartP extends PurchaseEvent{
  final Products product;

  const TriggerAddSelectedProductToCartP({required this.product});

  @override
  List<Object> get props => [product];
}

class TriggerChangeProductCartQuantityP extends PurchaseEvent{
  final Products product;
  final bool isMinus;
  const TriggerChangeProductCartQuantityP({required this.product, required this.isMinus,});

  @override
  List<Object> get props => [product, isMinus,];
}

class TriggerCheckIfApplyActive extends PurchaseEvent{}
class TriggerRemoveItems extends PurchaseEvent{}
class TriggerCheckForMandatory extends PurchaseEvent{}
class TriggerOpenMBSFORGiveAway extends PurchaseEvent{

}
