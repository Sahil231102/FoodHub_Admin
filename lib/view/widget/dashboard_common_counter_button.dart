import 'package:flutter/material.dart';
import 'package:food_hub_admin/const/colors.dart';
import 'package:food_hub_admin/view/widget/common_text.dart';
import 'package:food_hub_admin/view/widget/height_width.dart';

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
      padding: const EdgeInsets.all(30.0),
      child: Container(
        height: context.heightPercentage(16), // Set to an appropriate value
        width:
            context.widthPercentage(15), // Adjust the width to a suitable size
        decoration: BoxDecoration(
          color: colors ?? AppColors.primary,
          borderRadius: BorderRadius.circular(15),
        ),
        alignment: Alignment.center, // Centers the text inside the container
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              nameText ?? 'Default Text', // Provide a default text if null
              style: AppTextStyle.w600(
                  fontSize: 20, color: nameTextColor ?? AppColors.white),
              textAlign: TextAlign.center, // Center the text
            ),
            Text(
              countText ?? '0', // Provide a default text if null
              style: AppTextStyle.w600(
                  fontSize: 20, color: countTextColor ?? AppColors.white),
              textAlign: TextAlign.center, // Center the text
            ),
          ],
        ),
      ),
    );
  }
}
