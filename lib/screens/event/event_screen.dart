import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kusel/common_widgets/custom_shimmer_widget.dart';
import 'package:kusel/common_widgets/downstream_wave_clipper.dart';
import 'package:kusel/common_widgets/feedback_card_widget.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:kusel/screens/event/event_screen_controller.dart';
import 'package:kusel/screens/event/event_screen_state.dart';

import '../../common_widgets/arrow_back_widget.dart' show ArrowBackWidget;
import '../../common_widgets/location_card_widget.dart';
import '../../images_path.dart';
import '../../navigation/navigation.dart';

class EventScreen extends ConsumerStatefulWidget {
  final EventScreenParams eventScreenParams;

  const EventScreen({super.key, required this.eventScreenParams});

  @override
  ConsumerState<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends ConsumerState<EventScreen> {
  @override
  void initState() {
    Future.microtask(() {
      ref.read(eventScreenProvider.notifier).fetchAddress();
      ref
          .read(eventScreenProvider.notifier)
          .getEventDetails(widget.eventScreenParams.eventId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(eventScreenProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSecondary,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildClipperBackground(state),
            _buildEventsUi(state),
            FeedbackCardWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildEventsUi(EventScreenState state) {
    return Padding(
      padding: EdgeInsets.all(12.h.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          state.loading
              ? CustomShimmerWidget.rectangular(
                  height: 25.h,
                  shapeBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r)),
                )
              : textBoldPoppins(
                  text: state.eventDetails.title ?? "",
                  color: Theme.of(context).textTheme.labelLarge?.color,
                  fontSize: 16.sp),
          15.verticalSpace,
          state.loading
              ? locationCardShimmerEffect(context)
              : LocationCardWidget(
                  address: state.eventDetails.address ?? "",
                  websiteText: "Website besuchen",
                  websiteUrl: state.eventDetails.website ?? "",
                  latitude: state.eventDetails.latitude ?? 0,
                  longitude: state.eventDetails.longitude ?? 0,
                ),
          12.verticalSpace,
          state.loading
              ? _publicTransportShimmerEffect()
              : _publicTransportCard(
                  heading: AppLocalizations.of(context).public_transport_offer,
                  description: "Schau dir hier an, wie du am besten hinkommst",
                  onTap: () {}),
          16.verticalSpace,
          state.loading
              ? _eventInfoShimmerEffect()
              : _eventInfoWidget(
                  heading: AppLocalizations.of(context).description,
                  subHeading:
                      "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod",
                  description: state.eventDetails.description ?? "",
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
              text: heading,
              fontSize: 15.sp,
              color: Theme.of(context).textTheme.labelLarge?.color),
          12.verticalSpace,
          textSemiBoldPoppins(
              text: subHeading,
              textAlign: TextAlign.start,
              fontSize: 12.sp,
              textOverflow: TextOverflow.visible,
              color: Theme.of(context).textTheme.labelLarge?.color,
              fontWeight: FontWeight.w600),
          12.verticalSpace,
          textRegularPoppins(
              text: description,
              fontSize: 11.sp,
              textOverflow: TextOverflow.visible,
              color: Theme.of(context).textTheme.labelLarge?.color,
              textAlign: TextAlign.start),
          Align(child: _buildExpandedTile())
        ],
      ),
    );
  }

  Widget _eventInfoShimmerEffect() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        20.verticalSpace,
        Align(
          alignment: Alignment.centerLeft,
          child: CustomShimmerWidget.rectangular(
            height: 20.h,
            width: 150.w,
            shapeBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r)),
          ),
        ),
        20.verticalSpace,
        CustomShimmerWidget.rectangular(
          height: 15.h,
          shapeBorder:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        ),
        8.verticalSpace,
        CustomShimmerWidget.rectangular(
          height: 15.h,
          shapeBorder:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        ),
        20.verticalSpace,
        CustomShimmerWidget.rectangular(
          height: 15.h,
          shapeBorder:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        ),
        8.verticalSpace,
        CustomShimmerWidget.rectangular(
          height: 15.h,
          shapeBorder:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        ),
        8.verticalSpace,
        Align(
          alignment: Alignment.centerLeft,
          child: CustomShimmerWidget.rectangular(
            height: 15.h,
            width: 150.w,
            shapeBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r)),
          ),
        )
      ],
    );
  }

  Widget _publicTransportCard(
      {required String heading,
      required String description,
      required Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(12.h.w),
        decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.46),
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
                        color: Theme.of(context).textTheme.labelLarge?.color),
                    textRegularPoppins(
                        textAlign: TextAlign.left,
                        text: description,
                        fontSize: 11.sp,
                        color: Theme.of(context).textTheme.labelMedium?.color,
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

  Widget _publicTransportShimmerEffect() {
    return Row(
      children: [
        CustomShimmerWidget.circular(
            width: 60.w,
            height: 50.h,
            shapeBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r))),
        10.horizontalSpace,
        Column(
          children: [
            CustomShimmerWidget.rectangular(
              height: 15.h,
              width: MediaQuery.of(context).size.width - 110.w,
              shapeBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r)),
            ),
            5.verticalSpace,
            CustomShimmerWidget.rectangular(
              height: 15.h,
              width: MediaQuery.of(context).size.width - 110.w,
              shapeBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r)),
            ),
            5.verticalSpace,
            CustomShimmerWidget.rectangular(
              height: 15.h,
              width: MediaQuery.of(context).size.width - 110.w,
              shapeBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r)),
            )
          ],
        )
      ],
    );
  }

  Widget _buildExpandedTile() {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      iconColor: Theme.of(context).primaryColor,
      visualDensity: VisualDensity.compact,
      // Reduces space between title & arrow
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      childrenPadding: EdgeInsets.zero,
      title: textRegularPoppins(
          text: "Weiterlesen",
          color: Theme.of(context).textTheme.labelLarge?.color,
          textAlign: TextAlign.start,
          decoration: TextDecoration.underline),
      children: [
        textBoldPoppins(
            text: "Nächste Termine",
            color: Theme.of(context).textTheme.labelLarge?.color),
        10.verticalSpace,
        Padding(
          padding: EdgeInsets.symmetric(vertical: 6.h),
          child: Row(
            children: [
              SvgPicture.asset(
                imagePath['calendar_icon'] ?? '',
                color: Theme.of(context).colorScheme.surface,
              ),
              8.horizontalSpace,
              textRegularMontserrat(
                text: "Samstag, 28.10.2024 \nvon 6:30 - 22:00 Uhr",
                textOverflow: TextOverflow.ellipsis,
                color: Theme.of(context).textTheme.labelLarge?.color,
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
                imagePath['calendar_icon'] ?? '',
                color: Theme.of(context).colorScheme.surface,
              ),
              8.horizontalSpace,
              textRegularMontserrat(
                text: "Samstag, 28.10.2024 \nvon 6:30 - 22:00 Uhr",
                textOverflow: TextOverflow.ellipsis,
                color: Theme.of(context).textTheme.labelLarge?.color,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildClipperBackground(EventScreenState state) {
    return state.loading ? _buildClipperBackgroundShimmer() : Stack(
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

  Widget _buildClipperBackgroundShimmer() {
    return Stack(
      children: [
        ClipPath(
          clipper: DownstreamCurveClipper(),
          child: CustomShimmerWidget.rectangular(height: 270.h),
        ),
      ],
    );
  }
}
