class PurchaseRequestModel {
  final String coupon;
  final String cardToken;
  final bool saveCard;
  final bool isExisting;
  final List<AthleteWithAssignedSeasonPass> athleteWithAssignedSeasonPass;
  final List<ProductsForPurchase> productsForPurchase;

  const PurchaseRequestModel({
    required this.coupon,
    required this.cardToken,
    required this.saveCard,
    required this.isExisting,
    this.athleteWithAssignedSeasonPass = const [],
    this.productsForPurchase = const [],
  });
}

class AthleteWithAssignedSeasonPass {
  final String athleteId;
  final String seasonPassId;

  const AthleteWithAssignedSeasonPass(
      {required this.athleteId, required this.seasonPassId});
}

class ProductsForPurchase {
  final String productId;
  final num quantity;
  final String variant;

  const ProductsForPurchase(
      {required this.productId, required this.quantity, required this.variant});
}
