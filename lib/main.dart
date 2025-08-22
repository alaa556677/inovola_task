import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app/myApp.dart';
import 'features/add_expense/data/models/expense_model.dart';
import 'locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initInjection();
  await Hive.initFlutter();
  await _registerHiveAdapters();
  runApp(const MyApp());
}

Future<void> _registerHiveAdapters() async {
  Hive.registerAdapter(ExpenseModelAdapter());
}
