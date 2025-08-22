import 'package:equatable/equatable.dart';

abstract class DashboardEvents extends Equatable {
  const DashboardEvents();

  @override
  List<Object?> get props => [];
}

class GetAllExpensesEvents extends DashboardEvents {
  final String? filterType;
<<<<<<< HEAD
  final bool isLoadMore;
  const GetAllExpensesEvents({this.filterType, this.isLoadMore = false});

  @override
  List<Object?> get props => [filterType, isLoadMore];
=======
  final int pageKey;

  const GetAllExpensesEvents({
    this.filterType,
    required this.pageKey
  });

  @override
  List<Object?> get props => [filterType, pageKey];
>>>>>>> 176486876e7b4bf114dfed15146c5c2be23792a4
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
