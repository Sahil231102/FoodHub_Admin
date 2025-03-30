import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:food_hub_admin/const/colors.dart';
import 'package:food_hub_admin/const/icons.dart';
import 'package:food_hub_admin/controller/category_controller.dart';
import 'package:food_hub_admin/view/widget/common_text.dart';
import 'package:food_hub_admin/view/widget/sized_box.dart';
import 'package:get/get.dart';

class AddCategoryScreen extends StatelessWidget {
  final TextEditingController _categoryNameController = TextEditingController();
  final CategoryController categoryController = Get.put(CategoryController());

  AddCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 2,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                20.sizeHeight,
                TextFormField(
                  style: AppTextStyle.w600(fontSize: 16),
                  controller: _categoryNameController,
                  decoration: InputDecoration(
                    labelText: "Category Name",
                    labelStyle: AppTextStyle.w700(
                      fontSize: 16,
                    ),
                    border: const OutlineInputBorder(),
                    prefixIcon: AppIcons.category,
                  ),
                ),
                const SizedBox(height: 20),
                GetBuilder<CategoryController>(
                  builder: (controller) => GestureDetector(
                    onTap: controller.pickImage,
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey, width: 1),
                      ),
                      child: controller.selectedImage == null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.add_a_photo,
                                    size: 50, color: Colors.grey),
                                Text("Tap to select image",
                                    style: AppTextStyle.w700(
                                        color: Colors.grey, fontSize: 15)),
                              ],
                            )
                          : FutureBuilder<Uint8List>(
                              future: controller.selectedImage!.readAsBytes(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                        ConnectionState.done &&
                                    snapshot.hasData) {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.memory(
                                      snapshot.data!,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ),
                                  );
                                } else {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                              },
                            ),
                    ),
                  ),
                ),
                20.sizeHeight,
                GetBuilder<CategoryController>(
                  builder: (controller) => ElevatedButton(
                    onPressed: controller.loading
                        ? null
                        : () async {
                            if (_categoryNameController.text.trim().isEmpty ||
                                controller.selectedImage == null) {
                              Get.snackbar("Error",
                                  "Category name and image are required.",
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white);
                              return;
                            }
                            await controller.uploadCategoryToFirestore(
                              categoryName: _categoryNameController.text,
                              context: context,
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: controller.loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text("ADD CATEGORY",
                            style: AppTextStyle.w700(
                                fontSize: 16, color: AppColors.white)),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
