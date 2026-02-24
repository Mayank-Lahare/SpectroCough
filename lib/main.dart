import 'package:flutter/material.dart';
import 'app.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'models/prediction_result.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(PredictionResultsAdapter());
  await Hive.openBox<PredictionResults>('historyBox');

  runApp(const SpectroCoughApp());
}
