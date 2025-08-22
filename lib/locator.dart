import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'core/constants/bloc_observer.dart';
import 'core/services/dio.dart';
import 'core/utils/cache_helper.dart';
import 'features/add_expense/addExpense_injection.dart';
import 'features/dashboard/dashboard_injection.dart';

final locator = GetIt.instance;

initInjection() async {
  DioHelper.init();
  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();
  initDashboardInjection();
  addExpenseInjection();
}