import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kusel/common_widgets/image_utility.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:kusel/images_path.dart';

import '../app_router.dart';
import '../navigation/navigation.dart';
import '../screens/full_image/full_image_screen.dart';

class NetworkImageTextServiceCard extends ConsumerStatefulWidget {
  final Function() onTap;
  final String imageUrl;
  final String text;
  final String? description;

  const NetworkImageTextServiceCard(
      {super.key,
      required this.onTap,
      required this.imageUrl,
      required this.text,
      this.description});

  @override
  ConsumerState<NetworkImageTextServiceCard> createState() => _IconTextWidgetCardState();
}

class _IconTextWidgetCardState extends ConsumerState<NetworkImageTextServiceCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding:
              EdgeInsets.only(left: 2.w, right: 14.w, top: 20.h, bottom: 20.h),
          decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: BorderRadius.circular(15.r)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 3,
                child: ImageUtil.loadNetworkImage(
                    // onImageTap: () {
                    //   ref.read(navigationProvider).navigateUsingPath(
                    //       path: fullImageScreenPath,
                    //       params: FullImageScreenParams(
                    //         imageUrL: widget.imageUrl,
                    //       ),
                    //       context: context);
                    // },
                    fit: BoxFit.contain,
                    height: 30.h,
                    width: 30.w,
                    imageUrl: widget.imageUrl,
                    context: context),
              ),
              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    textBoldMontserrat(
                        text: widget.text,
                        textOverflow: TextOverflow.visible,
                        textAlign: TextAlign.start,
                        color: Theme.of(context).textTheme.bodyLarge?.color),
                    if(widget.description != null)
                        textRegularMontserrat(
                            text: widget.description ?? '',
                            fontSize: 11,
                            textOverflow: TextOverflow.visible,
                            textAlign: TextAlign.start)
                  ],
                ),
              ),
            SizedBox(
              height: 48,
              child: Image.asset(
                imagePath["link_icon"] ?? '',
                fit: BoxFit.contain,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
