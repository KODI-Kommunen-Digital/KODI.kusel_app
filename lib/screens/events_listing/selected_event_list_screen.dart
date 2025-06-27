import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:kusel/common_widgets/upstream_wave_clipper.dart';
import 'package:kusel/screens/events_listing/selected_event_list_screen_controller.dart';
import 'package:kusel/screens/events_listing/selected_event_list_screen_parameter.dart';

import '../../common_widgets/arrow_back_widget.dart';
import '../../common_widgets/common_background_clipper_widget.dart';
import '../../common_widgets/event_list_section_widget.dart';
import '../../images_path.dart';
import '../../navigation/navigation.dart';
import 'selected_event_list_screen_state.dart';

class SelectedEventListScreen extends ConsumerStatefulWidget {
  final SelectedEventListScreenParameter eventListScreenParameter;

  const SelectedEventListScreen(
      {super.key, required this.eventListScreenParameter});

  @override
  ConsumerState<SelectedEventListScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<SelectedEventListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(selectedEventListScreenProvider.notifier)
          .getEventsList(widget.eventListScreenParameter);

      ref.read(selectedEventListScreenProvider.notifier).isUserLoggedIn();
    });
  }

  @override
  Widget build(BuildContext context) {
    final SelectedEventListScreenState categoryScreenState =
    ref.watch(selectedEventListScreenProvider);
    return Scaffold(
      backgroundColor: Theme
          .of(context)
          .scaffoldBackgroundColor,
      body: categoryScreenState.loading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(child: _buildBody(categoryScreenState, context)),
    );
  }

  Widget _buildBody(SelectedEventListScreenState categoryScreenState,
      BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Column(
            children: [
              CommonBackgroundClipperWidget(
                clipperType: UpstreamWaveClipper(),
                height: 130.h,
                imageUrl: imagePath['home_screen_background'] ?? '',
                isStaticImage: true,
                isBackArrowEnabled: false,
                headingText: categoryScreenState.heading,
              ),
              if (!ref
                  .watch(selectedEventListScreenProvider)
                  .loading)
                ref
                    .watch(selectedEventListScreenProvider)
                    .eventsList
                    .isEmpty
                    ? Center(
                  child: textHeadingMontserrat(
                      text: AppLocalizations
                          .of(context)
                          .no_data),
                )
                    : EventsListSectionWidget(
                  eventsList:
                  ref
                      .watch(selectedEventListScreenProvider)
                      .eventsList,
                  heading: null,
                  maxListLimit: ref
                      .watch(selectedEventListScreenProvider)
                      .eventsList
                      .length,
                  buttonText: null,
                  buttonIconPath: null,
                  isLoading: false,
                  onButtonTap: () {},
                  context: context,
                  isFavVisible: ref
                      .watch(selectedEventListScreenProvider)
                      .isUserLoggedIn,
                  onHeadingTap: () {},
                  onFavClickCallback: () {
                    ref
                        .read(selectedEventListScreenProvider.notifier)
                        .getEventsList(widget.eventListScreenParameter);
                  },
                  onSuccess: (bool isFav, int? id) {
                    ref
                        .read(selectedEventListScreenProvider.notifier)
                        .updateIsFav(isFav, id);

                    widget.eventListScreenParameter.onFavChange();
                  },
                )
            ],
          ),
        ),
        Positioned(
          top: 30.h,
          left: 15.h,
          child: ArrowBackWidget(
            onTap: () {
              ref.read(navigationProvider).removeTopPage(context: context);
            },
          ),
        ),
      ],
    );
  }
}
