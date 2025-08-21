import 'package:get_it/get_it.dart';
import '../../core/services/dio.dart';
import '../../core/services/currency_service.dart';
import 'data/repo_imp/expense_repo_impl.dart';
import 'domain/repo/expense_repo.dart';
import 'domain/useCase/get_expense_useCase.dart';
import 'domain/useCase/add_expense_use_case.dart';
import 'domain/useCase/get_expenses_summary_use_case.dart';
import 'presentation/bloc/dashboard_bloc.dart';
import '../add_expense/presentation/bloc/expense_bloc.dart';
import 'presentation/bloc/pagination_bloc.dart';

final locator = GetIt.instance;

initDashboardInjection() {
  // Services
  locator.registerLazySingleton<CurrencyService>(
    () => CurrencyService(DioHelper.dio!),
  );

  // Repositories
  locator.registerLazySingleton<ExpenseRepository>(
    () => ExpenseRepositoryImpl(),
  );

  // Use Cases
  locator.registerLazySingleton<GetExpenseUseCase>(
    () => GetExpenseUseCase(locator<ExpenseRepository>()),
  );

  locator.registerLazySingleton<AddExpenseUseCase>(
    () => AddExpenseUseCase(locator<ExpenseRepository>()),
  );

  locator.registerLazySingleton<GetExpensesSummaryUseCase>(
    () => GetExpensesSummaryUseCase(locator<ExpenseRepository>()),
  );

  // BLoCs
  locator.registerFactory<DashboardBloc>(
    () => DashboardBloc(
      getExpenseUseCase: locator<GetExpenseUseCase>(),
      getExpensesSummaryUseCase: locator<GetExpensesSummaryUseCase>(),
    ),
  );

  locator.registerFactory<ExpenseBloc>(
    () => ExpenseBloc(
      addExpenseUseCase: locator<AddExpenseUseCase>(),
      currencyService: locator<CurrencyService>(),
    ),
  );

  locator.registerFactory<PaginationBloc>(
    () => PaginationBloc(),
  );
}
