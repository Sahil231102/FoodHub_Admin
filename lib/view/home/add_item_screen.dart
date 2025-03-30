import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food_hub_admin/controller/show_category_controller.dart';
import 'package:food_hub_admin/view/widget/common_text.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:food_hub_admin/const/colors.dart';
import 'package:food_hub_admin/controller/image_picker_controller.dart';
import 'package:food_hub_admin/view/widget/common_text_form_field.dart';
import 'package:food_hub_admin/view/widget/sized_box.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final ImagePickerController imagePickerController =
      Get.put(ImagePickerController());

  final ShowCategoryController showCategoryController =
      Get.put(ShowCategoryController()); // Use the CategoryController

  TextEditingController foodName = TextEditingController();
  TextEditingController foodPrice = TextEditingController();
  TextEditingController foodCategory = TextEditingController();
  TextEditingController foodDescription = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Fetch categories on screen load
    showCategoryController.showCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: GetBuilder<ImagePickerController>(
        builder: (controller) {
          return SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWeb = constraints.maxWidth > 600;
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Flex(
                    direction: isWeb ? Axis.horizontal : Axis.vertical,
                    crossAxisAlignment: isWeb
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        flex: isWeb ? 1 : 0,
                        child:
                            _buildImageGrid(controller, constraints.maxWidth),
                      ),
                      if (isWeb) 20.sizeWidth else 20.sizeHeight,
                      Flexible(
                        flex: isWeb ? 1 : 0,
                        child: _buildForm(controller),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildImageGrid(ImagePickerController controller, double maxWidth) {
    final crossAxisCount = maxWidth > 800 ? 4 : (maxWidth > 600 ? 3 : 2);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Food Images (${controller.selectedImages.length}/5)",
              style: AppTextStyle.w600(fontSize: 16, color: AppColors.black),
            ),
            if (controller.selectedImages.length < 5)
              GestureDetector(
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.grey, width: 3),
                  ),
                  child: IconButton(
                      onPressed: () => controller.pickMultipleImages(),
                      icon: const Icon(
                        Icons.add,
                        color: AppColors.primary,
                      )),
                ),
              )
          ],
        ),
        10.sizeHeight,
        if (controller.selectedImages.isEmpty)
          Center(
            child: Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image, size: 48, color: Colors.grey[400]),
                  10.sizeHeight,
                  Text(
                    "Select at least 1 image",
                    style: AppTextStyle.w400(color: Colors.grey),
                  ),
                ],
              ),
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: controller.selectedImages.length,
            itemBuilder: (context, index) {
              return _buildImageTile(
                  controller.selectedImages[index], controller, index);
            },
          ),
      ],
    );
  }

  Widget _buildImageTile(
      XFile image, ImagePickerController controller, int index) {
    return Stack(
      children: [
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: kIsWeb
                ? Image.network(
                    image.path,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  )
                : Image.file(
                    File(image.path),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: InkWell(
            onTap: () => controller.removeImage(index),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                size: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildForm(ImagePickerController controller) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Obx(
            () {
              if (showCategoryController.isLoading.value) {
                return const Center(
                    child:
                        CircularProgressIndicator()); // Show the loading spinner
              } else {
                // Show the form when the data is not loading
                return Column(
                  children: [
                    CommonTextFormField(
                      controller: foodName,
                      labelText: "Enter Food Name",
                      validator: (p0) {
                        if (p0 != null && p0.isEmpty) {
                          return "Please Enter Food Name";
                        }
                        return null;
                      },
                    ),
                    20.sizeHeight,
                    CommonTextFormField(
                      controller: foodPrice,
                      labelText: "Enter Food Price",
                      validator: (p0) {
                        if (p0 != null && p0.isEmpty) {
                          return "Please Enter Food Price";
                        }
                        return null;
                      },
                    ),
                    20.sizeHeight,
                    Obx(() {
                      if (showCategoryController.categories.isEmpty) {
                        return Text(
                          "No categories available",
                          style: AppTextStyle.w500(
                              fontSize: 16, color: AppColors.red),
                        );
                      } else {
                        return DropdownButtonFormField<String>(
                          style: AppTextStyle.w600(
                              fontSize: 15, color: AppColors.black),
                          value: showCategoryController
                                  .selectedCategory.value.isEmpty
                              ? null
                              : showCategoryController.selectedCategory.value,
                          decoration: InputDecoration(
                            errorStyle: AppTextStyle.w500(
                                fontSize: 13, color: AppColors.red),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: AppColors.primary)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: AppColors.grey),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: AppColors.red),
                            ),
                            labelText: 'Select Food Category',
                            labelStyle: AppTextStyle.w700(
                                fontSize: 15, color: AppColors.grey),
                          ),
                          onChanged: (value) {
                            showCategoryController.setSelectedCategory(value!);
                            foodCategory.text = value;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a food category';
                            }
                            return null;
                          },
                          items:
                              showCategoryController.categories.map((category) {
                            return DropdownMenuItem<String>(
                              value: category.categoryName,
                              child: Text(category.categoryName),
                            );
                          }).toList(),
                        );
                      }
                    }),
                    20.sizeHeight,
                    CommonTextFormField(
                      controller: foodDescription,
                      labelText: "Enter Food Description",
                      validator: (p0) {
                        if (p0 != null && p0.isEmpty) {
                          return "Please Enter Food Description";
                        }
                        return null;
                      },
                    ),
                    20.sizeHeight,
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            if (controller.selectedImages.isEmpty) {
                              Get.snackbar(
                                "Error",
                                "Please select at least one image",
                                backgroundColor: AppColors.red,
                                colorText: Colors.white,
                              );
                              return;
                            }

                            controller.uploadFoodDetailsToFirestore(
                              context: context,
                              foodName: foodName.text,
                              foodPrice: foodPrice.text,
                              foodCategory: foodCategory.text,
                              foodDescription: foodDescription.text,
                            );
                            foodName.clear();
                            foodDescription.clear();
                            showCategoryController.setSelectedCategory("");
                            foodCategory.clear();
                            foodPrice.clear();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  8), // Optional rounded corners
                            ),
                            backgroundColor: AppColors.primary),
                        child: controller.loading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : Text(
                                "ADD FOOD",
                                style: AppTextStyle.w700(
                                    color: Colors.white, fontSize: 20),
                              ),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
