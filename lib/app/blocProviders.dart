import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/dashboard/presentation/bloc/dashboard_bloc.dart';
import '../features/add_expense/presentation/bloc/addExpense_bloc.dart';
import '../locator.dart';

class AppBlocProviders {
  static List<BlocProvider> providers = [
    BlocProvider<DashboardBloc>(
      create: (context) => locator<DashboardBloc>(),
    ),
    BlocProvider<AddExpenseBloc>(
      create: (context) => locator<AddExpenseBloc>(),
    ),
  ];
}
