import 'package:flutter/material.dart';
import 'package:food_hub_admin/const/colors.dart';
import 'package:food_hub_admin/view/widget/common_text.dart';

class DashboardCommonCounterButton extends StatelessWidget {
  final Color? colors;
  final String? nameText;
  final String? countText;
  final Color? nameTextColor;
  final Color? countTextColor;

  const DashboardCommonCounterButton(
      {super.key,
      this.colors,
      this.nameText,
      this.countText,
      this.nameTextColor,
      this.countTextColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        constraints: BoxConstraints(minHeight: 50, maxWidth: 280, maxHeight: 100, minWidth: 0),
        decoration: BoxDecoration(
          color: colors ?? AppColors.primary,
          borderRadius: BorderRadius.circular(15),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              nameText ?? 'Default Text',
              style: AppTextStyle.w600(fontSize: 20, color: nameTextColor ?? AppColors.white),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              countText ?? '0',
              style: AppTextStyle.w600(fontSize: 20, color: countTextColor ?? AppColors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
