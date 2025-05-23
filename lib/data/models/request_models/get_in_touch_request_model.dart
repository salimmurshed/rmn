class GetInTouchRequestModel {
  GetInTouchRequestModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    this.countryCode = 1,
    required this.message,
  });

  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final int countryCode;
  final String message;
}
