import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../images_path.dart';
import '../screens/event/event_detail_screen_controller.dart';
import 'custom_shimmer_widget.dart';

class TownHallMapWidget extends ConsumerStatefulWidget {
  final String address;
  final String websiteText;
  final String websiteUrl;
  final String phoneNumber;
  final String email;
  final String calendarText;
  final double latitude;
  final double longitude;

  const TownHallMapWidget(
      {super.key,
        required this.address,
        required this.websiteText,
        required this.websiteUrl,
        required this.phoneNumber,
        required this.email,
        required this.latitude,
        required this.calendarText,
        required this.longitude});

  @override
  ConsumerState<TownHallMapWidget> createState() => _LocationCardWidgetState();
}

class _LocationCardWidgetState extends ConsumerState<TownHallMapWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.46),
              offset: Offset(0, 4),
              blurRadius: 8,
            ),
          ]),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12.h.w),
            child: Row(
              children: [
                SvgPicture.asset(imagePath['location_card_icon'] ?? ''),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.0.w),
                    child: textRegularPoppins(
                      text: widget.address,
                      textAlign: TextAlign.start,
                      textOverflow: TextOverflow.visible,
                      maxLines: 4,
                      color: Theme.of(context).textTheme.labelMedium?.color,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 106.h,
            child: _customMapWidget(
                latitude: widget.latitude,
                longitude: widget.longitude,
                onMapTap: () {
                  ref
                      .read(eventDetailScreenProvider.notifier)
                      .openInMaps(widget.latitude, widget.longitude);
                },
                context: context),
          ),
          Padding(
            padding: EdgeInsets.all(14.h),
            child: Column(
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      imagePath['calendar_icon'] ?? '',
                      color: Theme.of(context).textTheme.labelMedium?.color,
                    ),
                    10.horizontalSpace,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: textBoldMontserrat(
                            text: widget.calendarText,
                            textOverflow: TextOverflow.ellipsis,
                            color: Theme.of(context).textTheme.labelMedium?.color,
                          ),
                        ),
                        textRegularPoppins(
                          text: "Schließt um 18:00 Uhr",
                          textOverflow: TextOverflow.ellipsis,
                          color: Theme.of(context).textTheme.labelMedium?.color,
                        ),
                      ],
                    )
                  ],
                ),
                10.verticalSpace,
                GestureDetector(
                  onTap: () async {
                    // final Uri phoneUri = Uri(scheme: 'tel', path: widget.phoneNumber);
                    // if (await canLaunchUrl(phoneUri)) {
                    //   await launchUrl(phoneUri);
                    // } else {
                    //   throw 'Could not launch $phoneUri';
                    // }
                  },
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        imagePath['phone_icon'] ?? '',
                        color: Theme.of(context).textTheme.labelMedium?.color,
                      ),
                      10.horizontalSpace,
                      textRegularPoppins(
                        text: widget.phoneNumber,
                        textOverflow: TextOverflow.ellipsis,
                        decoration: TextDecoration.underline,
                        color: Theme.of(context).textTheme.labelMedium?.color,
                      ),
                    ],
                  ),
                ),
                10.verticalSpace,
                GestureDetector(
                  onTap: () async {
                    // final Uri emailUri = Uri(
                    //   scheme: 'mailto',
                    //   path: widget.email,
                    // );
                    // if (await canLaunchUrl(emailUri)) {
                    //   await launchUrl(emailUri);
                    // } else {
                    //   throw 'Could not launch $emailUri';
                    // }
                  },
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        imagePath['mail_icon'] ?? '',
                        color: Theme.of(context).textTheme.labelMedium?.color,
                      ),
                      10.horizontalSpace,
                      textRegularPoppins(
                        text: widget.email,
                        textOverflow: TextOverflow.ellipsis,
                        decoration: TextDecoration.underline,
                        color: Theme.of(context).textTheme.labelMedium?.color,
                      ),
                    ],
                  ),
                ),
                10.verticalSpace,
                GestureDetector(
                  onTap: () async {
                    final Uri uri = Uri.parse(widget.websiteUrl);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri);
                    }
                  },
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        imagePath['link_icon'] ?? '',
                        color: Theme.of(context).textTheme.labelMedium?.color,
                      ),
                      10.horizontalSpace,
                      textRegularPoppins(
                        text: widget.websiteText,
                        textOverflow: TextOverflow.ellipsis,
                        decoration: TextDecoration.underline,
                        color: Theme.of(context).textTheme.labelMedium?.color,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}


Widget _customMapWidget(
    {required double latitude,
      required double longitude,
      required Function() onMapTap,
      required BuildContext context}) {
  return Consumer(builder: (context, ref, _) {
    return FlutterMap(
      options: MapOptions(
        onTap: (tapPosition, LatLng latLong) {
          onMapTap();
        },
        initialCenter: LatLng(latitude, longitude),
        initialZoom: 13.0,
        interactionOptions: InteractionOptions(),
      ),
      children: [
        TileLayer(
          urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
        ),
        MarkerLayer(
          markers: [
            Marker(
              width: 35.w,
              height: 35.h,
              point: LatLng(latitude, longitude),
              child: Icon(Icons.location_pin,
                  color: Theme.of(context).colorScheme.onTertiaryFixed),
            ),
          ],
        )
      ],
    );
  });
}

Widget locationCardShimmerEffect(BuildContext context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      12.verticalSpace,
      CustomShimmerWidget.rectangular(
        height: 20.h,
        shapeBorder:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      ),
      15.verticalSpace,
      CustomShimmerWidget.rectangular(
        height: 106.h,
        shapeBorder:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.r)),
      ),
      12.verticalSpace,
      Align(
        alignment: Alignment.centerLeft,
        child: CustomShimmerWidget.rectangular(
          height: 15.h,
          width: 150.w,
          shapeBorder:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        ),
      ),
      10.verticalSpace,
      Align(
        alignment: Alignment.centerLeft,
        child: CustomShimmerWidget.rectangular(
          height: 15.h,
          width: 150.w,
          shapeBorder:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        ),
      ),
      16.verticalSpace,
      Align(
        alignment: Alignment.centerLeft,
        child: CustomShimmerWidget.rectangular(
          height: 20.h,
          width: 200.w,
          shapeBorder:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        ),
      ),
      20.verticalSpace,
      Row(
        children: [
          CustomShimmerWidget.rectangular(
            height: 25.h,
            width: MediaQuery.of(context).size.width / 2 - 20.w,
            shapeBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r)),
          ),
          5.horizontalSpace,
          CustomShimmerWidget.rectangular(
            height: 25.h,
            width: MediaQuery.of(context).size.width / 2 - 20.w,
            shapeBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r)),
          ),
        ],
      ),
      10.verticalSpace,
    ],
  );
}

