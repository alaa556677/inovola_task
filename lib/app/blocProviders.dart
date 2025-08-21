import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inovola_task/features/dashboard/presentation/bloc/dashboard_event.dart';
import '../features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:inovola_task/locator.dart' as di;

class AppBlocProviders {
  static List<BlocProvider> get providers => [
    BlocProvider<DashboardBloc>(create: (_) => di.locator< DashboardBloc>()),
    // BlocProvider<ExpenseBloc>(create: (context) => ExpenseBloc()),
    // BlocProvider<CurrencyBloc>(create: (context) => CurrencyBloc()),
    // BlocProvider<FilterBloc>(create: (context) => FilterBloc()),
  ];
}




