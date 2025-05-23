import Flutter
import UIKit
import GoogleMaps
import Firebase
import FirebaseCore
import FirebaseMessaging
import app_links
@main

@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      FirebaseApp.configure()
      GMSServices.provideAPIKey("AIzaSyB3lT7VHTThngV7d4eLnASs6Ne3ogKPpDU")
    GeneratedPluginRegistrant.register(with: self)
      if let url = AppLinks.shared.getLink(launchOptions: launchOptions) {
           // We have a link, propagate it to your Flutter app or not
           AppLinks.shared.handleLink(url: url)
           return true // Returning true will stop the propagation to other packages
         }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
