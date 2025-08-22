import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/cancel_token.dart';
import '../../../../core/services/currency_service.dart';
import '../../domain/entities/expense_entity.dart';
import '../../domain/useCase/add_expense_use_case.dart';
import 'addExpense_event.dart';
import 'addExpense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> with BlocCancelToken<ExpenseEvent, ExpenseState>{
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
////////////////////////////////////////////////////////////////////////////////
  Future<void> _handleAddExpense(AddExpense event, emit) async {
    safeEmit(AddExpenseLoading(), emit);
    try {
      double convertedAmount = event.amount;
      if (event.currency != 'USD') {
        convertedAmount = await currencyService.convertToUSD(event.amount, event.currency);
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
          safeEmit(AddExpenseError(failure.errorMessage), emit);
        },
        (expense) {
          safeEmit(AddExpenseSuccess(expense), emit);
        },
      );
    } catch (e) {
      safeEmit(AddExpenseError(e.toString()), emit);
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
