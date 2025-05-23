class ResetPasswordRequestModel{
  final String newPassword;
  final String confirmPassword;
  final String token;
  const ResetPasswordRequestModel({required this.newPassword, required this.confirmPassword, required this.token});
}