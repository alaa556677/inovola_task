import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:inovola_task/core/style/colors.dart';
import '../../../../../core/widgets/image_card_widget.dart';
import '../../../../../core/widgets/set_height_width.dart';
import '../../../../../core/widgets/text_default.dart';
import '../../domain/entities/expense_entity.dart';

class ExpenseCardWidget extends StatelessWidget {
  final ExpenseEntity getExpenseEntity;
  const ExpenseCardWidget({super.key, required this.getExpenseEntity});

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(symbol: '\$');
    final dateFormatter = DateFormat('MMM dd, yyyy');
    final timeFormatter = DateFormat('hh:mm a');

    return Container(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
          color: AppColors.whiteColor,
          border: Border.all(color: AppColors.blackColor.withOpacity(.04)),
          borderRadius: BorderRadius.circular(12.r)),
      child: Row(
        children: [
          getExpenseEntity.receiptPath != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.asset(
                    getExpenseEntity.receiptPath!,
                    width: 50.w,
                    height: 50.h,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const ImageCardWidget(),
                  ),
                )
              : const ImageCardWidget(),
          setWidthSpace(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextWidget(
                  text: getExpenseEntity.category,
                  fontSize: 14.sp,
                  fontColor: AppColors.blackColor,
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(height: 4.h),
                CustomTextWidget(
                  text: getExpenseEntity.notes ?? 'No notes',
                  fontSize: 10.sp,
                  fontColor: AppColors.blackColor,
                  fontWeight: FontWeight.w300,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomTextWidget(
                text:
                    '${getExpenseEntity.type == 'expense' ? '-' : '+'}${currencyFormatter.format(getExpenseEntity.amount)}',
                fontSize: 14.sp,
                fontColor: getExpenseEntity.type == 'expense'
                    ? AppColors.error
                    : AppColors.success,
                fontWeight: FontWeight.w500,
              ),
              SizedBox(height: 4.h),
              CustomTextWidget(
                text:
                    '${dateFormatter.format(getExpenseEntity.date)} ${timeFormatter.format(getExpenseEntity.date)}',
                fontSize: 10.sp,
                fontColor: AppColors.blackColor,
                fontWeight: FontWeight.w300,
              ),
            ],
          )
        ],
      ),
    );
  }
}
