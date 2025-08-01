import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/common_background_clipper_widget.dart';
import 'package:kusel/common_widgets/feedback_card_widget.dart';
import 'package:kusel/common_widgets/progress_indicator.dart';
import 'package:kusel/common_widgets/upstream_wave_clipper.dart';

import '../../../app_router.dart';
import '../../../common_widgets/device_helper.dart';
import '../../../common_widgets/digifit/brain_teaser_game/game_text_card.dart';
import '../../../common_widgets/text_styles.dart';
import '../../../images_path.dart';
import '../../../l10n/app_localizations.dart';
import '../../../navigation/navigation.dart';
import 'game_list_controller.dart';

class BrainTeaserGameListScreen extends ConsumerStatefulWidget {
  const BrainTeaserGameListScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _BrainTeaserGameListScreenState();
  }
}

class _BrainTeaserGameListScreenState
    extends ConsumerState<BrainTeaserGameListScreen> {
  @override
  void initState() {
    Future.microtask(() {
      ref
          .read(brainTeaserGameListControllerProvider.notifier)
          .fetchBrainTeaserGameList();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var state = ref.read(brainTeaserGameListControllerProvider);
    final brainTeaserGameList = state.brainTeaserGameListDataModel?.games ?? [];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Stack(
            children: [
              CommonBackgroundClipperWidget(
                  height: 220.h,
                  clipperType: UpstreamWaveClipper(),
                  imageUrl: imagePath['home_screen_background'] ?? '',
                  isStaticImage: true),
              Positioned(
                  top: 50.h, left: 10.r, child: _buildHeadingArrowSection()),
              Padding(
                padding: EdgeInsets.only(top: 125.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ...brainTeaserGameList.map((game) =>  _buildBrainTeaserGameListUi()),
                    _buildBrainTeaserGameListUi(),
                    30.verticalSpace,
                    FeedbackCardWidget(
                      height: 270.h,
                      onTap: () {
                        ref.read(navigationProvider).navigateUsingPath(
                            path: feedbackScreenPath, context: context);
                      },
                    ),
                  ],
                ),
              )
            ],
          ).loaderDialog(context,
              ref.read(brainTeaserGameListControllerProvider).isLoading),
        ),
      ),
    );
  }

  _buildHeadingArrowSection() {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            ref.read(navigationProvider).removeTopPage(context: context);
          },
          icon: Icon(
              size: DeviceHelper.isMobile(context) ? null : 12.h.w,
              Icons.arrow_back,
              color: Theme.of(context).primaryColor),
        ),
        10.horizontalSpace,
        textBoldPoppins(
          fontWeight: FontWeight.w600,
          fontSize: 20,
          text: AppLocalizations.of(context).brain_teasers_list_title,
        ),
      ],
    );
  }

  // TODO:- Uncomment this code once the API will Deployed....
  // _buildBrainTeaserGameListUi() {
  //   var state = ref.read(brainTeaserGameListControllerProvider);
  //   final sourceId = state.brainTeaserGameListDataModel?.sourceId ?? 1;
  //   final brainTeaserGameList = state.brainTeaserGameListDataModel?.games ?? [];
  //   return ListView.builder(
  //       physics: NeverScrollableScrollPhysics(),
  //       shrinkWrap: true,
  //       itemCount: brainTeaserGameList.length,
  //       itemBuilder: (context, index) {
  //         var games = brainTeaserGameList[index];
  //         return Padding(
  //             padding: EdgeInsets.only(bottom: 5.h),
  //             child: GameTeaserTextCard(
  //                 imageUrl: games.gameImageUrl ?? '',
  //                 name: games.name ?? '',
  //                 subDescription: games.subDescription ?? '',
  //                 backButton: true,
  //                 isCompleted: false,
  //                 sourceId: sourceId));
  //       });
  // }

  // TODO:- Static Data List...
  _buildBrainTeaserGameListUi() {
    var state = ref.read(brainTeaserGameListControllerProvider);
    final sourceId = state.brainTeaserGameListDataModel?.sourceId ?? 1;
    final brainTeaserGameList = state.brainTeaserGameListDataModel?.games ?? [];
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 5,
        itemBuilder: (context, index) {
          // var games = brainTeaserGameList[index];
          return Padding(
              padding: EdgeInsets.only(bottom: 5.h),
              child: GameTeaserTextCard(
                  imageUrl: "",
                  name: 'Boldifänger',
                  subDescription: 'Kurzbeschreibung',
                  backButton: true,
                  isCompleted: false,
                  sourceId: sourceId));
        });
  }
}
