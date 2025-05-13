import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/date_picker/date_picker_provider.dart';
import 'package:kusel/common_widgets/progress_indicator.dart';
import 'package:kusel/screens/all_city/all_city_screen_controller.dart';
import 'package:kusel/screens/all_event/all_event_screen_controller.dart';
import 'package:kusel/screens/fliter_screen/filter_screen.dart';
import 'package:kusel/screens/fliter_screen/filter_screen_controller.dart';

import '../../app_router.dart';
import '../../common_widgets/arrow_back_widget.dart';
import '../../common_widgets/common_event_card.dart';
import '../../common_widgets/downstream_wave_clipper.dart';
import '../../common_widgets/text_styles.dart';
import '../../common_widgets/upstream_wave_clipper.dart';
import '../../images_path.dart';
import '../../navigation/navigation.dart';
import '../../providers/favorites_list_notifier.dart';
import '../../theme_manager/colors.dart';
import '../event/event_detail_screen_controller.dart';
import '../municipal_party_detail/widget/place_of_another_community_card.dart';

class AllCityScreen extends ConsumerStatefulWidget {
  const AllCityScreen({super.key});

  @override
  ConsumerState<AllCityScreen> createState() => _AllCityScreenState();
}

class _AllCityScreenState extends ConsumerState<AllCityScreen> {
  @override
  void initState() {
    Future.microtask(() {
      ref.read(allCityScreenProvider.notifier).fetchCities();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: _buildBody(context),
    ).loaderDialog(context, ref.watch(allCityScreenProvider).isLoading);
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildClipper(context),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: ref.read(allCityScreenProvider).cityList.length,
                itemBuilder: (context, index) {
                  final item =
                      ref.read(allCityScreenProvider).cityList[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 12.w),
                    child: PlaceOfAnotherCommunityCard(
                      onTap: () {},
                      imageUrl: item.image ??
                          'https://images.unsplash.com/photo-1584713503693-bb386ec95cf2?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                      text: item.name ?? '',
                      isFav: false,
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }

  _buildClipper(context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.16,
          child: Stack(
            children: [
              ClipPath(
                clipper: UpstreamWaveClipper(),
                child: Container(
                  height: 270.h,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(imagePath['background_image'] ?? ''),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 30.h,
                left: 15.w,
                child: Row(
                  children: [
                    ArrowBackWidget(
                      onTap: () {
                        ref
                            .read(navigationProvider)
                            .removeTopPage(context: context);
                      },
                    ),
                    100.horizontalSpace,
                    textBoldPoppins(
                      color: lightThemeSecondaryColor,
                      fontSize: 18,
                      textAlign: TextAlign.center,
                      text: AppLocalizations.of(context).cities,
                    )
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
