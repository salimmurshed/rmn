enum Environment { dev, prod }

enum Authentication { signIn, signUp, signUpMask, rememberPassword }

enum Socials { google, facebook, apple, none }

enum ProductCardType { cardPreview, eventRegs, eventProds, none }



enum AthleteSelectionTabs {
  selectedAthletes,
  yourAthletes,
  expansionPanel,
  none
}

enum HistoryTabEvents {
  all,
  products,
  registrations,
  productScroll,
  registrationScroll,
  allScroll,
  none
}
enum AthleteApiCallType {newTab, notificationCall, none}
enum CheckOutType { registration, products, none }
enum CreateProfileTypes {
  addAthleteAfterCreateProfile,
  addAthleteFromMyList,
  addAthleteFromRegistrationSelection,
  createProfileForOwner,
  editProfileForOwner,
  editProfileForAthlete,
  createAthleteLocally,
  createAthleteLocallyFromRegs,
  editAthleteLocally,
  none
}
enum ChatType {
  All,
  Unread,
  Archived
}

enum MyPurchases { seasonPasses, products, none }

enum FieldType {
  address,
  zip,
  email,
  oldPassword,
  password,
  confirmPassword,
  mobile,
  age,
  cardNumber,
  cardName,
  firstName,
  lastName,
  weight
}

enum ChatMessageType {
  sent,
  received,
}

enum Legals { imprints, tou, pp, foss, aboutUs }

enum PasswordChecker {
  isAtLeastEightCharChecked,
  isAtLeastOneLowerCaseChecked,
  isAtLeastOneUpperCaseChecked,
  isAtLeastOneDigitChecked,
  isAtLeastOneSpecialCharChecked
}

enum TabButtonType { selected, unselected }

enum OS { android, ios }

enum QRCodeStatus { confirmed, cancelled }

enum UserTypes { user, employee, admin, owner }

enum NameTypes { firstName, lastName, cardHolderName }

enum AgeType { owner, athlete }

enum RequestTypeCombination { all, coachOwner, ownerOnly }

enum AthleteMetrics {
  rank,
  award,
  calendar,
  weight,
  age,
}

enum TypeOfAccess { coach, owner, view, none }

enum TypeOfMetric { noOfEvents, rank, award, weight, age, none }

enum SizeType {
  large,
  medium,
  small,
}

enum FilterType { upcoming, past, miscellaneous, none }

enum AthleteTab {
  myAthletesBeforeRequest,
  myAthletesAfterRequest,
  allAthletesBeforeRequest,
  allAthletesAfterRequest,
  requests,
  home,
  none
}

enum AthleteApiType {
  homeAthletes,
  myAthletes,
  allAthletes,
  findAthletes,
  requestedAthletes,
  eventWiseAthletes,
}

enum EventDetailTab {
  eventInformation,
  registration,
  divisions,
  awards,
  products,
  hotels,
  schedule,
  none
}

enum AppSettingOptions { notification, crashCollection, location }

enum CouponModules {
  registration,
  employeeRegistration,
  tickets,
  seasonPasses,
  none,
}

enum AllEventsViewType { mapView, listView }

enum EventStatus { live, next, upcoming, past, none }

enum SummaryCard { registration, products, athletes, none }

enum SummarySection { regs, products, athletes, payment, none }

enum PaymentModuleTabNames {
  registrations,
  products,
  payment,
  summary,
  athletes,
  none
}

enum InfoCardType { seasonPasses, products, eventRegs, eventProducts, none }
enum DropDownTypeForCreateAthlete { teamSelection, gradeSelection,  none }
enum ScanType{ purchase, registration, none}
enum PosInfoType{ connected, available, none}
enum QuestionnaireType{free_text,single_choice,multi_choice,none}
enum AccountType{email, google, facebook, apple, none}
enum CustomerPurchasesTypes {all, scanned, unScanned, none}
enum PurchaseItemType {product, registration, none}
enum TypesOfGiveaway{ type1, type2, type3, type4}
enum TypeOfPurchase{ client, staff, prods}