import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:kusel/images_path.dart';

import '../theme_manager/colors.dart';

class WeatherWidget extends ConsumerStatefulWidget {
  const WeatherWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<WeatherWidget> createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends ConsumerState<WeatherWidget> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SizedBox(
      height: 260.h,
    child: Card(
        color: lightThemePrimaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        elevation: 0,
        child: Stack(
          children: [
            Positioned(
              left: -width * .15,
              bottom: 15.h,
              child: Container(
                color: Colors.white,
                width: width * .87,
                height: height * .27,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Align content to left
                    children: [
                      Text(
                        "24" + "\u00B0",
                        style: TextStyle(
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w500,
                          fontSize: 64,
                          color: lightThemeTemperatureColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      textBoldMontserrat(text: "Kusal"),
                      SizedBox(
                        height: 32.h,
                        width: (width * .4).w,
                        child: Divider(
                          thickness: 1,
                          color: lightThemeTemperatureColor,
                        ),
                      ),
                      16.horizontalSpace,
                      // 3-Day Forecast
                      SizedBox(
                        width: (width * .4).w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: const [
                            _DayWeather(day: 'Sa', icon: Icons.wb_sunny_outlined, temp: '24°'),
                            _DayWeather(day: 'So', icon: Icons.wb_sunny_outlined, temp: '24°'),
                            _DayWeather(day: 'Mo', icon: Icons.wb_sunny_outlined, temp: '24°'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
            ,
            Positioned(
              bottom: 0,
              right: 8.w,
              child: Image.asset(
                imagePath['dino'] ?? "",
                width: (width * .37).w,
                height: (width * .37).h,
              ),
            ),Positioned(
              top: 20.h,
              right: (width * .15).w,
              child: Container(
                width: (width * .26).w,
                height: (width * .16).h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 0.8,
                    colors: [
                      Color.fromRGBO(255, 228, 201, 1), // intermediate shade
                      Color.fromRGBO(255, 228, 131, 1), // intermediate shade
                      Color.fromRGBO(255, 228, 131, 1) // transparent at the edge
                    ],
                    stops: const [0.0, 0.7, 1.0],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(255, 228, 131, 1),
                      blurRadius: 20,
                      spreadRadius: 20,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DayWeather extends StatelessWidget {
  final String day;
  final IconData icon;
  final String temp;

  const _DayWeather({
    Key? key,
    required this.day,
    required this.icon,
    required this.temp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        textRegularMontserrat(text: day),
        4.horizontalSpace,
        Icon(icon),
        4.horizontalSpace,
        textSemiBoldMontserrat(text: temp),
      ],
    );
  }
}
