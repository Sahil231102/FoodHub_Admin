import 'package:flutter/material.dart';
import 'package:food_hub_admin/const/colors.dart';
import 'package:food_hub_admin/controller/show_category_controller.dart';
import 'package:food_hub_admin/view/widget/common_text.dart';
import 'package:food_hub_admin/view/widget/sized_box.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

import 'package:loader_overlay/loader_overlay.dart';

class ShowCategoryScreen extends StatefulWidget {
  const ShowCategoryScreen({super.key});

  @override
  State<ShowCategoryScreen> createState() => _ShowCategoryScreenState();
}

final controller = Get.put(ShowCategoryController());
@override
void initState() {
  controller.showCategory();
}

class _ShowCategoryScreenState extends State<ShowCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.categories.isEmpty) {
          return Center(
            child: Text('No categories available yet!',
                style: AppTextStyle.w700(fontSize: 18)),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              children: [
                DataTable(
                  border: TableBorder.all(),
                  columns: [
                    DataColumn(
                        label: Text('Index',
                            style: AppTextStyle.w700(fontSize: 18))),
                    DataColumn(
                        label: Text('Category Name',
                            style: AppTextStyle.w700(fontSize: 18))),
                    DataColumn(
                        label: Text('Category Image',
                            style: AppTextStyle.w700(fontSize: 18))),
                    DataColumn(
                        label: Text('Uploaded At',
                            style: AppTextStyle.w700(fontSize: 18))),
                    DataColumn(
                        label: Text('Edit',
                            style: AppTextStyle.w700(fontSize: 18))),
                    DataColumn(
                        label: Text('Delete',
                            style: AppTextStyle.w700(fontSize: 18))),
                  ],
                  rows: List.generate(controller.categories.length, (index) {
                    final category = controller.categories[index];
                    return DataRow(cells: [
                      DataCell(Text('${index + 1}',
                          style: AppTextStyle.w700(fontSize: 15))),
                      DataCell(Text(category.categoryName,
                          style: AppTextStyle.w700(fontSize: 15))),
                      DataCell(category.image != null
                          ? Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: CircleAvatar(
                                  maxRadius: 100,
                                  backgroundImage:
                                      NetworkImage(category.image!)),
                            )
                          : const Icon(Icons.image, size: 50)),
                      DataCell(Text(
                        DateFormat('dd-MM-yyyy hh:mm a')
                            .format(category.uploadedAt),
                        style: AppTextStyle.w700(fontSize: 15),
                      )),
                      DataCell(IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _showEditCategoryDialog(
                              context, category, controller);
                        },
                      )),
                      DataCell(IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _showDeleteConfirmationDialog(
                              context, category, controller);
                        },
                      )),
                    ]);
                  }),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  void _showEditCategoryDialog(BuildContext context, Category category,
      ShowCategoryController controller) {
    final TextEditingController nameController =
        TextEditingController(text: category.categoryName);
    Uint8List? selectedImage;
    RxString imagePath = RxString(category.image ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Category', style: AppTextStyle.w700(fontSize: 20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                style: AppTextStyle.w600(fontSize: 16),
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Category Name',
                  labelStyle: AppTextStyle.w600(fontSize: 16),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),

              // Display Selected Image Preview
              Obx(() {
                return imagePath.value.isNotEmpty
                    ? Image.network(imagePath.value,
                        height: 80, width: 80, fit: BoxFit.cover)
                    : const Icon(Icons.image, size: 50);
              }),
              10.sizeHeight,

              // Select Image Button
              TextButton.icon(
                icon: const Icon(Icons.image),
                label: Text(
                  "Select Image",
                  style: AppTextStyle.w600(
                      fontSize: 16, color: const Color(0xff6750a4)),
                ),
                onPressed: () async {
                  final ImagePicker picker = ImagePicker();
                  final XFile? image =
                      await picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    selectedImage = await image.readAsBytes();
                    imagePath.value = image.path; // Update the image preview
                  }
                },
              ),
              10.sizeHeight,

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      context.loaderOverlay.show();
                      await controller.editCategory(category.categoryId,
                          nameController.text, selectedImage);
                      Get.back();
                      Get.snackbar(
                        titleText: Text(
                          'Success',
                          style: AppTextStyle.w700(fontSize: 18),
                        ),
                        messageText: Text(
                          'Category updated successfully',
                          style: AppTextStyle.w600(fontSize: 16),
                        ),
                        '',
                        '',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                      );
                      // ignore: use_build_context_synchronously
                      context.loaderOverlay.hide();
                    },
                    child:
                        Text('Update', style: AppTextStyle.w600(fontSize: 16)),
                  ),
                  10.sizeWidth,
                  ElevatedButton(
                    onPressed: () async {
                      Get.back();
                    },
                    child:
                        Text('Cancle', style: AppTextStyle.w600(fontSize: 16)),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // **Delete Confirmation Dialog**
  void _showDeleteConfirmationDialog(BuildContext context, Category category,
      ShowCategoryController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Category', style: AppTextStyle.w700(fontSize: 20)),
        content: Text(
          'Are you sure you want to delete "${category.categoryName}"? This action cannot be undone.',
          style: AppTextStyle.w500(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel', style: AppTextStyle.w600(fontSize: 16)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await controller.deleteCategory(category.categoryId);
              Get.back();
              Get.snackbar(
                '',
                '',
                titleText: Text(
                  'Success',
                  style: AppTextStyle.w700(fontSize: 18),
                ),
                messageText: Text(
                  'Category deleted successfully',
                  style: AppTextStyle.w600(fontSize: 16),
                ),
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            child: Text('Delete',
                style: AppTextStyle.w600(fontSize: 16, color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
