import 'package:inovola_task/features/add_expense/presentation/bloc/addExpense_bloc.dart';

import '../../core/services/currency_service.dart';
import '../../locator.dart';
import 'data/dataSource/local/getCache_dataSource.dart';
import 'data/dataSource/local/local_dataSource.dart';
import 'data/dataSource/remote/getCurrency_dataSource.dart';
import 'data/dataSource/remote/remote_dataSource.dart';
import 'data/repo_imp/addExpense_repoImp.dart';
import 'domain/repo/addExpense_repo.dart';
import 'domain/useCase/add_expense_use_case.dart';
import 'domain/useCase/convertFromUSD_useCase.dart';
import 'domain/useCase/convertToUSD_useCase.dart';
import 'domain/useCase/getExchangeRate_useCase.dart';

addExpenseInjection(){
  // bloc
  locator.registerFactory<AddExpenseBloc>(() => AddExpenseBloc(
    addExpenseUseCase: locator<AddExpenseUseCase>(),
    // currencyService: locator<CurrencyService>(),
    convertFromUSDUseCase: locator<ConvertFromUSDUseCase>(),
    convertToUSDUseCase: locator<ConvertToUSDUseCase>(),
    getExchangeRateUseCase: locator<GetExchangeRateUseCase>()
  ));

  //repo
  locator.registerLazySingleton<AddExpenseRepository>(() => AddExpenseRepoImpl(locator(), locator()));

  // use case
  locator.registerLazySingleton<AddExpenseUseCase>(() => AddExpenseUseCase(locator()));
  locator.registerLazySingleton<ConvertFromUSDUseCase>(() => ConvertFromUSDUseCase(locator()));
  locator.registerLazySingleton<ConvertToUSDUseCase>(() => ConvertToUSDUseCase(locator()));
  locator.registerLazySingleton<GetExchangeRateUseCase>(() => GetExchangeRateUseCase(locator()));

  // data source
  locator.registerLazySingleton<CurrencyLocalDataSource>(() => CurrencyLocalDataSourceImpl());
  locator.registerLazySingleton<CurrencyRemoteDataSource>(() => GetCurrencyDatasource(locator()));
}