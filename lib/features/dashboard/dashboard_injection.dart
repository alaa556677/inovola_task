import 'package:get_it/get_it.dart';
import '../../core/services/dio.dart';
import '../../core/services/currency_service.dart';
import 'data/repo_imp/dashboard_repo_impl.dart';
import 'domain/repo/dashboard_repo.dart';
import 'domain/useCase/get_AllExpense_useCase.dart';
import 'domain/useCase/get_expenses_summary_use_case.dart';
import 'presentation/bloc/dashboard_bloc.dart';
import '../add_expense/presentation/bloc/addExpense_bloc.dart';
import 'presentation/bloc/pagination_bloc.dart';

final locator = GetIt.instance;

initDashboardInjection() {
  // Services
  locator.registerLazySingleton<CurrencyService>(
    () => CurrencyService(DioHelper.dio!),
  );

  // Repositories
  locator.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(),
  );

  // Use Cases
  locator.registerLazySingleton<GetExpenseUseCase>(
    () => GetExpenseUseCase(locator<DashboardRepository>()),
  );

  locator.registerLazySingleton<GetExpensesSummaryUseCase>(
    () => GetExpensesSummaryUseCase(locator<DashboardRepository>()),
  );

  // BLoCs
  locator.registerFactory<DashboardBloc>(
    () => DashboardBloc(
      getExpenseUseCase: locator<GetExpenseUseCase>(),
      getExpensesSummaryUseCase: locator<GetExpensesSummaryUseCase>(),
    ),
  );

  locator.registerFactory<PaginationBloc>(
    () => PaginationBloc(),
  );
}
