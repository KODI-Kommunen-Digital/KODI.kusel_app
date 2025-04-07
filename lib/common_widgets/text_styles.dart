import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Text textRegularPoppins(
    {required String text,
    Color? color,
    FontWeight? fontWeight,
    double? fontSize,
    TextOverflow? textOverflow,
    TextDecoration? decoration,
    FontStyle? fontStyle,
      int? maxLines,
    TextAlign? textAlign,
    bool? softWrap}) {
  return Text(
    text,
    softWrap: softWrap,
    style: TextStyle(
      fontSize: fontSize?.sp ?? 14.sp,
      fontFamily: "Poppins",
      fontWeight: fontWeight ?? FontWeight.w400,
      color: color,
      decoration: decoration,
      fontStyle: fontStyle,
    ),
    textAlign: textAlign ?? TextAlign.center,
    overflow: textOverflow ?? TextOverflow.ellipsis,
    maxLines:maxLines,
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

Text textRegularMontserrat(
    {required String text,
    Color? color,
    FontWeight? fontWeight,
    double? fontSize,
    TextOverflow? textOverflow}) {
  return Text(
    text,
    style: TextStyle(
        fontSize: fontSize ?? 14,
        fontFamily: "Montserrat",
        fontWeight: fontWeight ?? FontWeight.w400,
        color: color ?? Color.fromRGBO(0, 0, 0, 1)),
    overflow: textOverflow ?? TextOverflow.ellipsis,
  );
}

Text textHeadingMontserrat(
    {required String text,
    Color? color,
    FontWeight? fontWeight,
    double? fontSize,
    TextOverflow? textOverflow}) {
  return Text(
    text,
    style: TextStyle(
        fontSize: fontSize ?? 24,
        fontFamily: "Montserrat",
        fontWeight: fontWeight ?? FontWeight.w600,
        color: color ?? Color.fromRGBO(0, 0, 0, 1)),
    overflow: textOverflow ?? TextOverflow.ellipsis,
  );
}

Text textSemiBoldMontserrat(
    {required String text,
    Color? color,
    FontWeight? fontWeight,
    double? fontSize,
    TextOverflow? textOverflow}) {
  return Text(
    text,
    style: TextStyle(
        fontSize: fontSize ?? 15,
        fontFamily: "Montserrat",
        fontWeight: fontWeight ?? FontWeight.w500,
        color: color ?? Color.fromRGBO(0, 0, 0, 1)),
    overflow: textOverflow ?? TextOverflow.ellipsis,
  );
}

Text textBoldMontserrat(
    {required String text,
    Color? color,
    FontWeight? fontWeight,
    double? fontSize,
    TextOverflow? textOverflow}) {
  return Text(
    text,
    style: TextStyle(
        fontSize: fontSize ?? 14,
        fontFamily: "Montserrat",
        fontWeight: fontWeight ?? FontWeight.w600,
        color: color ?? Color.fromRGBO(0, 0, 0, 1)),
    overflow: textOverflow ?? TextOverflow.ellipsis,
  );
}
