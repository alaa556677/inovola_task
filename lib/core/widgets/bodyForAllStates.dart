import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inovola_task/core/style/colors.dart';
import 'package:inovola_task/core/widgets/loading_widget.dart';
import 'package:inovola_task/core/widgets/text_default.dart';

class BodyForAllStates extends StatelessWidget {
  final bool isLading;
  final bool isError;
  final bool isSuccess;
  final Widget successWidget;
  const BodyForAllStates({
    super.key,
    this.isLading = false,
    this.isError = false,
    this.isSuccess = false,
    required this.successWidget
  });
  @override
  Widget build(BuildContext context) {
    return getBody();
  }

  getBody(){
    if(isLading){
      return const LoadingWidget();
    }else if(isError){
      return Expanded(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: CustomTextWidget(text: "There is An Error", fontSize: 12.sp, fontColor: AppColors.whiteColor,),
        ),
      );
    }else if(isSuccess){
      return successWidget;
    }
  }
}
