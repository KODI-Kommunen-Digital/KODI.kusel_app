import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:kusel/theme_manager/colors.dart';

import '../images_path.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final double? height;
  final double? width;
  final double? iconHeight;
  final double? iconWidth;
  final String? icon;
  final bool isOutLined;
  final Color? buttonColor;
  final Color? textColor;
  final double? textSize;
  final Color? borderColor;

  const CustomButton(
      {super.key,
      required this.onPressed,
      required this.text,
      this.height,
      this.width,
      this.iconHeight,
      this.iconWidth,
      this.icon,
      this.isOutLined = false,
      this.buttonColor,
      this.textColor,
      this.textSize,
      this.borderColor
      });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
        width: width ?? double.infinity,
        height: height ?? 45,
        child: isOutLined
            ? OutlinedButton(
                onPressed: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  onPressed();
                },
                child: FittedBox(
                  child: Text(
                    text,
                    maxLines: 1,
                  ),
                ),
              )
            : ElevatedButton(
                onPressed: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  onPressed();
                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: borderColor ?? Theme.of(context).primaryColor, width: 2),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    backgroundColor:
                        buttonColor ?? Theme.of(context).primaryColor),
                child: FittedBox(
                  child: icon != null
                      ? Row(
                          children: [
                            Image.asset(
                              icon ?? "",
                              width: iconWidth,
                              height: iconHeight,
                            ),
                            SizedBox(width: 12),
                            textRegularPoppins(
                              fontSize: textSize,
                              color: textColor ?? Theme.of(context).canvasColor,
                              text: text,
                            ),
                          ],
                        )
                      : textRegularPoppins(
                          fontSize: textSize,
                          color: textColor ?? Theme.of(context).canvasColor,
                          text: text,
                        ),
                ),
              ));
  }
}
