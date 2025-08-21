import 'package:flutter/material.dart';

class CustomTextWidget extends StatelessWidget {
  final String? text;
  final TextStyle? textStyle;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? textOverflow;
  final Color? fontColor;
  final String? fontFamily;
  final FontWeight? fontWeight;
  final double? fontSize;
  final TextDecoration? textDecoration;
  final Color? decorationColor;
  final double? height;
  final TextStyle? constTextStyle;

  const CustomTextWidget({
    required this.text,
    super.key,
    this.textStyle,
    this.textAlign,
    this.maxLines,
    this.textOverflow,
    this.fontWeight,
    this.fontColor,
    this.fontFamily,
    this.fontSize,
    this.textDecoration,
    this.decorationColor,
    this.height,
    this.constTextStyle
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? "",
      style: constTextStyle ?? TextStyle(
        color: fontColor,
        fontWeight: fontWeight,
        fontSize: fontSize,
        fontFamily: fontFamily,
        decoration: textDecoration,
        decorationColor: decorationColor,
        height: height
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: textOverflow,
    );
  }
}
