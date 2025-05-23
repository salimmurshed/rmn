import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:http/http.dart' as http;
import 'package:rmnevents/root_app.dart';
import 'package:url_launcher/url_launcher.dart';

class ForceUpdateChecker {
  static const String appId = '6447569654'; // Replace with your App Store ID

  static Future<String?> getLatestVersion() async {
    try {
      final url = Uri.parse("https://itunes.apple.com/lookup?id=$appId");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if ((jsonData['resultCount'] ?? 0) > 0) {
          String latestVersion = jsonData['results'][0]['version'];
          print("Latest version from App Store: $latestVersion");
          return latestVersion;
        }
      }
    } catch (e) {
      print("Error fetching latest version: $e");
    }
    return null;
  }

  static Future<String> getInstalledVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    print("Installed app version: ${packageInfo.version}");
    return packageInfo.version;
  }

  static Future<void> checkForUpdate(BuildContext context) async {
    final latestVersion = await getLatestVersion();
    final installedVersion = await getInstalledVersion();

    if (latestVersion != null && _isOutdated(installedVersion, latestVersion)) {
      _showUpdateDialog(navigatorKey.currentContext!);
    } else {
      print("No update required.");
    }
  }

  static bool _isOutdated(String currentVersion, String latestVersion) {
    List<int> currentParts = currentVersion.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    List<int> latestParts = latestVersion.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    int maxLength = latestParts.length > currentParts.length ? latestParts.length : currentParts.length;

    for (int i = 0; i < maxLength; i++) {
      int current = (i < currentParts.length) ? currentParts[i] : 0;
      int latest = (i < latestParts.length) ? latestParts[i] : 0;

      if (current < latest) return true; // Update required
      if (current >= latest) return false; // Already up-to-date
    }

    return false; // Same version, no update needed
  }

  static void _showUpdateDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing
      builder: (context) => AlertDialog(
        title: const Text("Update Required"),
        content: const Text("A new version of the app is available. Please update to continue."),
        actions: [
          TextButton(
            onPressed: () => _launchAppStore(),
            child: const Text("Update Now"),
          ),
        ],
      ),
    );
  }

  static void _launchAppStore() async {
    final url = "https://apps.apple.com/app/id$appId";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }
}
