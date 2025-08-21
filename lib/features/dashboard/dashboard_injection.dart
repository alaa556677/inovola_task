import 'package:inovola_task/features/dashboard/data/repo_imp/repo_imp.dart';
import 'package:inovola_task/features/dashboard/domain/useCase/get_expense_useCase.dart';
import 'package:inovola_task/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:inovola_task/locator.dart';
import 'data/dataSource/dataSource_withDio.dart';
import 'domain/repo/repo.dart';

Future <void> initDashboardInjection() async {
  // bloc
  locator.registerFactory(() => DashboardBloc(getExpenseUseCase: locator()));

  // useCases
  locator.registerLazySingleton<GetExpenseUseCase>(() => GetExpenseUseCase(locator()));

  // repo
  locator.registerLazySingleton<DashBoardRepo>(() => DashBoardRepoImplementation(locator()));

  // data source
  locator.registerLazySingleton<DashboardDataSourceWithDio>(() => DashboardDataSourceWithDio());
}