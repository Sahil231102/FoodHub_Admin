import 'package:flutter/material.dart';
import 'package:food_hub_admin/const/colors.dart';
import 'package:food_hub_admin/view/widget/common_text.dart';

class CommonTextFormField extends StatelessWidget {
  final void Function()? onTap;
  final String? hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const CommonTextFormField(
      {super.key,
      this.onTap,
      this.hintText,
      required this.controller,
      this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: AppTextStyle.w600(fontSize: 18),
      onTap: onTap,
      validator: validator,
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTextStyle.w600(fontSize: 15, color: AppColors.grey),
        enabledBorder: _Border(color: AppColors.grey),
        focusedBorder: _Border(),
        disabledBorder: _Border(),
        focusedErrorBorder: _Border(color: AppColors.red),
        errorStyle: AppTextStyle.w500(fontSize: 13, color: AppColors.red),
        errorBorder: _Border(
          color: AppColors.red,
        ),
      ),
    );
  }
}

OutlineInputBorder _Border({Color color = AppColors.primary}) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: color),
  );
}
