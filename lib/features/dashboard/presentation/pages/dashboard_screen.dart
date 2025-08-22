import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:inovola_task/core/widgets/set_height_width.dart';
import 'package:inovola_task/core/widgets/text_default.dart';
import 'package:inovola_task/features/dashboard/presentation/bloc/dashboard_state.dart';
import '../../../../core/style/colors.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../add_expense/domain/entities/expense_entity.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../widgets/Summary_expense_widget.dart';
import '../widgets/background_color_widget.dart';
import '../widgets/expense_card_widget.dart';
import '../widgets/user_pic_widget.dart';
import '../widgets/export_dialog.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final PagingController<int, ExpenseEntity> _pagingController =
  PagingController(firstPageKey: 0);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) async {
      // ⏳ delay قبل تحميل أي صفحة جديدة
      await Future.delayed(const Duration(seconds: 1));
      context.read<DashboardBloc>().add(GetAllExpensesEvents(
        filterType: "All",
        pageKey: pageKey,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DashboardBloc, DashboardStates>(
      listener: (context, state) {
      if (state is GetAllExpensesSuccess) {
        final isLastPage = state.expensesList.length < 10; // 10 = limit
        if (isLastPage) {
          _pagingController.appendLastPage(state.expensesList);
        } else {
          final nextPageKey = (_pagingController.nextPageKey ?? 0) + 1;
          // علشان تبين تجربة التحميل
          Future.delayed(const Duration(seconds: 1));
          _pagingController.appendPage(state.expensesList, nextPageKey);
        }
      } else if (state is GetAllExpensesError) {
        _pagingController.error = state.errorMessage;
      }
      },
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: Stack(
          children: [
            const BackgroundColorWidget(),
            Padding(
              padding: EdgeInsetsDirectional.only(
                  start: 20.w,
                  end: 20.w,
                  top: MediaQuery.of(context).size.height * .05,
                  bottom: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const UserPicWidget(),
                  setHeightSpace(30),
                  const SummaryExpenseWidget(),
                  setHeightSpace(30),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextWidget(
                          text: "Recent Expenses",
                          fontSize: 14.sp,
                          fontColor: AppColors.blackColor,
                        ),
                      ),
                      InkWell(
                        onTap: () => _showExportDialog(context),
                        child: CustomTextWidget(
                          text: "export",
                          fontSize: 12.sp,
                          fontColor: AppColors.blackColor,
                        ),
                      ),
                      setWidthSpace(18),
                      CustomTextWidget(
                        text: "see all",
                        fontSize: 12.sp,
                        fontColor: AppColors.blackColor,
                      ),
                    ],
                  ),
                  setHeightSpace(6),
                  Expanded(
                    child: BlocBuilder<DashboardBloc, DashboardStates>(
                      buildWhen: (previous, current) {
                        return current is GetAllExpensesLoading ||
                            current is GetAllExpensesSuccess ||
                            current is GetAllExpensesError;
                      },
                      builder: (context, state) => PagedListView<int, ExpenseEntity>(
                        pagingController: _pagingController,
                        builderDelegate: PagedChildBuilderDelegate<ExpenseEntity>(
                          itemBuilder: (context, item, index) =>
                              ExpenseCardWidget(getExpenseEntity: item),
                          firstPageProgressIndicatorBuilder: (_) =>
                          const Center(child: LoadingWidget()),
                          newPageProgressIndicatorBuilder: (_) =>
                          const Center(child: LoadingWidget()),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          onPressed: () async {
            final result = await Navigator.pushNamed(context, "/add-expense");
            if (result == true) {
              context
                  .read<DashboardBloc>()
                  .add(const LoadDashboardSummary(filterType: 'This Month'));
            }
          },
          backgroundColor: Colors.blue,
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 24,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          color: AppColors.whiteColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SvgPicture.asset(
                "assets/images/home.svg",
                width: 24.w,
                height: 24.h,
                color: Colors.blue,
              ),
              SvgPicture.asset(
                "assets/images/bar.svg",
                width: 24.w,
                height: 24.h,
              ),
              const Visibility(visible: false, child: SizedBox()),
              SvgPicture.asset(
                "assets/images/money.svg",
                width: 24.w,
                height: 24.h,
              ),
              SvgPicture.asset(
                "assets/images/user.svg",
                width: 24.w,
                height: 24.h,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showExportDialog(BuildContext context) {
    final bloc = context.read<DashboardBloc>();
    final currentState = bloc.state;

    if (bloc.expensesList.isNotEmpty) {
      double totalBalance = 0;
      double totalIncome = 0;
      double totalExpenses = 0;

      for (final expense in bloc.expensesList) {
        if (expense.type == 'income') {
          totalIncome += expense.convertedAmount;
        } else {
          totalExpenses += expense.convertedAmount;
        }
      }
      totalBalance = totalIncome - totalExpenses;

      showDialog(
        context: context,
        builder: (context) => ExportDialog(
          expenses: bloc.expensesList,
          filterType: bloc.filterType ?? 'All',
          totalBalance: totalBalance,
          totalIncome: totalIncome,
          totalExpenses: totalExpenses,
        ),
      );
    } else {
      if (currentState is GetAllExpensesLoading) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please wait for expenses to load before exporting'),
            backgroundColor: AppColors.warning,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No expenses found to export'),
            backgroundColor: AppColors.warning,
          ),
        );
      }
    }
  }
}
