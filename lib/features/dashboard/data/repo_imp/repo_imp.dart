import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:inovola_task/features/dashboard/domain/entities/get_expenses_entity.dart';
import '../../../../core/failure/failure.dart';
import '../../domain/repo/repo.dart';
import '../dataSource/dataSource_withDio.dart';

class DashBoardRepoImplementation implements DashBoardRepo{
  final DashboardDataSourceWithDio dashboardDataSourceWithDio;
  DashBoardRepoImplementation(
    this.dashboardDataSourceWithDio
  );
  @override
  Future<Either<Failure, List<GetExpenseEntity>>> getExpenses(CancelToken? cancelToken) async {
    try {
      return Right(await dashboardDataSourceWithDio.getAllExpenses(cancelToken));
    } catch (e) {
      if(e is DioException && CancelToken.isCancel(e)){
        return Left(Failure(e.toString()));
      }else{
        return Left(Failure(e.toString()));
      }
    }
  }

}