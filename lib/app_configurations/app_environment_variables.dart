class AppEnvironmentVariables {
  static const baseURL = "base-url";
  static const baseWebURL = "base-web-url";
  static const String stripeTokenUrl = "stripe-token-url";
  static const appName = "app-name";
  static const appTitle = "app-title";
  static const debugBannerBoolean = "debug-banner-boolean";
  static const socketUrl = "socket-url";
  static const stripePublishableKey = "stripe-publishable-key";
  static const iOSBundleID = "iOSBundleID";
  static const packageName = "packageName";
  static const encKey = "encKey";
  static const iv = "iv";
  static const googlePlacesAPIKey = "googlePlacesAPIKey";

  //make necessary changes
  static Map<String, dynamic> dev = {
    baseURL: "https://rmnevents.vitec-visual-dev.com:4202/api",
    baseWebURL: "https://rmnevents.vitec-visual-dev.com",
    stripeTokenUrl: "https://api.stripe.com/v1/tokens",
    appName: 'RMN Events DEV',
    debugBannerBoolean: true,
    appTitle: 'DEV',
    socketUrl: 'https://rmnevents.vitec-visual-dev.com:4202',
    stripePublishableKey:
        'pk_test_51NVdbkHEyLP5wJOOPRYDeLILx75oH6jhdmK6nwROaNnsQWfKwPzHFVTjrCpzmip5ebK1znBmwHdcKLud8DC3FSyK00yQF1iWyy',
    iOSBundleID: 'com.rmnevents.dev',
    packageName: 'com.rmnevents.dev',
    encKey: "yKRHgHsvZ4fwblHqcL1WNDuNJ3JLFLVg",
    iv: "yKRHgHsvZ4fwblHq",
    googlePlacesAPIKey: "AIzaSyDSHwBhj9QofoXzgjeKZJ6w5auTuYkFjn8"
  };

  //make necessary changes
  static Map<String, dynamic> prod = {
    baseURL: "https://api.rmnevents.com",
    baseWebURL: "https://rmnevents.com",
    stripeTokenUrl: "https://api.stripe.com/v1/tokens",
    appName: 'RMN Events',
    debugBannerBoolean: false,
    appTitle: 'RMN Events',
    socketUrl: 'https://api.rmnevents.com:4205',
    stripePublishableKey:
        'pk_live_51NVdbkHEyLP5wJOO2civGYBIYczRVuNY2cleOOXLgpiRROzelFhM5lplHZYvrsRTM4fBQjVh1mH0HKJeQIlnYiQV00H7aYG8uc',
    iOSBundleID: 'com.rmnevents',
    packageName: 'com.rmnevents',
    encKey: "yKRHgHsvZ4fwblHqcL1WNDuNJ3JLFLVg",
    iv: "yKRHgHsvZ4fwblHq",
    googlePlacesAPIKey: "AIzaSyDSHwBhj9QofoXzgjeKZJ6w5auTuYkFjn8"
  };
}
