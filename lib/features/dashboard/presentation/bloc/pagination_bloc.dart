import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/expense_entity.dart';

// Events
abstract class PaginationEvent extends Equatable {
  const PaginationEvent();

  @override
  List<Object?> get props => [];
}

class LoadMoreExpenses extends PaginationEvent {
  final String? filterType;

  const LoadMoreExpenses({this.filterType});

  @override
  List<Object?> get props => [filterType];
}

class ResetPagination extends PaginationEvent {}

class RefreshPagination extends PaginationEvent {
  final String? filterType;

  const RefreshPagination({this.filterType});

  @override
  List<Object?> get props => [filterType];
}

// States
abstract class PaginationState extends Equatable {
  const PaginationState();

  @override
  List<Object?> get props => [];
}

class PaginationInitial extends PaginationState {}

class PaginationLoading extends PaginationState {}

class PaginationLoaded extends PaginationState {
  final List<ExpenseEntity> expenses;
  final bool hasReachedMax;
  final int currentPage;
  final String? currentFilter;

  const PaginationLoaded({
    required this.expenses,
    required this.hasReachedMax,
    required this.currentPage,
    this.currentFilter,
  });

  @override
  List<Object?> get props =>
      [expenses, hasReachedMax, currentPage, currentFilter];

  PaginationLoaded copyWith({
    List<ExpenseEntity>? expenses,
    bool? hasReachedMax,
    int? currentPage,
    String? currentFilter,
  }) {
    return PaginationLoaded(
      expenses: expenses ?? this.expenses,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      currentFilter: currentFilter ?? this.currentFilter,
    );
  }
}

class PaginationError extends PaginationState {
  final String errorMessage;

  const PaginationError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class PaginationBloc extends Bloc<PaginationEvent, PaginationState> {
  static const int _pageSize = 10;

  PaginationBloc() : super(PaginationInitial()) {
    on<PaginationEvent>((event, emit) async {
      if (event is LoadMoreExpenses) {
        await _handleLoadMoreExpenses(event, emit);
      } else if (event is ResetPagination) {
        emit(PaginationInitial());
      } else if (event is RefreshPagination) {
        await _handleRefreshPagination(event, emit);
      }
    });
  }

  Future<void> _handleLoadMoreExpenses(LoadMoreExpenses event, emit) async {
    try {
      if (state is PaginationLoaded) {
        final currentState = state as PaginationLoaded;

        if (currentState.hasReachedMax) {
          return; // Already at max
        }

        // Check if filter changed
        if (currentState.currentFilter != event.filterType) {
          // Reset pagination for new filter
          emit(PaginationInitial());
          return;
        }

        // Load next page
        final nextPage = currentState.currentPage + 1;
        // This would typically call a repository method with pagination
        // For now, we'll simulate pagination

        emit(PaginationLoaded(
          expenses: currentState
              .expenses, // In real implementation, this would append new expenses
          hasReachedMax:
              false, // This would be determined by the repository response
          currentPage: nextPage,
          currentFilter: event.filterType,
        ));
      } else {
        // Initial load
        emit(PaginationLoaded(
          expenses: [], // Initial empty list
          hasReachedMax: false,
          currentPage: 0,
          currentFilter: event.filterType,
        ));
      }
    } catch (e) {
      emit(PaginationError('Failed to load more expenses: ${e.toString()}'));
    }
  }

  Future<void> _handleRefreshPagination(RefreshPagination event, emit) async {
    try {
      emit(PaginationInitial());
      // Trigger initial load
      add(LoadMoreExpenses(filterType: event.filterType));
    } catch (e) {
      emit(PaginationError('Failed to refresh pagination: ${e.toString()}'));
    }
  }
}
