import 'package:get_it/get_it.dart';

import '../../di/di.dart';
import '../../imports/services.dart';

// class RepositoryDependencies{
//   static final HttpConnectionInfoServices httpConnectionInfo =
//   instance<HttpConnectionInfoServices>();
//   static final UserCachedData userCachedData = instance<UserCachedData>();
// }

class RepositoryDependencies {
  static HttpConnectionInfoServices get httpConnectionInfo =>
      instance<HttpConnectionInfoServices>();
  static UserCachedData get userCachedData =>
      instance<UserCachedData>();
}

