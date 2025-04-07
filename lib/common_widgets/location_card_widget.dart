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
import '../theme_manager/colors.dart';

class LocationCardWidget extends ConsumerStatefulWidget {
  final String address;
  final String websiteText;
  final String websiteUrl;

  const LocationCardWidget({
    super.key,
    required this.address,
    required this.websiteText,
    required this.websiteUrl,
  });

  @override
  ConsumerState<LocationCardWidget> createState() => _LocationCardWidgetState();
}

class _LocationCardWidgetState extends ConsumerState<LocationCardWidget> {
  double latitude = 49.5298;
  double longitude = 7.3753;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          boxShadow: [
            BoxShadow(
              color: lightThemeHighlightDotColor.withValues(alpha: 0.46),
              offset: Offset(0, 4),
              blurRadius: 24,
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
                      color: lightThemeCardTitleLocationTextColor,
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
                latitude: latitude,
                longitude: longitude,
                onMapTap: () {
                  ref
                      .read(eventScreenProvider.notifier)
                      .openInMaps(latitude, longitude);
                }),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
            child: Row(
              children: [
                SvgPicture.asset(imagePath['calendar'] ?? ''),
                8.horizontalSpace,
                textRegularPoppins(
                  text: "Samstag, 28.10.2024 \nvon 6:30 - 22:00 Uhr",
                  textOverflow: TextOverflow.ellipsis,
                  color: lightThemeCardTitleLocationTextColor,
                ),
              ],
            ),
          ),
          Padding(
            padding:
                EdgeInsets.only(top: 8.0, bottom: 12.0, left: 16, right: 16),
            child: GestureDetector(
              onTap: () async {
                final Uri uri = Uri.parse(widget.websiteUrl);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri);
                }
              },
              child: Row(
                children: [
                  SvgPicture.asset(imagePath['link_icon'] ?? ''),
                  8.horizontalSpace,
                  textRegularPoppins(
                    text: widget.websiteText,
                    textOverflow: TextOverflow.ellipsis,
                    color: lightThemeCardTitleLocationTextColor,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 5),
            child: Divider(
              height: 2.h,
              color: lightThemeDividerColor,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                iconTextWidget(imagePath['man_icon'] ?? '', "Barrierefrei"),
                8.horizontalSpace,
                iconTextWidget(imagePath['paw_icon'] ?? '', "Hunde erlaubt")
              ],
            ),
          )
        ],
      ),
    );
  }
}

Widget iconTextWidget(String imageUrl, String text) {
  return Container(
    height: 26.h,
    width: 145.w,
    padding: EdgeInsets.symmetric(horizontal: 12.w),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: lightThemeCardGreyColor),
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
                softWrap: false // Make sure this is set
                ))
      ],
    ),
  );
}

Widget _customMapWidget(
    {required double latitude,
    required double longitude,
    required Function() onMapTap}) {
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
        urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
        subdomains: ['a', 'b', 'c'],
      ),
      MarkerLayer(
        markers: [
          Marker(
            width: 35.w,
            height: 35.h,
            point: LatLng(latitude, longitude),
            child: Icon(Icons.location_pin, color: lightThemeMapMarkerColor),
          ),
        ],
      ),
    ],
  );
}
