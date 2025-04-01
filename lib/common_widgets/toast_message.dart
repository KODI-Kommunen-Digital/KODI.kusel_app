import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import "package:motion_toast/motion_toast.dart";

showSuccessToast({required String message, required BuildContext context}) {
  MotionToast(
    primaryColor: Color(0xFF4CAF50).withValues(alpha: .3),
    description: textRegularPoppins(
        text: message, color: Colors.white),
    toastAlignment: Alignment.bottomCenter,
    animationType: AnimationType.slideInFromBottom,
    displayBorder: true,
    displaySideBar: false,
    icon: Icons.done,
    secondaryColor: Colors.white,
    width: 350.w,
    height: 100.h,
    margin: EdgeInsets.only(
      top: 30.h,
    ),
  ).show(context);
}

showErrorToast({required String message, required BuildContext context}) {
  MotionToast(
    primaryColor: Color(0xFFF75A5A).withValues(alpha: .3),
    description: textRegularPoppins(
        text: message, color: Colors.white),
    toastAlignment: Alignment.bottomCenter,
    animationType: AnimationType.slideInFromBottom,
    displayBorder: true,
    displaySideBar: false,
    icon: Icons.error,
    secondaryColor: Colors.white,
    width: 350.w,
    height: 100.h,
    margin: EdgeInsets.only(
      top: 30.h,
    ),
  ).show(context);
}
