import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/app_router.dart';
import 'package:kusel/common_widgets/feedback_card_widget.dart';
import 'package:kusel/common_widgets/progress_indicator.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:kusel/screens/mobility_screen/mobility_screen_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common_widgets/arrow_back_widget.dart';
import '../../common_widgets/downstream_wave_clipper.dart';
import '../../common_widgets/image_utility.dart';
import '../../common_widgets/network_image_text_service_card.dart';
import '../../navigation/navigation.dart';

class MobilityScreen extends ConsumerStatefulWidget {
  const MobilityScreen({super.key});

  @override
  ConsumerState<MobilityScreen> createState() => _MobilityScreenState();
}

class _MobilityScreenState extends ConsumerState<MobilityScreen> {
  @override
  void initState() {
    Future.microtask(() {
      ref.read(mobilityScreenProvider.notifier).fetchMobilityDetails();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _buildBody(),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ).loaderDialog(context, ref.watch(mobilityScreenProvider).isLoading),
    );
  }

  _buildBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildClipperBackground(),
          _buildMobilityDescription(),
          _buildReadMoreSection(),
          _buildOffersList(),
          _taxiDetailsUi(),
          _buildContactDetailsList(),
          FeedbackCardWidget(onTap: () {
            ref
                .read(navigationProvider)
                .navigateUsingPath(path: feedbackScreenPath, context: context);
          })
        ],
      ),
    );
  }

  _buildMobilityDescription() {
    final state = ref.watch(mobilityScreenProvider);
    return Padding(
      padding: EdgeInsets.all(12.h.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textBoldPoppins(
              color: Theme.of(context).textTheme.bodyLarge?.color,
              text: state.mobilityData?.title ?? "_",
              fontSize: 16),
          10.verticalSpace,
          textBoldMontserrat(
              color: Theme.of(context).textTheme.bodyLarge?.color,
              textAlign: TextAlign.start,
              fontSize: 12,
              text: state.mobilityData?.description ?? "_",
              textOverflow: TextOverflow.visible)
        ],
      ),
    );
  }

  _buildReadMoreSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.h),
      child: Row(
        children: [
          textRegularMontserrat(
              text: AppLocalizations.of(context).read_more, fontSize: 12),
          4.horizontalSpace,
          Icon(Icons.keyboard_arrow_down_sharp)
        ],
      ),
    );
  }

  _buildClipperBackground() {
    final state = ref.watch(mobilityScreenProvider);
    return Stack(
      children: [
        ClipPath(
          clipper: DownstreamCurveClipper(),
          child: SizedBox(
            height: 270.h,
            width: MediaQuery.of(context).size.width,
            child: (state.mobilityData?.iconUrl != null)
                ? ImageUtil.loadNetworkImage(
                    imageUrl: state.mobilityData?.iconUrl ?? '',
                    context: context)
                : ImageUtil.loadNetworkImage(
                    context: context,
                    imageUrl:
                        "https://t4.ftcdn.net/jpg/03/45/71/65/240_F_345716541_NyJiWZIDd8rLehawiKiHiGWF5UeSvu59.jpg"),
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

  _buildOffersList() {
    final state = ref.watch(mobilityScreenProvider);
    return Padding(
      padding: EdgeInsets.all(12.h.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textBoldPoppins(
              text: AppLocalizations.of(context).our_communities,
              textAlign: TextAlign.start,
              fontSize: 14),
          if (state.mobilityData != null &&
              state.mobilityData!.servicesOffered!.isNotEmpty)
            ListView.builder(
                itemCount: state.mobilityData?.servicesOffered?.length ?? 0,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final item = state.mobilityData?.servicesOffered?[index];
                  return NetworkImageTextServiceCard(
                    onTap: () async {
                      final Uri uri = Uri.parse(
                          item?.linkUrl ?? 'https://www.landkreis-kusel.de');
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri);
                      }
                    },
                    imageUrl: item?.iconUrl ?? '',
                    text: item?.title ?? '_',
                    description: item?.description,
                  );
                })
        ],
      ),
    );
  }

  _phoneNumberCard({required Function() onTap, required String phoneNumber}) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding:
              EdgeInsets.only(left: 20.w, right: 14.w, top: 22.h, bottom: 22.h),
          decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: BorderRadius.circular(12.r)),
          child: Row(
            children: [
              Icon(
                Icons.call_outlined,
                size: 25.w,
                color: Theme.of(context).primaryColor,
              ),
              30.horizontalSpace,
              textBoldMontserrat(
                  text: phoneNumber,
                  color: Theme.of(context).textTheme.bodyLarge?.color)

              ////decoration: TextDecoration.underline,
            ],
          ),
        ),
      ),
    );
  }

  _taxiDetailsUi() {
    final state = ref.watch(mobilityScreenProvider);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          5.verticalSpace,
          if (state.mobilityData != null &&
              state.mobilityData!.moreInformations!.isNotEmpty)
            ListView.builder(
                itemCount: state.mobilityData?.moreInformations?.length ?? 0,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final item = state.mobilityData?.moreInformations?[index];
                  return _buildMoreInfoCard(
                      title: item?.title ?? '_',
                      phoneNumber: item?.phone ?? '_',
                      description: item?.description);
                })
        ],
      ),
    );
  }

  _buildMoreInfoCard(
      {required String title,
      required String phoneNumber,
      String? description}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        5.verticalSpace,
        textBoldPoppins(
          color: Theme.of(context).textTheme.bodyLarge?.color,
          text: title,
          fontSize: 14,
        ),
        8.verticalSpace,
        if (description != null)
          textRegularMontserrat(
              textAlign: TextAlign.start,
              fontSize: 12,
              color: Theme.of(context).textTheme.bodyLarge?.color,
              text: description,
              textOverflow: TextOverflow.visible),
        10.verticalSpace,
        _phoneNumberCard(onTap: () {}, phoneNumber: phoneNumber)
      ],
    );
  }

  _buildContactDetailsList() {
    final state = ref.watch(mobilityScreenProvider);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          20.verticalSpace,
          textBoldPoppins(
            textAlign: TextAlign.start,
            color: Theme.of(context).textTheme.bodyLarge?.color,
            text: AppLocalizations.of(context).your_contact_persons,
            fontSize: 14,
          ),
          15.verticalSpace,
          if (state.mobilityData != null &&
              state.mobilityData!.contactDetails!.isNotEmpty)
            ListView.builder(
                itemCount: state.mobilityData?.contactDetails?.length ?? 0,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final item = state.mobilityData?.contactDetails?[index];
                  return _contactDetailsCard(
                      onTap: () {},
                      heading: item?.title ?? "_",
                      phoneNumber: item?.phone ?? '_',
                      email: item?.email ?? "_");
                }),
          25.verticalSpace
        ],
      ),
    );
  }

  _contactDetailsCard(
      {required Function() onTap,
      required String heading,
      required String phoneNumber,
      required String email}) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
            padding: EdgeInsets.only(
                left: 20.w, right: 14.w, top: 22.h, bottom: 22.h),
            decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.circular(12.r)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textBoldMontserrat(
                  text: heading,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
                15.verticalSpace,
                Row(
                  children: [
                    Icon(
                      Icons.call_outlined,
                      size: 14.h.w,
                      color: Theme.of(context).primaryColor,
                    ),
                    20.horizontalSpace,
                    textBoldMontserrat(
                        text: phoneNumber,
                        color: Theme.of(context).textTheme.bodyLarge?.color)
                    //decoration: TextDecoration.underline,
                  ],
                ),
                14.verticalSpace,
                Row(
                  children: [
                    Icon(
                      Icons.email_outlined,
                      size: 16.h.w,
                      color: Theme.of(context).primaryColor,
                    ),
                    20.horizontalSpace,
                    textBoldMontserrat(
                        text: email,
                        color: Theme.of(context).textTheme.bodyLarge?.color)
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
