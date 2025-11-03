import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/progress_indicator.dart';
import 'package:kusel/screens/digifit_screens/digifit_fav_screen/digifit_fav_controller.dart';
import 'package:kusel/screens/digifit_screens/digifit_start/digifit_information_controller.dart';

import '../../../common_widgets/common_background_clipper_widget.dart';
import '../../../common_widgets/digifit/digifit_text_image_card.dart';
import '../../../common_widgets/text_styles.dart';
import '../../../common_widgets/upstream_wave_clipper.dart';
import '../../../images_path.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/digifit_equipment_fav_provider.dart';

class DigifitFavScreen extends ConsumerStatefulWidget {
  const DigifitFavScreen({super.key});

  @override
  ConsumerState<DigifitFavScreen> createState() => _DigifitFavScreenState();
}

class _DigifitFavScreenState extends ConsumerState<DigifitFavScreen> {
  @override
  void initState() {
    Future.microtask(() {
      ref.read(digifitFavControllerProvider.notifier).getDigifitFavList();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(digifitFavControllerProvider);
    final controller = ref.read(digifitFavControllerProvider.notifier);

    return PopScope(
      onPopInvokedWithResult: (value,_){
        ref.read(digifitInformationControllerProvider.notifier).fetchDigifitInformation();
      },
      child: Scaffold(
        body: (state.isLoading)
            ? Center(
                child: CircularProgressIndicator(),
              )
            : _buildBody(context),
      ),
    );
  }

  _buildBody(BuildContext context) {
    final state = ref.watch(digifitFavControllerProvider);
    final controller = ref.read(digifitFavControllerProvider.notifier);

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          CommonBackgroundClipperWidget(
              clipperType: UpstreamWaveClipper(),
              imageUrl: imagePath['background_image'] ?? "",
              headingText: AppLocalizations.of(context).favorites,
              height: 120.h,
              blurredBackground: true,
              isBackArrowEnabled: true,
              isStaticImage: true),
          (state.equipmentList.isEmpty)
              ? Center(
                  child: textHeadingMontserrat(
                      text: AppLocalizations.of(context).no_data, fontSize: 18),
                )
              : Expanded(
                  child: ListView.builder(
                      itemCount: state.equipmentList.length,
                      itemBuilder: (context, index) {
                        final station = state.equipmentList[index];
                        return Padding(
                          padding: EdgeInsets.only(bottom: 10.h,left: 12.w,right: 12.w),
                          child: DigifitTextImageCard(
                            onCardTap: () {},
                            imageUrl: station.mapImageUrl ?? '',
                            heading: station.muscleGroup ?? '',
                            title: station.name ?? '',
                            isFavouriteVisible: true,
                            isFavorite: station.isFavorite ?? false,
                            sourceId: 1,
                            isCompleted: station.isCompleted??true,
                            //station.,
                            onFavorite: () async {
                              DigifitEquipmentFavParams params =
                                  DigifitEquipmentFavParams(
                                      isFavorite: !station.isFavorite!,
                                      equipmentId: station.equipmentId!,
                                      locationId: station.locationId!);

                              await ref
                                  .read(digifitFavControllerProvider.notifier)
                                  .changeFav(params);
                            },
                          ),
                        );
                      }),
                )
        ],
      ),
    );
  }
}
