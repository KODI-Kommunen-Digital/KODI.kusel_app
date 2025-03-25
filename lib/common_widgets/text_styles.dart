import 'package:flutter/material.dart';

Text regularPoppins(
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

Text semiBoldPoppins(
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

Text boldPoppins(
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
