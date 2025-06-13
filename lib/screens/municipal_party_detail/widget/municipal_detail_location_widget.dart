import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/image_utility.dart';
import 'package:kusel/common_widgets/location_const.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app_router.dart';
import '../../../common_widgets/map_widget/custom_flutter_map.dart';
import '../../../common_widgets/text_styles.dart';
import '../../../common_widgets/web_view_page.dart';
import '../../../images_path.dart';
import '../../../navigation/navigation.dart';
import '../../../utility/url_launcher_utility.dart';

class CityDetailLocationWidget extends ConsumerStatefulWidget {
  String webUrl;
  String phoneNumber;
  String address;
  double? lat;
  double? long;
  String websiteText;
  String calendarText;

  CityDetailLocationWidget(
      {super.key,
      required this.phoneNumber,
      required this.webUrl,
      required this.address,
      this.long,
      this.lat,
      required this.websiteText,
      required this.calendarText});

  @override
  ConsumerState<CityDetailLocationWidget> createState() =>
      _CityDetailLocationWidgetState();
}

class _CityDetailLocationWidgetState
    extends ConsumerState<CityDetailLocationWidget> {
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
          CityDetailMapContainer(
            lat: widget.lat ?? EventLatLong.kusel.latitude,
            long: widget.long ?? EventLatLong.kusel.longitude,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
            child: Row(
              children: [
                ImageUtil.loadSvgImage(
                    imageUrl: imagePath['calendar_icon'] ?? '',
                    context: context),
                10.horizontalSpace,
                textRegularPoppins(
                  text:
                      "${AppLocalizations.of(context).open} \n${AppLocalizations.of(context).close} ${widget.calendarText}",
                  textAlign: TextAlign.start,
                  maxLines: 3,
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
              onTap: () {
                UrlLauncherUtil.launchDialer(phoneNumber: widget.phoneNumber);
              },
              child: Row(
                children: [
                  Image.asset(
                    imagePath['phone'] ?? '',
                    width: 18.w,
                    height: 18.h,
                  ),
                  8.horizontalSpace,
                  textRegularPoppins(
                    text: widget.phoneNumber,
                    textOverflow: TextOverflow.ellipsis,
                    color: Theme.of(context).textTheme.labelMedium?.color,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding:
                EdgeInsets.only(top: 8.0, bottom: 12.0, left: 16, right: 16),
            child: GestureDetector(
              onTap: () => ref.read(navigationProvider).navigateUsingPath(
                  path: webViewPagePath,
                  params: WebViewParams(url: widget.webUrl),
                  context: context),
              child: Row(
                children: [
                  5.horizontalSpace,
                  ImageUtil.loadSvgImage(
                      imageUrl: imagePath['link_icon'] ?? '', context: context),
                  15.horizontalSpace,
                  Expanded(
                    child: textRegularPoppins(
                      text: widget.websiteText,
                      textAlign: TextAlign.start,
                      maxLines: 3,
                      textOverflow: TextOverflow.ellipsis,
                      color: Theme.of(context).textTheme.labelMedium?.color,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CityDetailMapContainer extends StatelessWidget {
  final double lat;
  final double long;

  const CityDetailMapContainer(
      {required this.lat, required this.long, super.key});

  @override
  Widget build(BuildContext context) {
    return CustomFlutterMap(
      latitude: lat,
      longitude: long,
      height: 150.h,
      width: MediaQuery.of(context).size.width,
      initialZoom: 13,
      markersList: [
        Marker(
          width: 35.w,
          height: 35.h,
          point: LatLng(long, lat),
          child: Icon(
            Icons.location_pin,
            color: Theme.of(context).colorScheme.onTertiaryFixed,
          ),
        ),
      ],
      onMapTap: () => UrlLauncherUtil.launchMap(latitude: lat, longitude: long),
    );
  }
}
