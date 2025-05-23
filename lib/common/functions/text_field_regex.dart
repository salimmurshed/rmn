class TextFieldRegex{
  static RegExp emailRegex = RegExp( r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  static RegExp passwordDigitRegex = RegExp(r'^(?=.*?[0-9])');
  static RegExp passwordSpecialRegex = RegExp(r'^(?=.*?[!"#$%&()*+,\-./:;<=>?@[\\\]^_`{|}~])');
  static RegExp passwordLowerRegex = RegExp(r'^(?=.*?[a-z])');
  static RegExp passwordUpperRegex = RegExp(r'^(?=.*?[A-Z])');
}