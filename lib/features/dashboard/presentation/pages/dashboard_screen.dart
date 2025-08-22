import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inovola_task/core/widgets/set_height_width.dart';
import 'package:inovola_task/core/widgets/text_default.dart';
import 'package:inovola_task/features/dashboard/presentation/bloc/dashboard_state.dart';
import '../../../../core/style/colors.dart';
import '../../../../core/widgets/loading_widget.dart';
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
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        Future.delayed(Duration(seconds: 2), (){
          context.read<DashboardBloc>().add(const GetAllExpensesEvents(isLoadMore: true),);
        });
      }
    });
    context.read<DashboardBloc>().add(const GetAllExpensesEvents(filterType: 'This Month'));
    context.read<DashboardBloc>().add(const LoadDashboardSummary(filterType: 'This Month'));
  }

  Future<void> _refreshData() async {
    context.read<DashboardBloc>().add(const GetAllExpensesEvents(filterType: 'This Month'));
    context.read<DashboardBloc>().add(const LoadDashboardSummary(filterType: 'This Month'));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DashboardBloc, DashboardStates>(
      listener: (context, state) {},
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
                        // Rebuild when expenses state changes
                        return current is GetAllExpensesLoading ||
                            current is GetAllExpensesSuccess ||
                            current is GetAllExpensesError;
                      },
                      builder: (context, state) {
                        if (state is GetAllExpensesLoading &&  context.read<DashboardBloc>().expensesList.isEmpty) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        if (state is GetAllExpensesError) {
                          return Center(child: Text("Error: ${state.errorMessage}"));
                        }

                        if (state is GetAllExpensesSuccess) {
                          return ListView.separated(
                            controller: _scrollController,
                            separatorBuilder: (context, index) => setHeightSpace(12),
                            itemCount: state.hasMore == true
                                ? state.expensesList.length + 1
                                : state.expensesList.length,
                            itemBuilder: (context, index) {
                              if (index < state.expensesList.length) {
                                final expense = state.expensesList[index];
                                return ExpenseCardWidget(getExpenseEntity: expense);
                              } else {
                                return const Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Center(child: CircularProgressIndicator()),
                                );
                              }
                            },
                          );
                        }

                        return const SizedBox();
                      },

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
                  .add(const GetAllExpensesEvents(filterType: 'This Month'));
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
    // Check if we have expenses data first
    final bloc = context.read<DashboardBloc>();
    final currentState = bloc.state;

    // Check if we have expenses data
    if (bloc.expensesList.isNotEmpty) {
      double totalBalance = 0;
      double totalIncome = 0;
      double totalExpenses = 0;

      // Calculate basic summary from expenses if summary not loaded
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
    }else{
      if (currentState is GetAllExpensesLoading) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please wait for expenses to load before exporting'),
            backgroundColor: AppColors.warning,
          ),
        );
      }else{
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
