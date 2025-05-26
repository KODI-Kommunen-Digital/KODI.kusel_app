import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/app_router.dart';
import 'package:kusel/common_widgets/custom_button_widget.dart';
import 'package:kusel/common_widgets/downstream_wave_clipper.dart';
import 'package:kusel/common_widgets/feedback_card_widget.dart';
import 'package:kusel/common_widgets/progress_indicator.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kusel/screens/participate_screen/participate_screen_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common_widgets/arrow_back_widget.dart';
import '../../common_widgets/common_background_clipper_widget.dart';
import '../../common_widgets/common_contact_details_card.dart';
import '../../common_widgets/image_utility.dart';
import '../../common_widgets/network_image_text_service_card.dart';
import '../../navigation/navigation.dart';
import '../../utility/url_launcher_utility.dart';

class ParticipateScreen extends ConsumerStatefulWidget {
  const ParticipateScreen({super.key});

  @override
  ConsumerState<ParticipateScreen> createState() => _ParticipateScreenState();
}

class _ParticipateScreenState extends ConsumerState<ParticipateScreen> {
  @override
  void initState() {
    Future.microtask(() {
      ref.read(participateScreenProvider.notifier).fetchParticipateDetails();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    ).loaderDialog(context, ref.watch(participateScreenProvider).isLoading);
  }

  _buildBody() {
    final state = ref.watch(participateScreenProvider);

    return SafeArea(
      child: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Column(
          children: [
            CommonBackgroundClipperWidget(
                clipperType: DownstreamCurveClipper(),
                imageUrl: state.participateData?.iconUrl ??
                    'https://t4.ftcdn.net/jpg/03/45/71/65/240_F_345716541_NyJiWZIDd8rLehawiKiHiGWF5UeSvu59.jpg',
                isBackArrowEnabled: true,
                isStaticImage: false),
            _buildParticipateDescription(),
            _buildParticipateList(),
            if (state.participateData != null &&
                state.participateData!.moreInformations!.isNotEmpty)
              ListView.builder(
                  itemCount: state.participateData?.moreInformations?.length ?? 0,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final item = state.participateData?.moreInformations?[index];
                    return _buildInfoMessage(
                        heading: item?.title ?? '_',
                        description: item?.description ?? "_");
                  }),
            _buildContactDetailsList(),
            FeedbackCardWidget(
                height: 270.h,
                onTap: () {
              ref
                  .read(navigationProvider)
                  .navigateUsingPath(path: feedbackScreenPath, context: context);
            })
          ],
        ),
      ),
    );
  }

  _buildParticipateDescription() {
    final state = ref.read(participateScreenProvider);
    return Padding(
      padding: EdgeInsets.all(12.h.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textBoldPoppins(
              color: Theme.of(context).textTheme.bodyLarge?.color,
              text: state.participateData?.title ?? "_",
              textOverflow: TextOverflow.visible,
              textAlign: TextAlign.left,
              fontSize: 16),
          10.verticalSpace,
          textBoldMontserrat(
              color: Theme.of(context).textTheme.bodyLarge?.color,
              textAlign: TextAlign.start,
              fontSize: 12,
              text: AppLocalizations.of(context).develop_kusel_together_text,
              textOverflow: TextOverflow.visible),
          10.verticalSpace,
          textRegularMontserrat(
              textAlign: TextAlign.start,
              text: state.participateData?.description ?? "_",
              textOverflow: TextOverflow.visible),
          8.verticalSpace,
          CustomButton(
              onPressed: () {},
              text: AppLocalizations.of(context).register_here)
        ],
      ),
    );
  }

  _buildParticipateList() {
    final state = ref.read(participateScreenProvider);

    return Padding(
      padding: EdgeInsets.all(12.h.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textBoldPoppins(
              text: AppLocalizations.of(context).participate,
              textAlign: TextAlign.start,
              fontSize: 14),
          10.verticalSpace,
          if (state.participateData != null &&
              state.participateData!.servicesOffered!.isNotEmpty)
            ListView.builder(
                itemCount: state.participateData?.servicesOffered?.length ?? 0,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final item = state.participateData?.servicesOffered?[index];
                  return NetworkImageTextServiceCard(
                    onTap: () => UrlLauncherUtil.launchWebUrl(
                        url: item?.linkUrl ?? 'https://www.landkreis-kusel.de'),
                    imageUrl: item?.iconUrl ?? '',
                    text: item?.title ?? '_',
                    description: item?.description,
                  );
                })
        ],
      ),
    );
  }

  _buildInfoMessage({required String heading, required String description}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          8.verticalSpace,
          textBoldPoppins(
              text: heading,
              fontSize: 15,
              textAlign: TextAlign.left,
              textOverflow: TextOverflow.visible),
          10.verticalSpace,
          textRegularMontserrat(
              textAlign: TextAlign.left,
              text: description,
              textOverflow: TextOverflow.visible)
        ],
      ),
    );
  }

  _buildContactDetailsList() {
    final state = ref.read(participateScreenProvider);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          35.verticalSpace,
          textBoldPoppins(
            textAlign: TextAlign.start,
            color: Theme.of(context).textTheme.bodyLarge?.color,
            text: AppLocalizations.of(context).your_contact_persons,
            fontSize: 14,
          ),
          15.verticalSpace,
          if (state.participateData != null &&
              state.participateData!.contactDetails!.isNotEmpty)
            ListView.builder(
                itemCount: state.participateData?.contactDetails?.length ?? 0,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final item = state.participateData?.contactDetails?[index];
                  return CommonContactDetailsCard(
                      onTap: () {},
                      heading: item?.title ?? "_",
                      phoneNumber: item?.phone ?? '_',
                      email: item?.email ?? "_");
                }),
          15.verticalSpace,
        ],
      ),
    );
  }
}
