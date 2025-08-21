import 'package:equatable/equatable.dart';

abstract class DashboardEvents extends Equatable{
  const DashboardEvents();
  @override
  List<Object?> get props => [];
}
////////////////////////////////////////////////////////////////////////////////
class GetAllExpensesEvents extends DashboardEvents{}
class RefreshAllExpensesEvents extends DashboardEvents{}
