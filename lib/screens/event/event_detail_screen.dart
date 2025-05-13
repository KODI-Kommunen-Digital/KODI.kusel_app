import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kusel/app_router.dart';
import 'package:kusel/common_widgets/custom_shimmer_widget.dart';
import 'package:kusel/common_widgets/downstream_wave_clipper.dart';
import 'package:kusel/common_widgets/feedback_card_widget.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:kusel/screens/event/event_detail_screen_controller.dart';
import 'package:kusel/screens/event/event_detail_screen_state.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common_widgets/arrow_back_widget.dart' show ArrowBackWidget;
import '../../common_widgets/common_event_card.dart';
import '../../common_widgets/location_card_widget.dart';
import '../../images_path.dart';
import '../../navigation/navigation.dart';
import '../home/home_screen_provider.dart';

class EventDetailScreen extends ConsumerStatefulWidget {
  final EventDetailScreenParams eventScreenParams;

  const EventDetailScreen({super.key, required this.eventScreenParams});

  @override
  ConsumerState<EventDetailScreen> createState() => _EventScreenState();
}

class _EventScreenState extends ConsumerState<EventDetailScreen> {
  @override
  void initState() {
    Future.microtask(() {
      ref.read(eventDetailScreenProvider.notifier).fetchAddress();
      ref
          .read(eventDetailScreenProvider.notifier)
          .getEventDetails(widget.eventScreenParams.eventId);
      ref.read(eventDetailScreenProvider.notifier).getRecommendedList();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(eventDetailScreenProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildClipperBackground(state),
            _buildEventsUi(state),
            _buildRecommendation(context),
            FeedbackCardWidget(
              onTap: () {
                ref.read(navigationProvider).navigateUsingPath(
                    path: feedbackScreenPath, context: context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventsUi(EventDetailScreenState state) {
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
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                  fontSize: 16),
          15.verticalSpace,
          state.loading
              ? locationCardShimmerEffect(context)
              : LocationCardWidget(
                  address: state.eventDetails.address ?? "",
                  websiteText: AppLocalizations.of(context).visit_website,
                  websiteUrl: state.eventDetails.website ?? "",
                  latitude: state.eventDetails.latitude ?? 0,
                  longitude: state.eventDetails.longitude ?? 0,
                ),
          12.verticalSpace,
          state.loading
              ? _publicTransportShimmerEffect()
              : _publicTransportCard(
                  heading: AppLocalizations.of(context).public_transport_offer,
                  description: AppLocalizations.of(context).find_out_how_to,
                  onTap: () async {
                    final Uri uri = Uri.parse("https://www.google.com/");
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri);
                    }
                  }),
          16.verticalSpace,
          state.loading
              ? _eventInfoShimmerEffect()
              : _eventInfoWidget(
                  heading: AppLocalizations.of(context).description,
                  subHeading: '',
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
              fontSize: 15,
              color: Theme.of(context).textTheme.bodyLarge?.color),
          12.verticalSpace,
          textSemiBoldPoppins(
              text: subHeading,
              textAlign: TextAlign.start,
              fontSize: 12,
              textOverflow: TextOverflow.visible,
              color: Theme.of(context).textTheme.bodyLarge?.color,
              fontWeight: FontWeight.w600),
          12.verticalSpace,
          textRegularPoppins(
              text: description,
              fontSize: 11,
              textOverflow: TextOverflow.visible,
              color: Theme.of(context).textTheme.bodyLarge?.color,
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
            color: Theme.of(context).colorScheme.onPrimary,
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
                        fontSize: 13,
                        color: Theme.of(context).textTheme.bodyLarge?.color),
                    textRegularPoppins(
                        textAlign: TextAlign.left,
                        text: description,
                        fontSize: 11,
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
            width: 50.w,
            height: 40.h,
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
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      childrenPadding: EdgeInsets.zero,
      title: textRegularPoppins(
          text: AppLocalizations.of(context).read_more,
          color: Theme.of(context).textTheme.bodyLarge?.color,
          textAlign: TextAlign.start,
          decoration: TextDecoration.underline),
      children: [
        textBoldPoppins(
            text: AppLocalizations.of(context).next_dates,
            color: Theme.of(context).textTheme.bodyLarge?.color),
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
                color: Theme.of(context).textTheme.bodyLarge?.color,
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
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildClipperBackground(EventDetailScreenState state) {
    return  Stack(
            children: [
              ClipPath(
                clipper: DownstreamCurveClipper(),
                child: Container(
                  height: 270.h,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                        state.eventDetails.logo ?? "",
                      ),
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
                    ref
                        .read(navigationProvider)
                        .removeTopPage(context: context);
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

  _buildRecommendation(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final eventDetailController =
          ref.read(eventDetailScreenProvider.notifier);
      final state = ref.watch(eventDetailScreenProvider);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16.w),
            child: textBoldPoppins(
                text: AppLocalizations.of(context).recommendation,
                fontSize: 16,
                color: Theme.of(context).textTheme.bodyLarge?.color),
          ),
          state.groupedEvents.isEmpty
              ? Center(
                  child: textHeadingMontserrat(
                      text: AppLocalizations.of(context).no_data, fontSize: 14),
                )
              : ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: state.groupedEvents.entries.expand((entry) {
                    final categoryId = entry.key;
                    final items = eventDetailController.subList(entry.value);

                    return [
                      ...items.map((item) {
                        return CommonEventCard(
                          isFavorite: item.isFavorite ?? false,
                          imageUrl: item.logo ?? "",
                          date: item.startDate ?? "",
                          title: item.title ?? "",
                          location: item.address ?? "",
                          onTap: () {
                            ref.read(navigationProvider).navigateUsingPath(
                                  context: context,
                                  path: eventScreenPath,
                                  params:
                                      EventDetailScreenParams(eventId: item.id),
                                );
                          },
                          isFavouriteVisible: !ref
                              .watch(homeScreenProvider)
                              .isSignupButtonVisible, sourceId: item.sourceId!,
                        );
                      }),
                    ];
                  }).toList(),
                ),
          16.verticalSpace
        ],
      );
    });
  }
}
