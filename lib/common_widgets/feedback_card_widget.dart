import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/custom_button_widget.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:kusel/images_path.dart';

import '../theme_manager/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FeedbackCardWidget extends StatefulWidget {
  const FeedbackCardWidget({super.key});

  @override
  State<FeedbackCardWidget> createState() => _FeedbackCardWidgetState();
}

class _FeedbackCardWidgetState extends State<FeedbackCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
                        fontSize: 13.sp,
                        color: Colors.white,
                        textOverflow: TextOverflow.visible,
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      textSemiBoldPoppins(
                        text: AppLocalizations.of(context).feedback_description,
                        color: Colors.white,
                        fontSize: 12.sp,
                        textAlign: TextAlign.start,
                        fontWeight: FontWeight.w200,
                        textOverflow: TextOverflow.visible,
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
                onPressed: () {},
                text: AppLocalizations.of(context).send_feedback,
                buttonColor: Theme.of(context).primaryColor),
          ),
          28.verticalSpace
        ],
      ),
    );
  }
}
