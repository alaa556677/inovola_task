import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inovola_task/core/style/colors.dart';
import 'package:inovola_task/core/widgets/text_default.dart';
import '../../../../../core/widgets/set_height_width.dart';
import '../bloc/dashboard_state.dart';
import '../bloc/dashboard_bloc.dart';

class SummaryExpenseWidget extends StatelessWidget {
  const SummaryExpenseWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardStates>(
      buildWhen: (previous, current) {
        // Rebuild when summary states change or when expenses change (to update calculated summary)
        return current is DashboardSummaryLoaded ||
            current is DashboardSummaryLoading ||
            current is GetAllExpensesSuccess ||
            current is GetAllExpensesLoading;
      },
      builder: (context, state) {
        double totalBalance = 0.0;
        double totalIncome = 0.0;
        double totalExpenses = 0.0;
        bool isLoading = false;

        if (state is DashboardSummaryLoaded) {
          totalBalance = state.totalBalance;
          totalIncome = state.totalIncome;
          totalExpenses = state.totalExpenses;
        } else if (state is DashboardSummaryLoading) {
          isLoading = true;
        } else {
          // Use stored summary data if available, otherwise calculate from expenses
          final bloc = context.read<DashboardBloc>();
          if (bloc.lastTotalBalance != 0.0 ||
              bloc.lastTotalIncome != 0.0 ||
              bloc.lastTotalExpenses != 0.0) {
            // Use stored summary data
            totalBalance = bloc.lastTotalBalance;
            totalIncome = bloc.lastTotalIncome;
            totalExpenses = bloc.lastTotalExpenses;
          } else if (bloc.expensesList.isNotEmpty) {
            // Calculate from expenses as fallback
            for (final expense in bloc.expensesList) {
              if (expense.type == 'income') {
                totalIncome += expense.convertedAmount;
              } else {
                totalExpenses += expense.convertedAmount;
              }
            }
            totalBalance = totalIncome - totalExpenses;
          }
        }

        return Container(
          padding:
              EdgeInsetsDirectional.symmetric(horizontal: 14.w, vertical: 14.h),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              color: AppColors.primary),
          child: Stack(
            children: [
              Positioned(
                bottom: -20,
                right: 20,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                      border: Border.all(
                          color: AppColors.whiteColor.withOpacity(.08),
                          width: 10)),
                ),
              ),
              Positioned(
                bottom: -30,
                right: -20,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                      border: Border.all(
                          color: AppColors.whiteColor.withOpacity(.08),
                          width: 10)),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            CustomTextWidget(
                              text: "Total Balance",
                              fontSize: 10.sp,
                              fontColor: AppColors.whiteColor,
                            ),
                            const Icon(
                              Icons.keyboard_arrow_up,
                              color: AppColors.whiteColor,
                            )
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.more_horiz,
                        color: AppColors.whiteColor,
                      ),
                    ],
                  ),
                  setHeightSpace(4),
                  CustomTextWidget(
                    text: isLoading
                        ? "Loading ..."
                        : "\$ ${totalBalance.toStringAsFixed(2)}",
                    fontColor: AppColors.whiteColor,
                    fontSize: 18.sp,
                  ),
                  setHeightSpace(50),
                  Row(
                    children: [
                      Expanded(
                        child: SummaryWidget(
                          title: "Income",
                          icon: Icons.arrow_circle_down_outlined,
                          value: isLoading
                              ? "..."
                              : "\$ ${totalIncome.toStringAsFixed(2)}",
                        ),
                      ),
                      SummaryWidget(
                        title: "Expenses",
                        icon: Icons.arrow_circle_up_outlined,
                        value: isLoading
                            ? "..."
                            : "\$ ${totalExpenses.toStringAsFixed(2)}",
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class SummaryWidget extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const SummaryWidget(
      {super.key,
      required this.title,
      required this.value,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: AppColors.whiteColor,
            ),
            setWidthSpace(2),
            CustomTextWidget(
              text: title,
              fontSize: 10.sp,
              fontColor: AppColors.whiteColor,
            ),
          ],
        ),
        setHeightSpace(4),
        CustomTextWidget(
          text: value,
          fontColor: AppColors.whiteColor,
          fontSize: 14.sp,
        ),
      ],
    );
  }
}
