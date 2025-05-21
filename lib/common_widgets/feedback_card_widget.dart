import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/custom_button_widget.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:kusel/images_path.dart';

import '../theme_manager/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FeedbackCardWidget extends StatefulWidget {
  final Function() onTap;
  final double? height;
  FeedbackCardWidget({super.key, required this.onTap, this.height});

  @override
  State<FeedbackCardWidget> createState() => _FeedbackCardWidgetState();
}

class _FeedbackCardWidgetState extends State<FeedbackCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      color: lightThemeFeedbackCardColor,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 12.w),
            child: Row(
              children: [
                Image.asset(
                  imagePath['feedback_image.png'] ?? '',
                  height: 110.h,
                  width: 110.w,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textBoldPoppins(
                        fontWeight: FontWeight.w600,
                        text: AppLocalizations.of(context).feedback_heading,
                        fontSize: 13,
                        color: Colors.white,
                        textOverflow: TextOverflow.visible,
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 10.w),
                        child: textSemiBoldPoppins(
                          text: AppLocalizations.of(context).feedback_description,
                          color: Colors.white,
                          fontSize: 12,
                          textAlign: TextAlign.start,
                          fontWeight: FontWeight.w200,
                          textOverflow: TextOverflow.visible,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
            child: CustomButton(
                onPressed: widget.onTap,
                text: AppLocalizations.of(context).send_feedback,
                buttonColor: Theme.of(context).primaryColor),
          ),
          28.verticalSpace
        ],
      ),
    );
  }
}
