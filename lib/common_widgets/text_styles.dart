import 'package:flutter/material.dart';

Text textRegularPoppins(
    {required String text,
    Color? color,
    FontWeight? fontWeight,
    double? fontSize,
    TextOverflow? textOverflow}) {
  return Text(
    text,
    style: TextStyle(
        fontSize: fontSize ?? 14,
        fontFamily: "Poppins",
        fontWeight: fontWeight ?? FontWeight.w400,
        color: color ?? Color.fromRGBO(0, 0, 0, 1)),
    overflow: textOverflow ?? TextOverflow.ellipsis,
  );
}

Text textHeadingPoppins(
    {required String text,
    Color? color,
    FontWeight? fontWeight,
    double? fontSize,
    TextOverflow? textOverflow}) {
  return Text(
    text,
    style: TextStyle(
        fontSize: fontSize ?? 24,
        fontFamily: "Poppins",
        fontWeight: fontWeight ?? FontWeight.w600,
        color: color ?? Color.fromRGBO(0, 0, 0, 1)),
    overflow: textOverflow ?? TextOverflow.ellipsis,
  );
}

Text textSemiBoldPoppins(
    {required String text,
    Color? color,
    FontWeight? fontWeight,
    TextOverflow? textOverflow}) {
  return Text(
    text,
    style: TextStyle(
        fontFamily: "Poppins",
        fontWeight: fontWeight ?? FontWeight.w500,
        color: color ?? Color.fromRGBO(0, 0, 0, 1)),
    overflow: textOverflow ?? TextOverflow.ellipsis,
  );
}

Text textBoldPoppins(
    {required String text,
    Color? color,
    FontWeight? fontWeight,
    TextOverflow? textOverflow}) {
  return Text(
    text,
    style: TextStyle(
        fontFamily: "Poppins",
        fontWeight: fontWeight ?? FontWeight.w600,
        color: color ?? Color.fromRGBO(0, 0, 0, 1)),
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
