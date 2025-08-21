import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inovola_task/core/style/colors.dart';
import '../../../../../core/widgets/image_card_widget.dart';
import '../../../../../core/widgets/set_height_width.dart';
import '../../../../../core/widgets/text_default.dart';
import '../../domain/entities/get_expenses_entity.dart';

class ExpenseCardWidget extends StatelessWidget {
  final GetExpenseEntity getExpenseEntity;
  const ExpenseCardWidget ({super.key, required this.getExpenseEntity});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        border: Border.all(color: AppColors.blackColor.withOpacity(.04)),

        borderRadius: BorderRadius.circular(12.r)
      ),
      child: Row(
        children: [
          const ImageCardWidget(),
          setWidthSpace(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextWidget(
                  text: getExpenseEntity.title,
                  fontSize: 14.sp,
                  fontColor: AppColors.blackColor,
                  fontWeight:  FontWeight.w500,
                ),
                SizedBox(height: 4.h),
                CustomTextWidget(
                  text: getExpenseEntity.body,
                  fontSize: 10.sp,
                  fontColor: AppColors.blackColor,
                  fontWeight:  FontWeight.w300,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomTextWidget(
                text: '-\$ 100',
                fontSize: 14.sp,
                fontColor: AppColors.blackColor,
                fontWeight:  FontWeight.w500,
              ),
              SizedBox(height: 4.h),
              CustomTextWidget(
                text: 'Today 12:00 PM',
                fontSize: 10.sp,
                fontColor: AppColors.blackColor,
                fontWeight:  FontWeight.w300,
              ),
            ],
          )
        ],
      ),
    );
  }
}
