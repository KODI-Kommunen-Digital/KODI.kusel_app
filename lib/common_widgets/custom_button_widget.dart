import 'package:flutter/material.dart';
import 'package:kusel/common_widgets/text_styles.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final double? height;
  final double? width;
  final double? iconHeight;
  final double? iconWidth;
  final bool isOutLined;
  final Color? buttonColor;
  final Color? textColor;
  final double? textSize;

  const CustomButton(
      {super.key,
      required this.onPressed,
      required this.text,
      this.height,
      this.width,
      this.iconHeight,
      this.iconWidth,
      this.isOutLined = false,
      this.buttonColor,
      this.textColor,
      this.textSize});

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
                      borderRadius: BorderRadius.circular(50),
                    ),
                    backgroundColor: buttonColor ?? Color(0xFF18204F)),
                child: FittedBox(
                  child: textRegularPoppins(
                    fontSize: textSize,
                    color: textColor,
                    text: text,
                  ),
                ),
              ));
  }
}
