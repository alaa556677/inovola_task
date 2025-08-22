import '../repo/addExpense_repo.dart';

class ConvertToUSDUseCase {
  final AddExpenseRepository addExpenseRepository;

  ConvertToUSDUseCase(this.addExpenseRepository);

  Future<double> call(double amount, String fromCurrency) async {
    return await addExpenseRepository.convertToUSD(amount, fromCurrency);
  }
}