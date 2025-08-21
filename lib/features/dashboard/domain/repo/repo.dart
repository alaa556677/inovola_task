import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/failure/failure.dart';
import '../entities/get_expenses_entity.dart';

abstract class DashBoardRepo{
  Future <Either<Failure,List<GetExpenseEntity>>> getExpenses(CancelToken? cancelToken);
}

