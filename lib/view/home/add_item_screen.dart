import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_hub_admin/const/Images.dart';
import 'package:food_hub_admin/const/colors.dart';
import 'package:food_hub_admin/const/icons.dart';
import 'package:food_hub_admin/services/image_picker_services.dart';
import 'package:food_hub_admin/services/validation_services.dart';
import 'package:food_hub_admin/view/home/dashboard_screen.dart';
import 'package:food_hub_admin/view/home/side_menu.dart';
import 'package:food_hub_admin/view/widget/app_default_dialog.dart';
import 'package:food_hub_admin/view/widget/common_text.dart';
import 'package:food_hub_admin/view/widget/common_text_form_field.dart';
import 'package:food_hub_admin/view/widget/height_width.dart';
import 'package:food_hub_admin/view/widget/sized_box.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final ImagePickerService _imagePickerServices = Get.put(ImagePickerService());

  TextEditingController foodName = TextEditingController();
  TextEditingController foodPrice = TextEditingController();
  TextEditingController foodCategory = TextEditingController();
  TextEditingController foodDescription = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ImagePickerService>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text(
              "Add Food",
              style: AppTextStyle.w700(fontSize: 20),
            ),
          ),
          drawer: SideMenu(),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SafeArea(
                child: Stack(
                  children: [
                    // Background Circle Images
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: SingleChildScrollView(
                          child: Form(
                            key: _formKey,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Image Section
                                const Expanded(
                                  child: Image(
                                    image: AssetImage(AppImages.addFood),
                                    width: 400,
                                    height: 400,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                const SizedBox(
                                    width:
                                        20), // Spacer between image and column
                                // Input Fields Section
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CommonTextFormField(
                                        controller: foodName,
                                        hintText: "Enter Food Name",
                                        validator: (p0) {
                                          if (p0 != null && p0.isEmpty) {
                                            return "Please Enter Food Name";
                                          }
                                        },
                                      ),
                                      20.sizeHeight,
                                      // Password Input
                                      CommonTextFormField(
                                        controller: foodPrice,
                                        hintText: "Enter Food Price",
                                        validator: (p0) {
                                          if (p0 != null && p0.isEmpty) {
                                            return "Please Enter Food Price";
                                          }
                                        },
                                      ),
                                      20.sizeHeight,
                                      CommonTextFormField(
                                        controller: foodCategory,
                                        hintText: "Enter Food Category",
                                        validator: (p0) {
                                          if (p0 != null && p0.isEmpty) {
                                            return "Please Enter Food Category";
                                          }
                                        },
                                      ),
                                      20.sizeHeight,
                                      CommonTextFormField(
                                        controller: foodDescription,
                                        hintText: "Enter Food Description",
                                        validator: (p0) {
                                          if (p0 != null && p0.isEmpty) {
                                            return "Please Enter Food Description";
                                          }
                                        },
                                      ),
                                      20.sizeHeight,
                                      // Submit Button
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 220,
                                            height: 50,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                if (_formKey.currentState
                                                        ?.validate() ??
                                                    false) {
                                                  // Navigate to DashboardScreen
                                                  Get.to(() => AddItemScreen());
                                                  _imagePickerServices
                                                      .pickAndUploadFoodDetails(
                                                    context: context,
                                                    foodName: foodName.text,
                                                    foodPrice: foodPrice.text,
                                                    foodCategory:
                                                        foodCategory.text,
                                                    foodDescription:
                                                        foodDescription.text,
                                                  );
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      AppColors.primary),
                                              child: Text(
                                                "ADD FOOD",
                                                style: AppTextStyle.w700(
                                                    color: Colors.white,
                                                    fontSize: 20),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
