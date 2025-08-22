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

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
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
                        onTap: (){},
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
                        if (state is GetAllExpensesLoading) {
                          return const LoadingWidget();
                        } else if (state is GetAllExpensesSuccess) {
                          return RefreshIndicator(
                            onRefresh: _refreshData,
                            child: state.expensesList.isEmpty
                                ?Center(
                                    child: CustomTextWidget(text: 'No expenses found', fontSize: 14.sp,),
                            ):ListView.separated(
                              itemBuilder: (context, index) {
                                final expense = state.expensesList[index];
                                return ExpenseCardWidget(
                                  getExpenseEntity: expense,
                                );
                              },
                              itemCount: state.expensesList.length, separatorBuilder: (context, index) => setHeightSpace(10),
                            ),
                          );
                        } else if (state is GetAllExpensesError) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomTextWidget(text: 'Error: ${state.errorMessage}', fontSize: 14.sp,),
                                ElevatedButton(
                                  onPressed: _refreshData,
                                  child: CustomTextWidget(text: 'Retry', fontSize: 12.sp,),
                                ),
                              ],
                            ),
                          );
                        } else {
                          // Show loading for other states
                          return const LoadingWidget();
                        }
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
              context.read<DashboardBloc>().add(const GetAllExpensesEvents(filterType: 'This Month'));
              context.read<DashboardBloc>().add(const LoadDashboardSummary(filterType: 'This Month'));
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
}
