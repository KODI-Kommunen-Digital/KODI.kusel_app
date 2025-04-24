import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/screens/location/bottom_sheet_selected_ui_type.dart';
import 'package:kusel/screens/location/location_screen_provider.dart';

class SelectedFilterScreen extends ConsumerStatefulWidget {
  SelectedFilterScreenParams selectedFilterScreenParams;

  SelectedFilterScreen({super.key, required this.selectedFilterScreenParams});

  @override
  ConsumerState<SelectedFilterScreen> createState() =>
      _SelectedFilterScreenState();
}

class _SelectedFilterScreenState extends ConsumerState<SelectedFilterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).splashColor,
      body: _buildBody(context),
    );
  }

  _buildBody(BuildContext context) {
    return Column(
      children: [
        16.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
                onPressed: () {
                  ref
                      .read(locationScreenProvider.notifier)
                      .updateBottomSheetSelectedUIType(
                          BottomSheetSelectedUIType.allEvent);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Theme.of(context).textTheme.labelMedium!.color,
                )),
            80.horizontalSpace,
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 5.h,
                width: 100.w,
                decoration: BoxDecoration(
                    color: Theme.of(context).textTheme.labelMedium!.color,
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        )
      ],
    );
  }
}

class SelectedFilterScreenParams {
  int categoryId;

  SelectedFilterScreenParams({required this.categoryId});
}
