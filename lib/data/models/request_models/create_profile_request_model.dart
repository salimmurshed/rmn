import 'dart:io';

class CreateProfileRequestModel {
  final String firstName;
  final String lastName;
  final String birthDate;
  final String phoneCode;
  final String contactNumber;
  final String address;
  final File? profileImage;
  final String gender;
  final String zipCode;
  final String athleteFlag;
  final bool isPolicyAccepted;
  final String city;
  final String stateName;
  final bool isRedshirt;
  final String gradeValue;
  String email;
  String weight;
  String teamId;
  String athleteId;
  String uniqueId;
  String isUserParent;
  bool isCreateProfile;

  CreateProfileRequestModel({
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    required this.isRedshirt,
    required this.gradeValue,
    required this.phoneCode,
    required this.contactNumber,
    required this.address,
    required this.profileImage,
    required this.athleteFlag,
    required this.gender,
    required this.zipCode,
    this.isPolicyAccepted = false,
    required this.city,
    required this.stateName,
    this.email = '',
    this.athleteId = '',
    this.uniqueId = '',
    this.weight = '',
    this.teamId = '',
    this.isUserParent = '',
    this.isCreateProfile = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'birth_date': birthDate,
      'phone_code': phoneCode,
      'contact_no': contactNumber,
      'address': address,
      'image': profileImage?.path,
      'gender': gender,
      'zipcode': zipCode,
      'athlete_flag': athleteFlag,
      'isPolicyAccepted': isPolicyAccepted,
      'city': city,
      'state': stateName,
      'is_redshirt': isRedshirt,
      'grade': gradeValue,
      'email': email,
      'weight': weight,
      'team_id': teamId,
      'athleteId': athleteId,
      'unique_id': uniqueId,
      'is_user_parent': isUserParent,
      'isCreateProfile': isCreateProfile,
    };
  }

  factory CreateProfileRequestModel.fromJson(Map<String, dynamic> json) {
    return CreateProfileRequestModel(
      firstName: json['first_name'],
      lastName: json['last_name'],
      birthDate: json['birth_date'],
      isRedshirt: json['is_redshirt'],
      gradeValue: json['grade'],
      phoneCode: json['phone_code'],
      contactNumber: json['contact_no'],
      address: json['address'],
      profileImage: json['image'] != null ? File(json['image']) : null,
      athleteFlag: json['athlete_flag'],
      gender: json['gender'],
      zipCode: json['zipcode'],
      isPolicyAccepted: json['isPolicyAccepted'],
      city: json['city'],
      stateName: json['state'],
      email: json['email'] ?? '',
      athleteId: json['athleteId'] ?? '',
      weight: json['weight'] ?? '',
      teamId: json['team_id'] ?? '',
      isUserParent: json['is_user_parent'] ?? '',
      uniqueId: json['unique_id'] ?? '',
      isCreateProfile: json['isCreateProfile'] ?? true,
    );
  }
}