import 'package:equatable/equatable.dart';

abstract class DashboardEvents extends Equatable {
  const DashboardEvents();

  @override
  List<Object?> get props => [];
}

class GetAllExpensesEvents extends DashboardEvents {
  final String? filterType;
  final int? page;
  final int? limit;

  const GetAllExpensesEvents({
    this.filterType,
    this.page,
    this.limit,
  });

  @override
  List<Object?> get props => [filterType, page, limit];
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
