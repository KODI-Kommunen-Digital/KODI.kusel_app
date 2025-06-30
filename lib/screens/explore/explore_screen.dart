import 'package:core/preference_manager/preference_constant.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/common_background_clipper_widget.dart';
import 'package:kusel/l10n/app_localizations.dart';
import 'package:kusel/screens/explore/explore_card_view.dart';
import 'package:kusel/screens/municipal_party_detail/widget/municipal_detail_screen_params.dart';

import '../../app_router.dart';
import '../../common_widgets/feedback_card_widget.dart';
import '../../common_widgets/text_styles.dart';
import '../../common_widgets/upstream_wave_clipper.dart';
import '../../images_path.dart';
import '../../navigation/navigation.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSecondary,
      body: _buildBody(context),
    );
  }

  _buildBody(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Column(
          children: [
            CommonBackgroundClipperWidget(
                clipperType: UpstreamWaveClipper(),
                imageUrl: imagePath['background_image'] ?? "",
                headingText: AppLocalizations.of(context).category_heading,
                height: 100.h,
                blurredBackground: true,
                isStaticImage: true),
            _buildExploreView(context),
            32.verticalSpace,
            FeedbackCardWidget(
              height: 270.h,
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

  _buildExploreView(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      String virtualTownHall = AppLocalizations.of(context).virtual_town_hall;
      String myDown = AppLocalizations.of(context).my_town;
      String tourism = AppLocalizations.of(context).tourism_and_leisure;
      String mobility = AppLocalizations.of(context).mobility;
      String getInvolved = AppLocalizations.of(context).get_involved;
      String digifit = AppLocalizations.of(context).digifit;

      List<String> exploreList = [
        virtualTownHall,
        myDown,
        tourism,
        mobility,
        getInvolved,
        digifit
      ];

      List<String> images = [
        "virtual_town_hall",
        "my_town",
        "tourism_and_lesiure",
        "mobility",
        "get_involved",
         "get_involved"
      ];

      return GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: exploreList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 5.w,
          mainAxisSpacing: 5.h,
          childAspectRatio: 1.1,
        ),
        itemBuilder: (context, index) {
          return ExploreGridCardView(
            imageName: images[index],
            title: exploreList[index],
            onTap: whereToNavigate(index),
          );
        },
      );
    });
  }

  whereToNavigate(int index) {
    void Function()? onTap;
    switch (index) {
      case 0:
        onTap = () {
          ref.read(navigationProvider).navigateUsingPath(
              path: virtualTownHallScreenPath, context: context);
        };
        break;
      case 1:
        onTap = () {
          final municipalId = ref
              .read(sharedPreferenceHelperProvider)
              .getInt(selectedMunicipalIdKey);

          if ((municipalId != null && municipalId != 0)) {
            ref.read(navigationProvider).navigateUsingPath(
                path: municipalDetailScreenPath,
                context: context,
                params: MunicipalDetailScreenParams(
                    municipalId: municipalId.toString(), onFavUpdate: null));
          } else {
            ref.read(navigationProvider).navigateUsingPath(
                  path: meinOrtScreenPath,
                  context: context,
                );
          }
        };
        break;
      case 2:
        onTap = () {
          ref.read(navigationProvider).navigateUsingPath(
                path: tourismScreenPath,
                context: context,
              );
          // showSoonServiceDialog(context);
        };
        break;
      case 3:
        onTap = () {
          ref.read(navigationProvider).navigateUsingPath(
                path: mobilityScreenPath,
                context: context,
              );
        };
        break;
      case 4:
        onTap = () {
          ref.read(navigationProvider).navigateUsingPath(
                path: participateScreenPath,
                context: context,
              );
        };
        break;
      case 5:
        onTap = () {
          ref.read(navigationProvider).navigateUsingPath(
            path: digifitStartScreenPath,
            context: context,
          );
        };
        break;
      default:
        onTap = null;
    }

    return onTap;
  }

  void showSoonServiceDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        content: textSemiBoldPoppins(
            text: AppLocalizations.of(context).soon_service, maxLines: 3),
        actions: [
          CupertinoDialogAction(
            child: textBoldPoppins(text: AppLocalizations.of(context).close),
            onPressed: () =>
                ref.read(navigationProvider).removeTopPage(context: context),
          ),
        ],
      ),
    );
  }
}
