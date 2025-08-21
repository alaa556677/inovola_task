import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inovola_task/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:inovola_task/features/dashboard/presentation/bloc/dashboard_state.dart';
import '../../../../core/services/cancel_token.dart';
import '../../domain/useCase/get_expense_useCase.dart';

class DashboardBloc extends Bloc<DashboardEvents, DashboardStates> with BlocCancelToken<DashboardEvents, DashboardStates>{
  final GetExpenseUseCase getExpenseUseCase;
  DashboardBloc({
    required this.getExpenseUseCase
  }): super(DashBoardInitial()){
    on<DashboardEvents> ((event, emit) async {
      if(event is GetAllExpensesEvents){
        safeEmit(GetAllExpensesLoading(), emit);
        final result = await getExpenseUseCase(cancelToken);
        result.fold((failure){
          safeEmit(GetAllExpensesError(failure.errorMessage), emit);
        },(getExpenses){
          safeEmit(GetAllExpensesSuccess(getExpenses), emit);
        });
      }else if(event is RefreshAllExpensesEvents){}
    });
  }
}