import 'package:flutter/material.dart';

import 'app/app.dart';
import 'database/database_helper.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper().database;

  FlutterError.onError = (details) {
    debugPrint("Error no controlado: ${details.exception}");
  };

  runApp(const App());
}
