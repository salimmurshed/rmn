import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:rmnevents/common/resources/app_routes.dart';
import 'package:http/http.dart' as http;
import '../../root_app.dart';

class ResetPasswordDynamicLinkServices {

  static Future<String?> extractUrlBasedOnOS({required dynamic deeplink}) async {
    if (deeplink == null){
      return null;
    }else{
      if (Platform.isIOS){
        String? fullUrl = await resolveDynamicLink(deeplink.toString());
        return await getLongUri(fullUrl.toString());
      }else{
        return await getLongUri(deeplink.toString());
      }
    }
  }

  static Future<String?> resolveDynamicLink(String shortUrl) async {
    try {
      // Create an HttpClient instance
      final client = HttpClient();
      //client.followRedirects = false; // We want to handle redirects manually
      // Open the URL
      final request = await client.getUrl(Uri.parse(shortUrl));
      final response = await request.close();
      // Check if the response is a redirect
      return response.redirects[0].location.toString(); // Return the original URL if no redirection
    } catch (e) {
      print("Error resolving dynamic link: $e");
      return null;
    }
  }
  //from a terminated state step 1: collect pending data and check if it is nul inside splash global_bloc for different userTypes
  static Future<Uri?> resetDynamicLinkFromTerminatedState() async {
    Uri? initialLink = await AppLinks().getInitialLink();
    return initialLink;
  }

  //from a terminated state step 2-- if pending data is not null, call this
  static  void resetDynamicLinkObtainedFromTerminatedState({required Uri deepLink}) async {
    debugPrint("Terminated");
    final resolvedUri = await extractUrlBasedOnOS(deeplink: deepLink);

    debugPrint("resolvedUri=> $resolvedUri");
    if (resolvedUri != null) {
      print('Expanded URL: $resolvedUri');
      // final uri = Uri.parse(resolvedUri);
      final uri = Uri.parse(Platform.isIOS ? resolvedUri : deepLink.toString());

      // Extract the 'token' query parameter
      String token =  uri.queryParameters['token'] ?? '';
      debugPrint("Token: $token");
      extractUrlToNavigate(token: token);
    } else {
      print('Failed to expand URL.');
    }
    // extractUrlToNavigate(deepLink: deepLink);
  }

  //open, or in the background -- here pending data is never null
  static Future<String?> resetDynamicLinkOnBackgroundOrForeground()
  async {
    final appLinks = AppLinks(); // AppLinks is singleton
    String? deepLinkExtracted;
    appLinks.uriLinkStream.listen((deepLink) async {
      debugPrint("deepLinkFromServer form_terminated--> $deepLink and\nPath is ${deepLink.path}");

      final resolvedUri = await extractUrlBasedOnOS(deeplink: deepLink);
      deepLinkExtracted = resolvedUri;
      debugPrint("resolvedUri=> $resolvedUri");
      if (resolvedUri != null) {
        print('Expanded URL: $resolvedUri');
        // final uri = Uri.parse(resolvedUri);
        final uri = Uri.parse(deepLink.toString());
        // Extract the 'token' query parameter
        String token = uri.queryParameters['token'] ?? '';
        debugPrint("Token: $token");
        extractUrlToNavigate(token: token);
      } else {
        print('Failed to expand URL.');
      }

    }, onError: (e) {
      debugPrint('onLinkError');
      debugPrint(e.email);
    });
    return deepLinkExtracted;
  }

  static Future<String?> getLongUri(String shortUrl) async {
    try {
      // Send a GET request to fetch the full response
      final response = await http.get(Uri.parse(shortUrl));

      if (response.statusCode == 200) {
        // Print the response body for debugging
        print('Response Body: ${response.body}');

        // Example: Extract the long URI from the response body
        if (Platform.isIOS){
          return shortUrl;
        }else{
          final longUri = extractLongUriFromBody(response.body);
          return longUri;
        }
      } else {
        print('Failed to fetch content. Status Code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error resolving short URI: $e');
      return null;
    }
  }

  static String? extractLongUriFromBody(String body) {
    // Example: Adjust this logic based on your server's response format.
    final uriPattern = RegExp(r'https?://[^\s"]+');
    final match = uriPattern.firstMatch(body);
    return match?.group(0);
  }
}

extractUrlToNavigate({required String token}) {
  Navigator.pushNamedAndRemoveUntil(navigatorKey.currentState!.context,
      AppRouteNames.routeResetPassword, (route) => false,
      arguments: token);
}

