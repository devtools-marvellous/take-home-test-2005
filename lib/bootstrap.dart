import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:take_home_marv/core/services/setup_locator.dart';

Future<void> bootstrap(FutureOr<Widget> Function(GetIt getIt) builder) async {
  setupLocator();

  runApp(await builder(locator));
}
