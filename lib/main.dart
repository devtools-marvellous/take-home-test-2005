import 'dart:async';

import 'package:flutter/material.dart';
import 'package:take_home_marv/app.dart';
import 'package:take_home_marv/bootstrap.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  unawaited(
    bootstrap(
      (locator) => App(),
    ),
  );
}
