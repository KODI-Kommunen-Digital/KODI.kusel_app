import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/app_router.dart';
import 'package:kusel/common_widgets/custom_button_widget.dart';
import 'package:kusel/common_widgets/downstream_wave_clipper.dart';
import 'package:kusel/common_widgets/feedback_card_widget.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:kusel/images_path.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../common_widgets/arrow_back_widget.dart';
import '../../common_widgets/icon_text_widget_card.dart';
import '../../navigation/navigation.dart';

class ParticipateScreen extends ConsumerStatefulWidget {
  const ParticipateScreen({super.key});

  @override
  ConsumerState<ParticipateScreen> createState() => _ParticipateScreenState();
}

class _ParticipateScreenState extends ConsumerState<ParticipateScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _buildBody(),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
    );
  }

  _buildBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildClipperBackground(),
          _buildParticipateDescription(),
          _buildParticipateList(),
          _buildInfoMessage(),
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

  _buildClipperBackground() {
    return Stack(
      children: [
        ClipPath(
          clipper: DownstreamCurveClipper(),
          child: Container(
            height: 270.h,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imagePath["participate_image"] ?? ''),
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

  _buildParticipateDescription() {
    return Padding(
      padding: EdgeInsets.all(12.h.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textBoldPoppins(
              color: Theme.of(context).textTheme.bodyLarge?.color,
              text: "GESTALTE DIE ZUKUNFT DES LANDKREISES KUSEL MIT",
              textOverflow: TextOverflow.visible,
              textAlign: TextAlign.left,
              fontSize: 16),
          10.verticalSpace,
          textBoldMontserrat(
              color: Theme.of(context).textTheme.bodyLarge?.color,
              textAlign: TextAlign.start,
              fontSize: 12,
              text:
                  "Wir möchten gemeinsam den Landkreis Kusel weiterentwickeln.",
              textOverflow: TextOverflow.visible),
          10.verticalSpace,
          textRegularMontserrat(
              textAlign: TextAlign.start,
              text:
                  "Deine Ideen und Meinungen sind der Schlüssel, um unsere Region zukunftsfähig zu gestalten. Bring Dich ein und gestalte aktiv mit!",
              textOverflow: TextOverflow.visible),
          8.verticalSpace,
          CustomButton(onPressed: () {}, text: "Hier anmelden")
        ],
      ),
    );
  }

  _buildParticipateList() {
    return Padding(
      padding: EdgeInsets.all(12.h.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textBoldPoppins(
              text: "MITMACHEN",
              textAlign: TextAlign.start,
              fontSize: 14),
          10.verticalSpace,
          IconTextWidgetCard(
            onTap: () async {
              // final Uri uri =
              // Uri.parse(item.linkUrl ?? "https://google.com");
              // if (await canLaunchUrl(uri)) {
              //   await launchUrl(uri);
              // }
            },
            imageUrl: 'chat_icon',
            text: 'Jetzt mitmachen!',
            description: "So funktioniert’s",
          ),
          IconTextWidgetCard(
            onTap: () async {
              // final Uri uri =
              // Uri.parse(item.linkUrl ?? "https://google.com");
              // if (await canLaunchUrl(uri)) {
              //   await launchUrl(uri);
              // }
            },
            imageUrl: 'alert_icon',
            text: 'Aktive Projekte',
          ),
          IconTextWidgetCard(
            onTap: () async {
              // final Uri uri =
              // Uri.parse(item.linkUrl ?? "https://google.com");
              // if (await canLaunchUrl(uri)) {
              //   await launchUrl(uri);
              // }
            },
            imageUrl: 'man_icon_2',
            text: 'Zur Anmeldung',
          ),
        ],
      ),
    );
  }

  _buildInfoMessage() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          8.verticalSpace,
          textBoldPoppins(
              text: "MACH MIT UND GESTALTE DIE ZUKUNFT DES LANDKREISES KUSEL!",
              fontSize: 15,
              textAlign: TextAlign.left,
              textOverflow: TextOverflow.visible),
          10.verticalSpace,
          textRegularMontserrat(
              textAlign: TextAlign.left,
              text:
                  "Auf dieser Plattform kannst du Ideen einbringen, Projekte unterstützen und über wichtige Themen abstimmen. Du möchtest wissen, wie das genau funktioniert? Hier erfährst Du alles, was Du zur Anmeldung und Teilhabe wissen musst - ganz einfach erklärt!",
              textOverflow: TextOverflow.visible)
        ],
      ),
    );
  }

  _buildContactDetailsList() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          35.verticalSpace,
          textBoldPoppins(
            textAlign: TextAlign.start,
            color: Theme.of(context).textTheme.bodyLarge?.color,
            text: "Deine Ansprechpartner:innen",
            fontSize: 14,
          ),
          15.verticalSpace,
          _contactDetailsCard(
              onTap: () {},
              heading: "Nadine Kropp-Meyer",
              phoneNumber: "0170 9306507",
              email: "email@mail.de"),
          15.verticalSpace,
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
                        decoration: TextDecoration.underline,
                        color: Theme.of(context).textTheme.bodyLarge?.color)
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
