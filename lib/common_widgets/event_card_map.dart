import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../images_path.dart';
import '../screens/event/event_screen_controller.dart';
import 'custom_shimmer_widget.dart';

class EventCardMap extends ConsumerStatefulWidget {
  final String address;
  final String websiteText;
  final String title;
  final String startDate;
  final String logo;

  const EventCardMap({
    super.key,
    required this.address,
    required this.websiteText,
    required this.title,
    required this.startDate,
    required this.logo,
  });

  @override
  ConsumerState<EventCardMap> createState() => _LocationCardWidgetState();
}

class _LocationCardWidgetState extends ConsumerState<EventCardMap> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
              child: Image.network(
                widget.logo,
                height: 110.h,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  textSemiBoldMontserrat(
                    fontWeight: FontWeight.w600,
                    text: widget.title
                  ),

                  SizedBox(height: 12.h),

                  Row(
                    children: [
                  SvgPicture.asset(imagePath['location_card_icon'] ?? ''),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: textRegularMontserrat(text: widget.address, maxLines: 2,
                          softWrap: true,textAlign: TextAlign.start),
                      ),
                    ],
                  ),

                  SizedBox(height: 12.h),

                  Row(
                    children: [
                      SvgPicture.asset(imagePath['calendar_icon'] ?? ''),
                      SizedBox(width: 8.w),
                      textRegularMontserrat(text: widget.startDate),
                    ],
                  ),

                  SizedBox(height: 16.h),
                  Divider(),
                  Row(
                    children: [
                      iconTextWidget(imagePath['man_icon'] ?? '', "Barrierefrei", context),
                      8.w.horizontalSpace,
                      iconTextWidget(imagePath['paw_icon'] ?? '', "Hunde erlaubt", context),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget iconTextWidget(String imageUrl, String text, BuildContext context) {
  return Container(
    height: 26.h,
    padding: EdgeInsets.symmetric(horizontal: 12.w),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).cardTheme.color),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          imageUrl,
          height: 18.h,
          width: 18.w,
        ),
        6.horizontalSpace,
        Flexible(
            child: textRegularPoppins(
                text: text,
                maxLines: 1,
                softWrap: false
            ))
      ],
    ),
  );
}
