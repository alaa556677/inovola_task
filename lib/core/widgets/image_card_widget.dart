import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../style/colors.dart';

class ImageCardWidget extends StatelessWidget {
  final String? imagePath;
  final bool isProfileImage;
  const ImageCardWidget({
    super.key, 
    this.imagePath,
    this.isProfileImage = false
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48.w,
      height: 48.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isProfileImage ? AppColors.primary.withOpacity(.3) : Colors.blue.withOpacity(.1),
      ),
      child: CachedNetworkImage(
        imageUrl: "sdsd",
        imageBuilder: (context, imageProvider) => Container(
          width: 54.w,
          height: 54.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
          ),
        ),
        placeholder: (context, url) => isProfileImage? Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(image: AssetImage("assets/images/profile.jpg"), fit: BoxFit.cover),
          ),
        ): Icon(
          Icons.shopping_cart,
          size: 24.r,
          color: Colors.grey,
        ),
        errorWidget: (context, url, error) => isProfileImage? Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(image: AssetImage("assets/images/profile.jpg"), fit: BoxFit.cover),
          ),
        ):Icon(
          Icons.shopping_cart,
          size: 24.r,
          color: Colors.grey,
        ),
      ),
      // child: const Icon(Icons.person, color: AppColors.mainColor,),
    );
  }
}
