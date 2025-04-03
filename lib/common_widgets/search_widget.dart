import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kusel/images_path.dart';

import '../theme_manager/colors.dart';

class SearchWidget extends ConsumerStatefulWidget {
  String hintText;
  TextEditingController searchController;

  SearchWidget(
      {super.key, required this.hintText, required this.searchController});

  @override
  ConsumerState<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends ConsumerState<SearchWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.h,
      width: 350.w,
      decoration: BoxDecoration(
          color: lightThemeWhiteColor,
          borderRadius: BorderRadius.circular(30.r),
          border: Border.all(width: 1, color: lightThemeDividerColor)),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.0.w),
          child: Row(
            children: [
              SvgPicture.asset(imagePath['search_icon'] ?? ''),
              8.horizontalSpace,
              Expanded(
                child: TextField(
                  controller: widget.searchController,
                  decoration: InputDecoration(
                      hintText: widget.hintText,
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                          fontSize: 14.sp,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w400,
                          color: lightThemeHintColor,
                          fontStyle: FontStyle.italic)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
