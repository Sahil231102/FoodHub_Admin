import 'package:flutter/material.dart';
import 'package:food_hub_admin/const/colors.dart';
import 'package:food_hub_admin/view/widget/common_text.dart';
import 'package:get/get.dart';

class AppDefaultDialog {
  static void Showsuccess({String? title, String? message}) {
    Get.defaultDialog(
      title: "Success",
      titleStyle: AppTextStyle.w700(color: AppColors.black, fontSize: 20),
      middleText: "Successfully Added Item",
      middleTextStyle: AppTextStyle.w700(color: AppColors.black, fontSize: 20),
      backgroundColor: AppColors.white,
      radius: 10,
      contentPadding: const EdgeInsets.all(20),
      confirm: ElevatedButton(
        onPressed: () {
          Get.back(); // Close the dialog
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
        ),
        child: Text(
          "OK",
          style: AppTextStyle.w700(fontSize: 16, color: AppColors.white),
        ),
      ),
    );
  }
}
