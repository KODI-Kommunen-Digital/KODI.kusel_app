import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/theme_manager/theme_manager_controller.dart';

class KuselTextField extends ConsumerStatefulWidget {
  TextEditingController textEditingController;
  TextInputType? keyboardType;
  Color? textColor;
  Color? fillColor;
  void Function(String value)? onChanged;
  Color? hintTextColor;
  Color? focusBorderColor;
  Color? enableBorderColor;
  Color? errorBorderColor;
  Color? focusedErrorBorder;
  Color? errorStyleColor;
  Color? borderColor;
  bool? enable;
  String? hintText;
  String? Function(String?)? validator;
  Widget? suffixIcon;
  bool? readOnly;
  int? maxLines;
  EdgeInsetsGeometry? contentPadding;
  bool? obscureText;
  BoxConstraints? suffixIconConstraints;
  bool outlined;
  List<TextInputFormatter>? inputFormatters;
  void Function(String)? onFieldSubmitted;

  KuselTextField(
      {required this.textEditingController,
      this.textColor,
      this.fillColor,
      this.hintTextColor,
      this.focusBorderColor,
      this.enableBorderColor,
      this.keyboardType,
      this.errorBorderColor,
      this.focusedErrorBorder,
      this.errorStyleColor,
      this.onChanged,
      this.enable,
      this.hintText,
      this.validator,
      this.borderColor,
      this.suffixIcon,
      this.readOnly,
      this.maxLines,
      this.contentPadding,
      this.obscureText,
      this.suffixIconConstraints,
      this.outlined = false,
      this.inputFormatters,
      this.onFieldSubmitted,
      super.key});

  @override
  ConsumerState<KuselTextField> createState() => _KuselTextFieldState();
}

class _KuselTextFieldState extends ConsumerState<KuselTextField> {
  @override
  Widget build(BuildContext context) {
    final currentSelectedThemeData =
        ref.watch(themeManagerProvider).currentSelectedTheme!;

    double borderRadius = 20.r;

    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onFieldSubmitted: widget.onFieldSubmitted,
      inputFormatters: widget.inputFormatters,
      onChanged: widget.onChanged,
      obscureText: widget.obscureText ?? false,
      maxLines: widget.maxLines,
      validator: widget.validator,
      enabled: widget.enable ?? true,
      readOnly: widget.readOnly ?? false,
      controller: widget.textEditingController,
      keyboardType: widget.keyboardType,
      style: TextStyle(
        color: widget.textColor ??
            currentSelectedThemeData.textTheme.displayMedium!.color,
        fontSize: 14,
      ),
      decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          suffixIconConstraints: widget.suffixIconConstraints,
          suffixIcon: widget.suffixIcon,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                  color: Color.fromRGBO(255, 255, 255, 0.8), width: 2)),
          hintText: widget.hintText,
          contentPadding:
              widget.contentPadding ?? const EdgeInsets.only(top: 10, left: 10),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
                color: widget.focusBorderColor ??
                    Color.fromRGBO(0, 0, 0, 0.8),
                width: 0.7),
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                  color: widget.enableBorderColor ??
                      Color.fromRGBO(255, 255, 255, 0.8))),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                  color: widget.errorBorderColor ?? Colors.red, width: 1)),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                  color: widget.focusedErrorBorder ?? Colors.red, width: 1)),
          errorStyle: TextStyle(
            color: widget.errorStyleColor ?? Colors.red,
            fontWeight: FontWeight.w400,
            overflow: TextOverflow.visible,
            fontSize: 11,
          ),
          hintStyle: TextStyle(
            color: widget.hintTextColor ?? currentSelectedThemeData.hintColor,
            fontSize: 14,
          )),
    );
  }
}
