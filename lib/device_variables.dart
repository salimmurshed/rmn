import 'dart:io';
import 'imports/common.dart';
import 'imports/services.dart';



final Uri iosUrl = Uri.parse('https://itunes.apple.com/us/app/urbanspoon/id6463011653');
final Uri androidUrl = Uri.parse('https://play.google.com/store/apps/details?id=com.rmnevents');
class DeviceVariables{
  static String deviceType = Platform.isAndroid ? OS.android.name : OS.ios.name;
  static Future<String> deviceToken() async { return await retrieveFcmTokens();}

  static Uri urlLauncher =  Platform.isAndroid ? androidUrl : iosUrl;
}