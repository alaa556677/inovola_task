import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/failure/failure.dart';
import '../../../../core/services/currency_service.dart';
import '../../../dashboard/domain/entities/expense_entity.dart';
import '../../../dashboard/domain/useCase/add_expense_use_case.dart';

// Events
abstract class ExpenseEvent extends Equatable {
  const ExpenseEvent();

  @override
  List<Object?> get props => [];
}

class AddExpense extends ExpenseEvent {
  final String category;
  final double amount;
  final String currency;
  final DateTime date;
  final String? receiptPath;
  final String? notes;
  final String type;

  const AddExpense({
    required this.category,
    required this.amount,
    required this.currency,
    required this.date,
    this.receiptPath,
    this.notes,
    required this.type,
  });

  @override
  List<Object?> get props =>
      [category, amount, currency, date, receiptPath, notes, type];
}

class SelectCategory extends ExpenseEvent {
  final String category;

  const SelectCategory(this.category);

  @override
  List<Object?> get props => [category];
}

class SelectCurrency extends ExpenseEvent {
  final String currency;

  const SelectCurrency(this.currency);

  @override
  List<Object?> get props => [currency];
}

class UploadReceipt extends ExpenseEvent {
  final String? receiptPath;

  const UploadReceipt(this.receiptPath);

  @override
  List<Object?> get props => [receiptPath];
}

class ValidateForm extends ExpenseEvent {
  final String category;
  final String amount;
  final String currency;
  final DateTime date;

  const ValidateForm({
    required this.category,
    required this.amount,
    required this.currency,
    required this.date,
  });

  @override
  List<Object?> get props => [category, amount, currency, date];
}

// States
abstract class ExpenseState extends Equatable {
  const ExpenseState();

  @override
  List<Object?> get props => [];
}

class ExpenseInitial extends ExpenseState {}

class ExpenseLoading extends ExpenseState {}

class ExpenseSuccess extends ExpenseState {
  final ExpenseEntity expense;

  const ExpenseSuccess(this.expense);

  @override
  List<Object?> get props => [expense];
}

class ExpenseError extends ExpenseState {
  final String errorMessage;

  const ExpenseError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class FormValidationState extends ExpenseState {
  final bool isValid;
  final Map<String, String> errors;

  const FormValidationState({
    required this.isValid,
    required this.errors,
  });

  @override
  List<Object?> get props => [isValid, errors];
}

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final AddExpenseUseCase addExpenseUseCase;
  final CurrencyService currencyService;

  ExpenseBloc({
    required this.addExpenseUseCase,
    required this.currencyService,
  }) : super(ExpenseInitial()) {
    on<ExpenseEvent>((event, emit) async {
      if (event is AddExpense) {
        await _handleAddExpense(event, emit);
      } else if (event is ValidateForm) {
        await _handleValidateForm(event, emit);
      }
    });
  }

  Future<void> _handleAddExpense(AddExpense event, emit) async {
    emit(ExpenseLoading());

    try {
      // Convert amount to USD for storage
      double convertedAmount = event.amount;
      if (event.currency != 'USD') {
        convertedAmount =
            await currencyService.convertToUSD(event.amount, event.currency);
      }

      final expense = ExpenseEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        category: event.category,
        amount: event.amount,
        currency: event.currency,
        convertedAmount: convertedAmount,
        date: event.date,
        receiptPath: event.receiptPath,
        notes: event.notes,
        type: event.type,
      );

      final result = await addExpenseUseCase(expense);
      result.fold(
        (failure) {
          emit(ExpenseError(failure.errorMessage));
        },
        (expense) {
          emit(ExpenseSuccess(expense));
        },
      );
    } catch (e) {
      emit(ExpenseError('Failed to add expense: ${e.toString()}'));
    }
  }

  Future<void> _handleValidateForm(ValidateForm event, emit) async {
    final Map<String, String> errors = {};

    // Validate category
    if (event.category.isEmpty) {
      errors['category'] = 'Category is required';
    }

    // Validate amount
    if (event.amount.isEmpty) {
      errors['amount'] = 'Amount is required';
    } else {
      final amount = double.tryParse(event.amount);
      if (amount == null || amount <= 0) {
        errors['amount'] = 'Please enter a valid amount';
      }
    }

    // Validate currency
    if (event.currency.isEmpty) {
      errors['currency'] = 'Currency is required';
    }

    // Validate date
    if (event.date.isAfter(DateTime.now())) {
      errors['date'] = 'Date cannot be in the future';
    }

    final isValid = errors.isEmpty;
    emit(FormValidationState(isValid: isValid, errors: errors));
  }
}
