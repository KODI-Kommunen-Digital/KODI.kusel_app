import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app_router.dart';
import '../../../images_path.dart';
import '../../../navigation/navigation.dart';
import '../../../screens/full_image/full_image_screen.dart';
import '../../device_helper.dart';
import '../../image_utility.dart';
import '../../text_styles.dart';

class GameTeaserTextCard extends ConsumerStatefulWidget {
  final String imageUrl;
  final String name;
  final String subDescription;
  final int sourceId;
  final bool backButton;
  final VoidCallback? onCardTap;
  final bool isCompleted;

  const GameTeaserTextCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.subDescription,
    required this.sourceId,
    required this.backButton,
    this.onCardTap,
    required this.isCompleted,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CommonEventCardState();
}

class _CommonEventCardState extends ConsumerState<GameTeaserTextCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 12.w, right: 10.w),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: widget.onCardTap,
        child: Card(
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
          elevation: 4,
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.all(5.h.w),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: ImageUtil.loadNetworkImage(
                          onImageTap: () {
                            ref.read(navigationProvider).navigateUsingPath(
                                path: fullImageScreenPath,
                                params: FullImageScreenParams(
                                    imageUrL: widget.imageUrl,
                                    sourceId: widget.sourceId),
                                context: context);
                          },
                          height: 75.h,
                          width: 80.w,
                          imageUrl: widget.imageUrl,
                          sourceId: widget.sourceId,
                          context: context),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          textSemiBoldMontserrat(
                              text: widget.name,
                              fontWeight: FontWeight.w600,
                              fontSize: 14),
                          4.verticalSpace,
                          textRegularMontserrat(
                              text: widget.subDescription,
                              textAlign: TextAlign.start,
                              fontSize: 12,
                              textOverflow: TextOverflow.visible),
                          4.verticalSpace,
                        ],
                      ),
                    ),
                    Visibility(
                      visible: widget.backButton,
                      child: Icon(
                        size: DeviceHelper.isMobile(context) ? null : 12.h.w,
                        Icons.arrow_forward,
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                    10.horizontalSpace,
                  ],
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: Visibility(
                    visible: widget.isCompleted ?? false,
                    child: Container(
                      height: 32.h,
                      width: 40.w,
                      decoration: BoxDecoration(
                          color: Theme.of(context).indicatorColor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.r),
                              bottomRight: Radius.circular(10.r))),
                      child: Center(
                        child: SizedBox(
                          child: ImageUtil.loadSvgImage(
                              height: 18.h,
                              width: 18.h,
                              imageUrl: imagePath['digifit_trophy_icon'] ?? '',
                              context: context),
                        ),
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
