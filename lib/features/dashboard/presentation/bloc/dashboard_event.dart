import 'package:equatable/equatable.dart';

abstract class DashboardEvents extends Equatable {
  const DashboardEvents();
  @override
  List<Object?> get props => [];
}
////////////////////////////////////////////////////////////////////////////////
class GetAllExpensesEvents extends DashboardEvents {
  final int page;
  final int pageSize;
  final String? filterType;
  const GetAllExpensesEvents({
    required this.page,
    required this.pageSize,
    this.filterType,
  });
  @override
  List<Object?> get props => [page, pageSize, filterType];
}
////////////////////////////////////////////////////////////////////////////////
class LoadDashboardSummary extends DashboardEvents {
  final String? filterType;
  const LoadDashboardSummary({this.filterType});
  @override
  List<Object?> get props => [filterType];
}
////////////////////////////////////////////////////////////////////////////////
class RefreshAllExpensesEvents extends DashboardEvents {
  final String? filterType;
  const RefreshAllExpensesEvents({this.filterType});
  @override
  List<Object?> get props => [filterType];
}
////////////////////////////////////////////////////////////////////////////////
class ApplyFilter extends DashboardEvents {
  final String filterType;
  const ApplyFilter(this.filterType);
  @override
  List<Object?> get props => [filterType];
}
////////////////////////////////////////////////////////////////////////////////
