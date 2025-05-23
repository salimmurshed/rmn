import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rmnevents/di/di.dart';
import 'package:rmnevents/imports/services.dart';

import '../../imports/common.dart';
import '../../presentation/find_customer/bloc/find_customer_bloc.dart';
import '../../root_app.dart';

class StaffEventDataSource{
  static Future getStaffEventData(
      {required String id,}) async {
    String? userId = navigatorKey.currentContext!
        .read<FindCustomerBloc>()
        .state
        .selectedCustomer?.underScoreId;
    final String url =
        '${UrlPrefixes.baseUrl}${UrlSuffixes.getStaffEventData(id: id, userId: userId)}';

    dynamic response = await HttpFactoryServices.getMethod(url, header: await setHeader(true));

    return response;
  }
}