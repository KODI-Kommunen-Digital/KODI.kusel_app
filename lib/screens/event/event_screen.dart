import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kusel/common_widgets/downstream_wave_clipper.dart';
import 'package:kusel/common_widgets/feedback_card_widget.dart';
import 'package:kusel/common_widgets/text_styles.dart';

import '../../common_widgets/location_card_widget.dart';
import '../../images_path.dart';
import '../../theme_manager/colors.dart';

class EventScreen extends ConsumerStatefulWidget {
  const EventScreen({super.key});

  @override
  ConsumerState<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends ConsumerState<EventScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightThemeScaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildClipperBackground(),
            _buildEventsUi(),
            FeedbackCardWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildEventsUi() {
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textBoldPoppins(
              text: "Mittelaltermarkt",
              color: lightThemeSecondaryColor,
              fontSize: 16.sp),
          15.verticalSpace,
          LocationCardWidget(),
          12.verticalSpace,
          publicTransportCard()
        ],
      ),
    );
  }

  Widget publicTransportCard() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(15.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF283583).withValues(alpha: 0.46),
            offset: Offset(0, 4),
            blurRadius: 8,
          ),
        ]
      ),
      child: Row(
        children: [
          SvgPicture.asset(imagePath['transport_icon'] ?? ''),
          20.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textBoldPoppins(text: "ÖPNV Angebot", fontSize: 14.sp),
                textRegularPoppins(
                  textAlign: TextAlign.left,
                    text: "Schau dir hier an, wie du am besten hinkommst",
                    textOverflow: TextOverflow.visible
                )
              ],
            ),
          ),
          SvgPicture.asset(imagePath['link_icon'] ?? ''),
        ],
      ),
    );
  }

  Widget _buildClipperBackground() {
    return Stack(
      children: [
        ClipPath(
          clipper: DownstreamCurveClipper(),
          child: Container(
            height: 340,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imagePath['highlight_card_image'] ?? ''),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Positioned(
          top: 30.h,
          left: 15.w,
          child: Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: Color(0xFF283583),
              borderRadius: BorderRadius.circular(50.r),
            ),
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
