import 'package:inovola_task/features/add_expense/presentation/bloc/addExpense_bloc.dart';

import '../../core/services/currency_service.dart';
import '../../locator.dart';
import 'data/repo_imp/addExpense_repoImp.dart';
import 'domain/repo/addExpense_repo.dart';
import 'domain/useCase/add_expense_use_case.dart';

addExpenseInjection(){
  // bloc
  locator.registerFactory<ExpenseBloc>(() => ExpenseBloc(
      addExpenseUseCase: locator<AddExpenseUseCase>(),
      currencyService: locator<CurrencyService>(),
    ),
  );

  //repo
  locator.registerLazySingleton<AddExpenseRepository>(
        () => AddExpenseRepoImpl(),
  );

  // use case
  locator.registerLazySingleton<AddExpenseUseCase>(() => AddExpenseUseCase(locator()));
}