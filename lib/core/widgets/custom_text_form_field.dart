import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theming/colors.dart';
import '../theming/styles.dart';

class CustomTextFormField extends StatefulWidget {
  final EdgeInsetsGeometry? contentPadding;
  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;
  final TextStyle? inputTextStyle;
  final TextStyle? hintStyle;
  final String? hintText;
  final bool? isObscureText;
  final Widget? suffixIcon;
  final Color? backgroundColor;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final bool isReadOnly;
  final void Function()? onTap;
  final TextInputType? keyboardType;
  final int maxLines;

  const CustomTextFormField({
    super.key,
    this.contentPadding,
    this.focusedBorder,
    this.enabledBorder,
    this.inputTextStyle,
    this.hintStyle,
    this.prefixIcon,
    this.hintText,
    this.isObscureText,
    this.suffixIcon,
    this.backgroundColor,
    this.onChanged,
    this.controller,
    this.validator,
    this.isReadOnly = false,
    this.onTap,
    this.keyboardType,
    this.maxLines = 1,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool isObscure = false;

  @override
  void initState() {
    super.initState();
    isObscure = widget.isObscureText ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: isObscure,
      readOnly: widget.isReadOnly,
      onTap: widget.onTap,
      onChanged: widget.onChanged,
      maxLines: widget.maxLines,
      
      style: TextStyles.font14GrayBlack,
      decoration: InputDecoration(
        isDense: true,
        contentPadding:
            widget.contentPadding ??
            EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),

        focusedBorder:
            widget.focusedBorder ??
            OutlineInputBorder(
              borderSide: const BorderSide(
                color: ColorsManager.darkBlue,
                width: 1.3,
              ),
              borderRadius: BorderRadius.circular(16.0),
            ),

        enabledBorder:
            widget.enabledBorder ??
            OutlineInputBorder(
              borderSide: const BorderSide(
                color: ColorsManager.lighterGray,
                width: 1.3,
              ),
              borderRadius: BorderRadius.circular(16.0),
            ),

        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: ColorsManager.errorRed,
            width: 1.3,
          ),
          borderRadius: BorderRadius.circular(16.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: ColorsManager.errorRed,
            width: 1.3,
          ),
          borderRadius: BorderRadius.circular(16.0),
        ),

        hintText: widget.hintText,
        hintStyle: widget.hintStyle ?? TextStyles.font13GrayRegular,
        suffixIcon: widget.isObscureText == true
            ? IconButton(
                onPressed: () {
                  setState(() {
                    isObscure = !isObscure;
                  });
                },
                icon: Icon(isObscure ? Icons.visibility_off : Icons.visibility),
              )
            : widget.suffixIcon,

        prefixIconConstraints: BoxConstraints(minWidth: 35.w, minHeight: 10.h),
        prefixIcon: widget.prefixIcon,
        fillColor: widget.backgroundColor ?? ColorsManager.gray50,
        filled: true,
      ),

      validator:
          widget.validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter ${widget.hintText}';
            }
            return null;
          },
    );
  }
}
