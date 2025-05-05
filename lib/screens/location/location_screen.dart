import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/progress_indicator.dart';
import 'package:kusel/screens/location/bottom_sheet_screens/selected_filter_screen.dart';
import 'package:kusel/screens/location/location_screen_state.dart';
import 'package:latlong2/latlong.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'bottom_sheet_screens/all_filter_screen.dart';
import 'bottom_sheet_screens/selected_event_screen.dart';
import 'bottom_sheet_selected_ui_type.dart';
import 'location_screen_provider.dart';

class LocationScreen extends ConsumerStatefulWidget {
  const LocationScreen({super.key});

  @override
  ConsumerState<LocationScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<LocationScreen> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _buildBody(context),
      ),
    );
  }

  _buildBody(BuildContext context) {
    return SlidingUpPanel(
      minHeight: 200.h,
      maxHeight: 550.h,
      borderRadius: BorderRadius.vertical(top: Radius.circular(40.r)),
      controller: ref.read(locationScreenProvider).panelController,
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              onTap: (tapPosition, LatLng latLong) {},
              initialCenter: LatLng(49.53838, 7.40647),
              initialZoom: 14.0,
              interactionOptions: InteractionOptions(),
            ),
            children: [
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
              ),
              MarkerLayer(
                markers:
                    ref.watch(locationScreenProvider).allEventList.map((value) {
                  final lat = value.lat;
                  final long = value.long;

                  return Marker(
                    width: 35.w,
                    height: 35.h,
                    point: LatLng(lat!, long!),
                    child: InkWell(
                      onTap: (){
                        ref
                            .read(locationScreenProvider.notifier)
                            .setEventItem(value);
                        ref
                            .read(locationScreenProvider.notifier)
                            .updateBottomSheetSelectedUIType(
                            BottomSheetSelectedUIType.eventDetail);
                      },
                      child: Icon(Icons.location_pin,
                          size: 40.w,
                          color: Theme.of(context).colorScheme.onTertiaryFixed),
                    ),
                  );
                }).toList(),
              )
            ],
          ),

        ],
      ),
      panelBuilder: (controller) {

        return ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(40.r)),
          child: Container(
            color: Colors.transparent,
            child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: child,
          ),
          child: getBottomSheetUI(
            ref.watch(locationScreenProvider).bottomSheetSelectedUIType,
          ),
        ),
        ));
      },
    );
  }

  getBottomSheetUI(BottomSheetSelectedUIType type,) {
    late Widget widget;
    LocationScreenState locationScreenState = ref.watch(locationScreenProvider);
    switch (type) {
      case BottomSheetSelectedUIType.eventList:
        widget = SelectedFilterScreen(selectedFilterScreenParams: SelectedFilterScreenParams(categoryId: locationScreenState.selectedCategoryId ?? 0),);
        break;
      case BottomSheetSelectedUIType.eventDetail:
        widget = SelectedEventScreen();
        break;
      default:
        widget = AllFilterScreen();
        break;
    }
    return widget;
  }
}
