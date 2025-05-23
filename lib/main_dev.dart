import 'package:rmnevents/root_app.dart';

import 'imports/app_configurations.dart';
import 'imports/common.dart';

void main() {
  AppEnvironments.setUpEnvironments(Environment.dev);
  mainDelegateForEnvironments();
}
