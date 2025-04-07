import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kusel/common_widgets/downstream_wave_clipper.dart';
import 'package:kusel/common_widgets/feedback_card_widget.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:kusel/screens/event/event_screen_controller.dart';

import '../../common_widgets/arrow_back_widget.dart' show ArrowBackWidget;
import '../../common_widgets/location_card_widget.dart';
import '../../images_path.dart';
import '../../navigation/navigation.dart';
import '../../theme_manager/colors.dart';

class EventScreen extends ConsumerStatefulWidget {

  final Listing listingParam;
  const EventScreen({super.key, required this.listingParam});

  @override
  ConsumerState<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends ConsumerState<EventScreen> {
  @override
  void initState() {
    Future.microtask(() {
      ref.read(eventScreenProvider.notifier).fetchAddress();
    });
    super.initState();
  }

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
      padding: EdgeInsets.all(12.h.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textBoldPoppins(
              text: widget.listingParam.title ?? "",
              color: lightThemeSecondaryColor,
              fontSize: 16.sp),
          15.verticalSpace,
          LocationCardWidget(
            address: widget.listingParam.address ?? "",
            websiteText: "Website besuchen",
            websiteUrl: widget.listingParam.website ?? "",
          ),
          12.verticalSpace,
          publicTransportCard(
              heading: AppLocalizations.of(context).public_transport_offer,
              description: "Schau dir hier an, wie du am besten hinkommst",
              onTap: () {}),
          16.verticalSpace,
          _eventInfoWidget(
            heading: AppLocalizations.of(context).description,
            subHeading:
                "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod",
            description:
            widget.listingParam.description ?? "",
          )
        ],
      ),
    );
  }

  Widget _eventInfoWidget(
      {required String heading,
      required String subHeading,
      required String description}) {
    return Padding(
      padding: EdgeInsets.all(12.h.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textBoldPoppins(
              text: heading, fontSize: 15.sp, color: lightThemeSecondaryColor),
          12.verticalSpace,
          textSemiBoldPoppins(
              text: subHeading,
              fontSize: 12.sp,
              textOverflow: TextOverflow.visible,
              color: lightThemeSecondaryColor,
              fontWeight: FontWeight.w600),
          12.verticalSpace,
          textRegularPoppins(
              text: description,
              fontSize: 11.sp,
              textOverflow: TextOverflow.visible,
              color: lightThemeSecondaryColor,
              textAlign: TextAlign.start),
          Align(child: _buildExpandedTile())
        ],
      ),
    );
  }

  Widget publicTransportCard(
      {required String heading,
      required String description,
      required Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(12.h.w),
        decoration: BoxDecoration(
            color: lightThemeWhiteColor,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: lightThemeHighlightDotColor.withValues(alpha: 0.46),
                offset: Offset(0, 4),
                blurRadius: 8,
              ),
            ]),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.h),
          child: Row(
            children: [
              SvgPicture.asset(
                imagePath['transport_icon'] ?? '',
                height: 25.h,
                width: 25.w,
              ),
              20.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    textBoldPoppins(
                        text: heading,
                        fontSize: 13.sp,
                        color: lightThemeSecondaryColor),
                    textRegularPoppins(
                        textAlign: TextAlign.left,
                        text: description,
                        fontSize: 11.sp,
                        color: lightThemeTransportCardTextColor,
                        textOverflow: TextOverflow.visible)
                  ],
                ),
              ),
              SvgPicture.asset(imagePath['link_icon'] ?? ''),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedTile() {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      iconColor: lightThemeHighlightDotColor,
      visualDensity: VisualDensity.compact,
      // Reduces space between title & arrow
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      childrenPadding: EdgeInsets.zero,
      title: textRegularPoppins(
          text: "Weiterlesen",
          color: lightThemeSecondaryColor,
          textAlign: TextAlign.start,
          decoration: TextDecoration.underline),
      children: [
        textBoldPoppins(
            text: "Nächste Termine", color: lightThemeSecondaryColor),
        10.verticalSpace,
        Padding(
          padding: EdgeInsets.symmetric(vertical: 6.h),
          child: Row(
            children: [
              SvgPicture.asset(
                imagePath['calendar'] ?? '',
                color: lightThemeCalendarIconColor,
              ),
              8.horizontalSpace,
              textRegularMontserrat(
                text: "Samstag, 28.10.2024 \nvon 6:30 - 22:00 Uhr",
                textOverflow: TextOverflow.ellipsis,
                color: lightThemeSecondaryColor,
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: 6.h,
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                imagePath['calendar'] ?? '',
                color: lightThemeCalendarIconColor,
              ),
              8.horizontalSpace,
              textRegularMontserrat(
                text: "Samstag, 28.10.2024 \nvon 6:30 - 22:00 Uhr",
                textOverflow: TextOverflow.ellipsis,
                color: lightThemeSecondaryColor,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildClipperBackground() {
    return Stack(
      children: [
        ClipPath(
          clipper: DownstreamCurveClipper(),
          child: Container(
            height: 270.h,
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
          child: ArrowBackWidget(
            onTap: () {
              ref.read(navigationProvider).removeTopPage(context: context);
            },
          ),
        ),
      ],
    );
  }
}
