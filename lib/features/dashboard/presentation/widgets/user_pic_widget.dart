import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/style/colors.dart';
import '../../../../../core/widgets/image_card_widget.dart';
import '../../../../../core/widgets/set_height_width.dart';
import '../../../../../core/widgets/text_default.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';

class UserPicWidget extends StatefulWidget {
  const UserPicWidget({super.key});
  @override
  State<UserPicWidget> createState() => _UserPicWidgetState();
}

class _UserPicWidgetState extends State<UserPicWidget> {
  String selectedDateFilter = 'This Month';
  @override
  Widget build(BuildContext context) {
    return Row(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ImageCardWidget(isProfileImage: true,),
        setWidthSpace(12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextWidget(
                text: 'Good Morning',
                fontSize: 10.sp,
                fontColor: AppColors.whiteColor,
                fontWeight:  FontWeight.w400,
              ),
              SizedBox(height: 4.h),
              CustomTextWidget(
                text: 'Shihab Rahman',
                fontSize: 12.sp,
                fontColor: AppColors.whiteColor,
                fontWeight:  FontWeight.w600,
              ),
            ],
          ),
        ),
        Expanded(
          child: DropdownButtonFormField2(
            value: selectedDateFilter,
            isExpanded: true,
            dropdownStyleData: DropdownStyleData(
              offset: const Offset(0, -5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              padding: EdgeInsets.zero
            ),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 2.w),
              constraints: BoxConstraints(maxHeight: 36.h),
              filled: true,
              fillColor: Theme.of(context).cardColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide.none
              )
            ),
            items: [
              'This Month',
              'Last 7 Days',
              'Last 30 Days',
              'Custom Range',
            ].map((item) => DropdownMenuItem<String>(
              value: item,
              child: CustomTextWidget(text: item, fontSize: 10.sp, textOverflow: TextOverflow.ellipsis,),
            )).toList(),
            onChanged: (value) {
              setState(() {
                selectedDateFilter = value!;
                context.read<DashboardBloc>().add(ApplyFilter(value));
              });
            },
          ),
        )
      ],
    );
  }
}
