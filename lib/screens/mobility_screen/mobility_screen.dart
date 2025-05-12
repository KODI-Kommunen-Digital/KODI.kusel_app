import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/app_router.dart';
import 'package:kusel/common_widgets/feedback_card_widget.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:kusel/images_path.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../common_widgets/arrow_back_widget.dart';
import '../../common_widgets/downstream_wave_clipper.dart';
import '../../common_widgets/icon_text_widget_card.dart';
import '../../navigation/navigation.dart';

class MobilityScreen extends ConsumerStatefulWidget {
  const MobilityScreen({super.key});

  @override
  ConsumerState<MobilityScreen> createState() => _MobilityScreenState();
}

class _MobilityScreenState extends ConsumerState<MobilityScreen> {
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
    return Padding(
      padding: EdgeInsets.all(12.h.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textBoldPoppins(
              color: Theme.of(context).textTheme.bodyLarge?.color,
              text: AppLocalizations.of(context).mobility,
              fontSize: 16),
          10.verticalSpace,
          textBoldMontserrat(
              color: Theme.of(context).textTheme.bodyLarge?.color,
              textAlign: TextAlign.start,
              fontSize: 12,
              text:
                  "Der Landkreis Kusel ist nach dem rheinland-pfälzischen Nahverkehrsgesetz für die Ausgestaltung des Öffentlichen Personennahverkehrs ÖPNV zuständig. In den ÖPNV sind auch die Schülerverkehre sowie die Fahrten zu Kindertagesstätten zu den jeweiligen Standorten im Landkreis Kusel integriert.",
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
          textRegularMontserrat(text: "Weiterlesen", fontSize: 12),
          4.horizontalSpace,
          Icon(Icons.keyboard_arrow_down_sharp)
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
                image: AssetImage(imagePath["mobility"] ?? ''),
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

  _buildOffersList() {
    return Padding(
      padding: EdgeInsets.all(12.h.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textBoldPoppins(
              text: "Unsere Angebote",
              textAlign: TextAlign.start,
              fontSize: 14),
          IconTextWidgetCard(
            onTap: () async {
              // final Uri uri =
              // Uri.parse(item.linkUrl ?? "https://google.com");
              // if (await canLaunchUrl(uri)) {
              //   await launchUrl(uri);
              // }
            },
            imageUrl: 'https://picsum.photos/200',
            text: 'Ruftaxi',
          ),
          IconTextWidgetCard(
            onTap: () async {
              // final Uri uri =
              // Uri.parse(item.linkUrl ?? "https://google.com");
              // if (await canLaunchUrl(uri)) {
              //   await launchUrl(uri);
              // }
            },
            imageUrl: 'https://picsum.photos/200',
            text: 'Mitfahrersuche',
          ),
          IconTextWidgetCard(
            onTap: () async {
              // final Uri uri =
              // Uri.parse(item.linkUrl ?? "https://google.com");
              // if (await canLaunchUrl(uri)) {
              //   await launchUrl(uri);
              // }
            },
            imageUrl: 'https://picsum.photos/200',
            text: 'Bürgerbus',
          ),
          IconTextWidgetCard(
            onTap: () async {
              // final Uri uri =
              // Uri.parse(item.linkUrl ?? "https://google.com");
              // if (await canLaunchUrl(uri)) {
              //   await launchUrl(uri);
              // }
            },
            imageUrl: 'https://picsum.photos/200',
            text: 'Jugendtaxi',
            description: "Komm gud hääm!",
          ),
          IconTextWidgetCard(
            onTap: () async {
              // final Uri uri =
              // Uri.parse(item.linkUrl ?? "https://google.com");
              // if (await canLaunchUrl(uri)) {
              //   await launchUrl(uri);
              // }
            },
            imageUrl: 'https://picsum.photos/200',
            text: "Schülerbeförderung",
          ),
          IconTextWidgetCard(
            onTap: () async {
              // final Uri uri =
              // Uri.parse(item.linkUrl ?? "https://google.com");
              // if (await canLaunchUrl(uri)) {
              //   await launchUrl(uri);
              // }
            },
            imageUrl: 'https://picsum.photos/200',
            text: 'Jugendtaxi',
            description: "Komm gud hääm!",
          ),
          IconTextWidgetCard(
            onTap: () async {
              // final Uri uri =
              // Uri.parse(item.linkUrl ?? "https://google.com");
              // if (await canLaunchUrl(uri)) {
              //   await launchUrl(uri);
              // }
            },
            imageUrl: 'https://picsum.photos/200',
            text: 'Das Deutschlandticket',
            description: "Mobil mit der Bahn",
          )
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
                  decoration: TextDecoration.underline,
                  color: Theme.of(context).textTheme.bodyLarge?.color)
            ],
          ),
        ),
      ),
    );
  }

  _taxiDetailsUi() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          5.verticalSpace,
          textBoldPoppins(
              textAlign: TextAlign.left,
              fontSize: 14,
              color: Theme.of(context).textTheme.bodyLarge?.color,
              text: "Fahrplanauskunft und Ruftaxibuchungen rund um die Uhr",
              textOverflow: TextOverflow.visible),
          10.verticalSpace,
          _phoneNumberCard(onTap: () {}, phoneNumber: "0621 1077077"),
          5.verticalSpace,
          textBoldPoppins(
            color: Theme.of(context).textTheme.bodyLarge?.color,
            text: "Mobilitätszentrale",
            fontSize: 14,
          ),
          8.verticalSpace,
          textRegularMontserrat(
              textAlign: TextAlign.start,
              fontSize: 12,
              color: Theme.of(context).textTheme.bodyLarge?.color,
              text:
                  "Bei weiteren Rückfragen zum Bus- und Ruftaxiangebot wenden Sie sich gerne an die Mobilitätszentrale des Landkreises ",
              textOverflow: TextOverflow.visible),
          10.verticalSpace,
          _phoneNumberCard(onTap: () {}, phoneNumber: "0621 1077077")
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
          20.verticalSpace,
          textBoldPoppins(
            textAlign: TextAlign.start,
            color: Theme.of(context).textTheme.bodyLarge?.color,
            text: "Deine Ansprechpartner:innen",
            fontSize: 14,
          ),
          15.verticalSpace,
          _contactDetailsCard(
              onTap: () {},
              heading: "Wolfgang Borm",
              phoneNumber: "06831 424-240",
              email: "wolfgang.borm@kv-kus.de"),
          10.verticalSpace,
          _contactDetailsCard(
              onTap: () {},
              heading: "Mathias Börtzler",
              phoneNumber: "06831 424-240",
              email: "wolfgang.borm@kv-kus.de"),
          10.verticalSpace,
          _contactDetailsCard(
              onTap: () {},
              heading: "Manuela Weber",
              phoneNumber: "06831 424-240",
              email: "wolfgang.borm@kv-kus.de"),
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
          padding:
              EdgeInsets.only(left: 20.w, right: 14.w, top: 22.h, bottom: 22.h),
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
                      color: Theme.of(context).textTheme.bodyLarge?.color
                  )
                ],
              ),
            ],
          )
        ),
      ),
    );
  }
}
