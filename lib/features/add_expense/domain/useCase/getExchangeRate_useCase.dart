import '../repo/addExpense_repo.dart';

class GetExchangeRateUseCase {
  final AddExpenseRepository addExpenseRepository;

  GetExchangeRateUseCase(this.addExpenseRepository);

  Future<Map<String, double>> call() async {
    return await addExpenseRepository.getExchangeRates();
  }
}