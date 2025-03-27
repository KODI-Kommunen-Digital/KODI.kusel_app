import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Text textRegularPoppins(
    {required String text,
    Color? color,
    FontWeight? fontWeight,
    double? fontSize,
    TextOverflow? textOverflow,
    TextDecoration? decoration}) {
  return Text(
    text,
    style: TextStyle(
        fontSize: fontSize?.sp ?? 14.sp,
        fontFamily: "Poppins",
        fontWeight: fontWeight ?? FontWeight.w400,
        color: color,
    decoration: decoration),
    overflow: textOverflow ?? TextOverflow.ellipsis,
  );
}

Text textSemiBoldPoppins(
    {required String text,
    Color? color,
    FontWeight? fontWeight,
    double? fontSize,
    TextOverflow? textOverflow}) {
  return Text(
    text,
    style: TextStyle(
        fontFamily: "Poppins",
        fontWeight: fontWeight ?? FontWeight.w500,
        color: color,
        fontSize: fontSize?.sp ?? 14.sp),
    overflow: textOverflow ?? TextOverflow.ellipsis,
  );
}

Text textBoldPoppins(
    {required String text,
    Color? color,
    FontWeight? fontWeight,
    double? fontSize,
    TextOverflow? textOverflow,
    TextAlign? textAlign}) {
  return Text(
    text,
    textAlign: textAlign,
    style: TextStyle(
        fontFamily: "Poppins",
        fontWeight: fontWeight ?? FontWeight.w600,
        color: color,
        fontSize: fontSize?.sp ?? 14.sp,
    ),
    overflow: textOverflow ?? TextOverflow.ellipsis,
  );
}
