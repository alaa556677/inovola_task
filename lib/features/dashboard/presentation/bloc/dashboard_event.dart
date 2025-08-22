
import 'package:equatable/equatable.dart';

abstract class DashboardEvents extends Equatable {
  const DashboardEvents();

  @override
  List<Object?> get props => [];
}

class GetAllExpensesEvents extends DashboardEvents {
  final String? filterType;
  final bool isLoadMore;
  const GetAllExpensesEvents({this.filterType, this.isLoadMore = false});

  @override
  List<Object?> get props => [filterType, isLoadMore];
}

class LoadDashboardSummary extends DashboardEvents {
  final String? filterType;

  const LoadDashboardSummary({this.filterType});

  @override
  List<Object?> get props => [filterType];
}

class RefreshAllExpensesEvents extends DashboardEvents {
  final String? filterType;

  const RefreshAllExpensesEvents({this.filterType});

  @override
  List<Object?> get props => [filterType];
}

class ApplyFilter extends DashboardEvents {
  final String filterType;

  const ApplyFilter(this.filterType);

  @override
  List<Object?> get props => [filterType];
}

class AddSingleExpense extends DashboardEvents {
  final String? filterType;

  const AddSingleExpense({this.filterType});

  @override
  List<Object?> get props => [filterType];
}