import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inovola_task/core/style/colors.dart';

class BackgroundColorWidget extends StatelessWidget {
  const BackgroundColorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * .32,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Colors.blue,
                Colors.blueAccent,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius:BorderRadius.only(bottomLeft: Radius.circular(10.r), bottomRight: Radius.circular(10.r))
          ),
        ),
        Positioned(
          top: -10,
          left: 60,
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
          top: -30,
          left: 140,
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

        Positioned(
          bottom: 20,
          right: -60,
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
      ],
    );
  }
}
