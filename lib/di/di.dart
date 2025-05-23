import 'package:get_it/get_it.dart';
import 'package:rmnevents/services/shared_preferences_services/app_data.dart';
import 'package:rmnevents/services/shared_preferences_services/athlete_cached_data.dart';
import 'package:rmnevents/services/shared_preferences_services/history_cached_data.dart';
import 'package:rmnevents/services/shared_preferences_services/staff_event_cached_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../imports/services.dart';
import '../services/shared_preferences_services/pop_up_cached_data.dart';
import '../services/shared_preferences_services/stripe_reader_cached_data.dart';

final instance = GetIt.instance;

initAppModule() async {
  // Register your global services and blocs here
  SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
  instance.registerLazySingleton<HttpConnectionInfoServices>(() => HttpConnectionEstablishment());
  instance.registerLazySingleton<SharedPreferences>(() => sharedPrefs);
  instance.registerLazySingleton<UserCachedData>(() => UserCachedData(instance()));
  instance.registerLazySingleton<AthleteCachedData>(() => AthleteCachedData(instance()));
  instance.registerLazySingleton<HistoryCachedData>(() => HistoryCachedData(instance()));
  instance.registerLazySingleton<PopUpCachedData>(() => PopUpCachedData(instance()));
  instance.registerLazySingleton<StripeReaderCachedData>(() => StripeReaderCachedData(instance()));
  instance.registerLazySingleton<StaffEventCachedData>(() => StaffEventCachedData(instance()));
  instance.registerLazySingleton<AppData>(() => AppData(instance()));
}