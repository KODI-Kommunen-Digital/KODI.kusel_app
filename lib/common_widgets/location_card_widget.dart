import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../images_path.dart';
import '../theme_manager/colors.dart';
import 'package:geocoding/geocoding.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationCardWidget extends ConsumerStatefulWidget {
  const LocationCardWidget({super.key});

  @override
  ConsumerState<LocationCardWidget> createState() => _LocationCardWidgetState();
}

class _LocationCardWidgetState extends ConsumerState<LocationCardWidget> {
  String address = "Fetching address...";

  void fetchAddress() async {
    String result = await getAddressFromLatLng(28.7041, 77.1025);
    setState(() {
      address = result;
    });
  }

  @override
  void initState() {
    Future.microtask(() {
      fetchAddress();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF283583).withValues(alpha: 0.46),
            offset: Offset(0, 4),
            blurRadius: 24,
          ),
        ]
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                SvgPicture.asset(imagePath['location_card_icon'] ?? ''),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: textRegularPoppins(
                    text: address,
                    textOverflow: TextOverflow.ellipsis,
                    color: lightThemeCardTitleLocationTextColor,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width, // Adjust width as needed
            height: 110.h, // Adjust height as needed
            child: FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(49.5298, 7.3753),
                //Burg lichtenberg latlong
                initialZoom: 13.0,
                interactionOptions:
                    InteractionOptions(), // Disable map interaction
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      width: 40.0,
                      height: 40.0,
                      point: LatLng(49.5298, 7.3753), //Burg lichtenberg latlong
                      child: Icon(Icons.location_pin,
                          color: Colors.red), // Use 'child' here
                    ),
                  ],
                ),
              ],
            ),
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
                final Uri uri = Uri.parse("https://www.google.com");
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri);
                }
              },
              child: Row(
                children: [
                  SvgPicture.asset(imagePath['link_icon'] ?? ''),
                  8.horizontalSpace,
                  textRegularPoppins(
                    text: "Website besuchen",
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
    padding: EdgeInsets.symmetric(horizontal: 12.w),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: lightThemeCardGreyColor),
    child: Row(
      children: [
        SvgPicture.asset(
          imageUrl,
          height: 18.h,
          width: 18.w,
        ),
        6.horizontalSpace,
        textRegularPoppins(text: text)
      ],
    ),
  );
}

Future<String> getAddressFromLatLng(double lat, double lng) async {
  try {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
    if (placemarks.isNotEmpty) {
      Placemark place = placemarks.first;
      return "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
    }
  } catch (e) {
    return "Error: $e";
  }
  return "No Address Found";
}
