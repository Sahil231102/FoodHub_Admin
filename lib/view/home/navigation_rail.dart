import 'package:flutter/material.dart';
import 'package:food_hub_admin/const/colors.dart';
import 'package:food_hub_admin/view/home/app_screens.dart';
import 'package:food_hub_admin/view/widget/common_text.dart';

class NavigationRailScreen extends StatelessWidget {
  final Function(String) onScreenSelected;

  const NavigationRailScreen({super.key, required this.onScreenSelected});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 230,
      child: Material(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
        textStyle: AppTextStyle.w700(color: Colors.yellow, fontSize: 10),
        elevation: 2,
        child: ListView(
          children: AppScreens.screens.keys.map((screen) {
            return ListTile(
              title: Text(
                screen,
                style: AppTextStyle.w700(
                  color: AppColors.white,
                  fontSize: 18,
                ),
              ),
              onTap: () => onScreenSelected(screen),
            );
          }).toList(),
        ),
      ),
    );
  }
}
