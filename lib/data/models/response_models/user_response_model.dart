class UserResponseModel {
  UserResponseModel({
      this.status, 
      this.responseData,});

  UserResponseModel.fromJson(dynamic json) {
    status = json['status'];
    responseData = json['responseData'] != null ? UserResponseData.fromJson(json['responseData']) : null;
  }
  bool? status;
  UserResponseData? responseData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (responseData != null) {
      map['responseData'] = responseData?.toJson();
    }
    return map;
  }

}

class UserResponseData {
  UserResponseData({
      this.message, 
      this.user, 
      this.assetsUrl,});

  UserResponseData.fromJson(dynamic json) {
    message = json['message'];
    user = json['user'] != null ? DataBaseUser.fromJson(json['user']) : null;
    assetsUrl = json['assets_url'];
  }
  String? message;
  DataBaseUser? user;
  String? assetsUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    if (user != null) {
      map['user'] = user?.toJson();
    }
    map['assets_url'] = assetsUrl;
    return map;
  }

}

class DataBaseUser {
  DataBaseUser({
    this.id,this.underScoreId,
    this.roles,
    this.accountType,
    this.canSwitch,
    this.currentRole,
    this.moveToCreateProfile,
    this.userType,
    this.firstName,
    this.lastName,
    this.socialId,
    this.email,
    this.profile,
    this.phoneCode,
    this.isPasswordChangeRequired,
    this.phoneNumber,
    this.birthDate,
    this.isProfileComplete,
    this.athletesCount,
    this.upcomingEventsCount,
    this.awardsCount,
    this.policyAcceptedOn,
    this.gender,
    this.mailingAddress,
    this.label,
    this.city,
    this.state,
    this.setCurrentRole,
    this.zipcode,
    this.token,});

  DataBaseUser.fromJson(dynamic json) {
    id = json['id'];
    underScoreId = json['_id'];
    accountType = json['account_type'];
    isPasswordChangeRequired = json['require_password_change'];
    setCurrentRole = json['setCurrentRole'];
    roles = json['roles'] != null ? json['roles'].cast<String>() : [];
    userType = json['user_type'];
    moveToCreateProfile = json['moveToCreateProfile'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    socialId = json['social_id'];
    email = json['email'];
    profile = json['profile'];
    phoneCode = json['phone_code'];
    phoneNumber = json['phone_number'];
    birthDate = json['birth_date'];
    label = json['label'];
    isProfileComplete = json['is_profile_complete'];
    athletesCount = json['athletes_count'];
    upcomingEventsCount = json['upcoming_events_count'];
    awardsCount = json['awards_count'];
    policyAcceptedOn = json['policy_accepted_on'];
    gender = json['gender'];
    mailingAddress = json['mailing_address'];
    city = json['city'];
    state = json['state'];
    zipcode = json['zipcode'];
    token = json['token'];
    currentRole = json['currentRole'];
    canSwitch = json['canSwitch'];
  }
  String? id;
  String? underScoreId;
  List<String>? roles;
  String? userType;
  String? currentRole;
  String? setCurrentRole;
  String? label;
  String? firstName;
  String? lastName;
  String? accountType;
  dynamic socialId;
  String? email;
  bool? moveToCreateProfile;
  bool? isPasswordChangeRequired;
  bool? canSwitch;
  String? profile;
  String? phoneCode;
  String? phoneNumber;
  String? birthDate;
  bool? isProfileComplete;
  num? athletesCount;
  num? upcomingEventsCount;
  num? awardsCount;
  String? policyAcceptedOn;
  String? gender;
  String? mailingAddress;
  String? city;
  String? state;
  String? zipcode;
  String? token;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['account_type'] = accountType;
    map['require_password_change'] = isPasswordChangeRequired;
    map['setCurrentRole'] = setCurrentRole;
    map['_id'] = underScoreId;
    map['roles'] = roles;
    map['canSwitch'] = canSwitch;
    map['label'] = label;
    map['moveToCreateProfile'] = moveToCreateProfile;
    map['currentRole'] = currentRole;
    map['user_type'] = userType;
    map['first_name'] = firstName;
    map['last_name'] = lastName;
    map['social_id'] = socialId;
    map['email'] = email;
    map['profile'] = profile;
    map['phone_code'] = phoneCode;
    map['phone_number'] = phoneNumber;
    map['birth_date'] = birthDate;
    map['is_profile_complete'] = isProfileComplete;
    map['athletes_count'] = athletesCount;
    map['upcoming_events_count'] = upcomingEventsCount;
    map['awards_count'] = awardsCount;
    map['policy_accepted_on'] = policyAcceptedOn;
    map['gender'] = gender;
    map['mailing_address'] = mailingAddress;
    map['city'] = city;
    map['state'] = state;
    map['zipcode'] = zipcode;
    map['token'] = token;
    return map;
  }

}