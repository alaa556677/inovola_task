import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inovola_task/core/widgets/image_card_widget.dart';
import 'package:inovola_task/core/widgets/set_height_width.dart';
import 'package:inovola_task/core/widgets/text_default.dart';
import '../../../../core/style/colors.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ImageCardWidget(),
        setHeightSpace(4),
        CustomTextWidget(
          text: "Gas",
          fontSize: 10.sp,
          fontWeight: FontWeight.w300,
        )
      ],
    );
  }
}
////////////////////////////////////////////////////////////////////////////////
class AddCategoryWidget extends StatelessWidget {
  const AddCategoryWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 52.w,
          height: 52.h,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue),
            shape: BoxShape.circle
          ),
          alignment: Alignment.center,
          child: Icon(Icons.add, color: Colors.blue, size: 22.r,),
        ),
        setHeightSpace(4),
        CustomTextWidget(
          text: "Add Category",
          maxLines: 1,
          fontSize: 10.sp,
          fontWeight: FontWeight.w300,
        )
      ],
    );
  }
}