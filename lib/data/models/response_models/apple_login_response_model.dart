class AppleUserDataModel {
  String? firstName;
  String? lastName;
  String? email;
  String? userIdentifier;
  String? photoUrl;

  AppleUserDataModel(
      { this.email, this.firstName, this.userIdentifier, this.photoUrl,this.lastName}) {
    firstName = firstName;
    email = email;
    userIdentifier = userIdentifier;
    photoUrl = photoUrl;
    lastName = lastName;
  }

  AppleUserDataModel.fromJson(Map<String, dynamic> json)
      : firstName = json['givenName'],
        email = json['email'],
        userIdentifier = json['udid'],
        photoUrl=json['photoUrl'],
        lastName=json['familyName'] ;

  Map<String, dynamic> toJson() =>
      {
        'givenName': firstName?? "",
        'email': email?? "",
        'udid': userIdentifier?? "",
        "photoUrl": photoUrl?? "",
        "familyName": lastName?? ""
      };
}