import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/dashboard/presentation/bloc/dashboard_bloc.dart';
import '../features/add_expense/presentation/bloc/addExpense_bloc.dart';
import '../features/dashboard/presentation/bloc/pagination_bloc.dart';
import '../locator.dart';

class AppBlocProviders {
  static List<BlocProvider> providers = [
    BlocProvider<DashboardBloc>(
      create: (context) => locator<DashboardBloc>(),
    ),
    BlocProvider<ExpenseBloc>(
      create: (context) => locator<ExpenseBloc>(),
    ),
    BlocProvider<PaginationBloc>(
      create: (context) => locator<PaginationBloc>(),
    ),
  ];
}
