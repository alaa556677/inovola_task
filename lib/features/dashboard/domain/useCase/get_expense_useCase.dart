import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/failure/failure.dart';
import '../entities/get_expenses_entity.dart';
import '../repo/repo.dart';

class GetExpenseUseCase {
  final DashBoardRepo dashBoardRepo;
  GetExpenseUseCase(this.dashBoardRepo);

  Future <Either<Failure,List<GetExpenseEntity>>> call(CancelToken? cancelToken) async{
    return await dashBoardRepo.getExpenses(cancelToken);
  }
}