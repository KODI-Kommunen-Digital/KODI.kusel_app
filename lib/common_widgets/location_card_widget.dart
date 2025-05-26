import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/image_utility.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:latlong2/latlong.dart';

import '../images_path.dart';
import '../utility/url_launcher_utility.dart';
import 'custom_shimmer_widget.dart';
import 'map_widget/custom_flutter_map.dart';

class LocationCardWidget extends ConsumerStatefulWidget {
  final String address;
  final String websiteText;
  final String websiteUrl;
  final double latitude;
  final double longitude;

  const LocationCardWidget(
      {super.key,
      required this.address,
      required this.websiteText,
      required this.websiteUrl,
      required this.latitude,
      required this.longitude});

  @override
  ConsumerState<LocationCardWidget> createState() => _LocationCardWidgetState();
}

class _LocationCardWidgetState extends ConsumerState<LocationCardWidget> {
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
              blurRadius: 24,
            ),
          ]),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12.h.w),
            child: Row(
              children: [
                ImageUtil.loadSvgImage(
                    imageUrl: imagePath['location_card_icon'] ?? '',
                    context: context),
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
          CustomFlutterMap(
              latitude: widget.latitude,
              longitude: widget.longitude,
              height: 120.h,
              width: MediaQuery.of(context).size.width,
              initialZoom: 13,
              onMapTap: () => UrlLauncherUtil.launchMap(
                  latitude: widget.latitude, longitude: widget.longitude),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
            child: Row(
              children: [
                ImageUtil.loadSvgImage(
                    imageUrl: imagePath['calendar_icon'] ?? '',
                    context: context),
                8.horizontalSpace,
                textRegularPoppins(
                  text: "Samstag, 28.10.2024 \nvon 6:30 - 22:00 Uhr",
                  textOverflow: TextOverflow.ellipsis,
                  color: Theme.of(context).textTheme.labelMedium?.color,
                ),
              ],
            ),
          ),
          Padding(
            padding:
                EdgeInsets.only(top: 8.0, bottom: 12.0, left: 16, right: 16),
            child: GestureDetector(
              onTap: () => UrlLauncherUtil.launchWebUrl(url: widget.websiteUrl),
              child: Row(
                children: [
                  ImageUtil.loadSvgImage(
                      imageUrl: imagePath['map_link_icon'] ?? '',
                      context: context),
                  8.horizontalSpace,
                  textRegularPoppins(
                    text: widget.websiteText,
                    textOverflow: TextOverflow.ellipsis,
                    color: Theme.of(context).textTheme.labelMedium?.color,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 5),
            child: Divider(
              height: 2.h,
              color: Theme.of(context).dividerColor,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                iconTextWidget(imagePath['man_icon'] ?? '',
                    AppLocalizations.of(context).barrier_free, context),
                8.horizontalSpace,
                iconTextWidget(imagePath['paw_icon'] ?? '',
                    AppLocalizations.of(context).dogs_allow, context)
              ],
            ),
          )
        ],
      ),
    );
  }
}

Widget iconTextWidget(String imageUrl, String text, BuildContext context) {
  return Container(
    height: 26.h,
    width: 145.w,
    padding: EdgeInsets.symmetric(horizontal: 12.w),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.onSecondary),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ImageUtil.loadSvgImage(
          imageUrl : imageUrl,
          context: context,
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
    required Function() onMapTap,
    required BuildContext context}) {
  return Consumer(builder: (context, ref, _) {
    return Stack(
      children: [
        FlutterMap(
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
        ),
        // RotatingMapWidget(latitude: latitude, longitude: longitude, onMapTap: onMapTap),
        // CompassWidget(), // Add the compass here
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
            width: 150.w,
            shapeBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r)),
          ),
          5.horizontalSpace,
          CustomShimmerWidget.rectangular(
            height: 25.h,
            width: 180.w - 20.w,
            shapeBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r)),
          ),
        ],
      ),
      10.verticalSpace,
    ],
  );
}