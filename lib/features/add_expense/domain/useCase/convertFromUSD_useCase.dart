import '../repo/addExpense_repo.dart';

class ConvertFromUSDUseCase {
  final AddExpenseRepository addExpenseRepository;

  ConvertFromUSDUseCase(this.addExpenseRepository);

  Future<double> call(double amount, String fromCurrency) async {
    return await addExpenseRepository.convertFromUSD(amount, fromCurrency);
  }
}