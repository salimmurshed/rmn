class EmployeeCheckoutRequestModel {
  EmployeeCheckoutRequestModel({
      this.readerId, 
      this.userId,
      this.coupon,
      this.parent, 
      this.athletes, 
      this.registrations, 
      this.products,});

  EmployeeCheckoutRequestModel.fromJson(dynamic json) {
    readerId = json['reader_id'];
    userId = json['user_id'];
    coupon = json['coupon'];
    parent = json['parent'] != null ? Parent.fromJson(json['parent']) : null;
    if (json['athletes'] != null) {
      athletes = [];
      json['athletes'].forEach((v) {
        athletes?.add(AthletesSelection.fromJson(v));
      });
    }
    if (json['registrations'] != null) {
      registrations = [];
      json['registrations'].forEach((v) {
        registrations?.add(RegistrationsSelection.fromJson(v));
      });
    }
    if (json['products'] != null) {
      products = [];
      json['products'].forEach((v) {
        products?.add(ProductsSelection.fromJson(v));
      });
    }
  }
  String? readerId;
  String? coupon;
  Parent? parent;
  String? userId;
  List<AthletesSelection>? athletes;
  List<RegistrationsSelection>? registrations;
  List<ProductsSelection>? products;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['reader_id'] = readerId;
    map['user_id'] = userId;
    map['coupon'] = coupon;
    if (parent != null) {
      map['parent'] = parent?.toJson();
    }
    if (athletes != null) {
      map['athletes'] = athletes?.map((v) => v.toJson()).toList();
    }
    if (registrations != null) {
      map['registrations'] = registrations?.map((v) => v.toJson()).toList();
    }
    if (products != null) {
      map['products'] = products?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class ProductsSelection {
  ProductsSelection({
      this.productId, 
      this.qty, 
      this.variant,});

  ProductsSelection.fromJson(dynamic json) {
    productId = json['product_id'];
    qty = json['qty'];
    variant = json['variant'];
  }
  String? productId;
  num? qty;
  dynamic variant;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['product_id'] = productId;
    map['qty'] = qty;
    map['variant'] = variant;
    return map;
  }

}

class RegistrationsSelection {
  RegistrationsSelection({
      this.athleteId, 
      this.divisions,});

  RegistrationsSelection.fromJson(dynamic json) {
    athleteId = json['athlete_id'];
    if (json['divisions'] != null) {
      divisions = [];
      json['divisions'].forEach((v) {
        divisions?.add(DivisionsSelected.fromJson(v));
      });
    }
  }
  String? athleteId;
  List<DivisionsSelected>? divisions;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['athlete_id'] = athleteId;
    if (divisions != null) {
      map['divisions'] = divisions?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class DivisionsSelected {
  DivisionsSelected({
      this.divisionId, 
      this.eventDivisionId, 
      this.weightClasses,});

  DivisionsSelected.fromJson(dynamic json) {
    divisionId = json['division_id'];
    eventDivisionId = json['event_division_id'];
    weightClasses = json['weight_classes'] != null ? json['weight_classes'].cast<String>() : [];
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

class AthletesSelection {
  AthletesSelection({
      this.uniqueId, 
      this.firstName, 
      this.lastName, 
      this.email, 
      this.gender, 
      this.birthDate, 
      this.grade, 
      this.isRedshirt, 
      this.weight, 
      this.phoneCode, 
      this.phoneNumber, 
      this.address, 
      this.city, 
      this.state, 
      this.pincode, 
      this.isUserParent, 
      this.teamId,});

  AthletesSelection.fromJson(dynamic json) {
    uniqueId = json['unique_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    gender = json['gender'];
    birthDate = json['birth_date'];
    grade = json['grade'];
    isRedshirt = json['is_redshirt'];
    weight = json['actual_weight'];
    phoneCode = json['phone_code'];
    phoneNumber = json['phone_number'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    pincode = json['pincode'];
    isUserParent = json['is_user_parent'];
    teamId = json['team_id'];
  }
  String? uniqueId;
  String? firstName;
  String? lastName;
  String? email;
  String? gender;
  String? birthDate;
  String? grade;
  bool? isRedshirt;
  num? weight;
  num? phoneCode;
  num? phoneNumber;
  String? address;
  String? city;
  String? state;
  String? pincode;
  bool? isUserParent;
  String? teamId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['unique_id'] = uniqueId;
    map['first_name'] = firstName;
    map['last_name'] = lastName;
    map['email'] = email;
    map['gender'] = gender;
    map['birth_date'] = birthDate;
    map['grade'] = grade;
    map['is_redshirt'] = isRedshirt;
    map['actual_weight'] = weight;
    map['phone_code'] = phoneCode;
    map['phone_number'] = phoneNumber;
    map['address'] = address;
    map['city'] = city;
    map['state'] = state;
    map['pincode'] = pincode;
    map['is_user_parent'] = isUserParent;
    map['team_id'] = teamId;
    return map;
  }

}

class Parent {
  Parent({
      this.firstName, 
      this.lastName, 
      this.email, 
      this.mailingAddress, 
      this.city, 
      this.state, 
      this.zipcode,
      this.phoneCode,
      this.phoneNumber,
  });

  Parent.fromJson(dynamic json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    mailingAddress = json['mailing_address'];
    city = json['city'];
    state = json['state'];
    zipcode = json['zipcode'];
    phoneCode = json['phone_code'];
    phoneNumber = json['phone_number'];
  }
  String? firstName;
  String? lastName;
  String? email;
  String? mailingAddress;
  String? city;
  String? state;
  String? zipcode;
  String? phoneCode;
  String? phoneNumber;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['first_name'] = firstName;
    map['last_name'] = lastName;
    map['email'] = email;
    map['mailing_address'] = mailingAddress;
    map['city'] = city;
    map['state'] = state;
    map['zipcode'] = zipcode;
    map['phone_code'] = phoneCode;
    map['phone_number'] = phoneNumber;
    return map;
  }

}