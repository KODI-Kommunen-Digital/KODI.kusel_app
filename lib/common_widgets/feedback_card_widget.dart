import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/custom_button_widget.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:kusel/images_path.dart';

class FeedbackCardWidget extends StatefulWidget {
  const FeedbackCardWidget({super.key});

  @override
  State<FeedbackCardWidget> createState() => _FeedbackCardWidgetState();
}

class _FeedbackCardWidgetState extends State<FeedbackCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF101534),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
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
                          text: "Wie findest du die App?",
                          fontSize: 14.sp,
                          color: Colors.white,
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(height: 8.h,),
                      textSemiBoldPoppins(
                          text:
                              "Fehlt dir noch etwas oder ist dir etwas aufgefallen? Lass es uns wissen, um die App stetig zu verbessern.",
                          color: Colors.white,
                          fontSize: 13.sp,
                          // textAlign: TextAlign.start,
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
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 15),
            child: CustomButton(onPressed: (){}, text: "Feedback senden", buttonColor: Color(0xFF283583),),
          ),
          SizedBox(height: 20.h,)
        ],
      ),
    );
  }
}
