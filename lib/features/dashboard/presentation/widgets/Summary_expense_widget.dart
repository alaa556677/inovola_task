import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inovola_task/core/style/colors.dart';
import 'package:inovola_task/core/widgets/text_default.dart';

import '../../../../../core/widgets/set_height_width.dart';
import 'background_color_widget.dart';

class SummaryExpenseWidget extends StatelessWidget {
  const SummaryExpenseWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: AppColors.primary
      ),
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
              border: Border.all(color: AppColors.whiteColor.withOpacity(.08), width: 10)
          ),
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
              border: Border.all(color: AppColors.whiteColor.withOpacity(.08), width: 10)
          ),
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
                        const Icon(Icons.keyboard_arrow_up, color: AppColors.whiteColor,)
                      ],
                    ),
                  ),
                  const Icon(Icons.more_horiz, color: AppColors.whiteColor,),
                ],
              ),
              setHeightSpace(4),
              CustomTextWidget(
                text: "\$ 2,548.00",
                fontColor: AppColors.whiteColor,
                fontSize: 18.sp,
              ),
              setHeightSpace(40),
              const Row(
                children: [
                  Expanded(
                    child: SummaryWidget(
                      title: "Income",
                      icon: Icons.arrow_circle_down_outlined,
                      value: "\$ 10,840.00",
                    ),
                  ),
                  SummaryWidget(
                    title: "Expenses",
                    icon: Icons.arrow_circle_up_outlined,
                    value: "\$ 1,844.00",
                  )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
////////////////////////////////////////////////////////////////////////////////
class SummaryWidget extends StatelessWidget{
  final String title;
  final String value;
  final IconData icon;

  const SummaryWidget({
    super.key,
    required this.title,
    required this.value,
    required this.icon
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.whiteColor,),
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