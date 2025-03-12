import 'package:flutter/material.dart';
import 'package:food_hub_admin/controller/show_category_controller.dart';
import 'package:food_hub_admin/view/widget/common_text.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

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
      appBar: AppBar(
        title: Text('Categories', style: AppTextStyle.w700(fontSize: 22)),
        centerTitle: true,
      ),
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
            child: DataTable(
              border: TableBorder.all(),
              columns: [
                DataColumn(
                    label:
                        Text('Index', style: AppTextStyle.w700(fontSize: 18))),
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
                    label:
                        Text('Edit', style: AppTextStyle.w700(fontSize: 18))),
                DataColumn(
                    label:
                        Text('Delete', style: AppTextStyle.w700(fontSize: 18))),
              ],
              rows: List.generate(controller.categories.length, (index) {
                final category = controller.categories[index];
                return DataRow(cells: [
                  DataCell(Text('${index + 1}',
                      style: AppTextStyle.w700(fontSize: 15))),
                  DataCell(Text(category.categoryName,
                      style: AppTextStyle.w700(fontSize: 15))),
                  DataCell(category.image != null
                      ? Image.network(category.image!,
                          width: 60, height: 80, fit: BoxFit.cover)
                      : const Icon(Icons.image, size: 50)),
                  DataCell(Text(
                    DateFormat('dd-MM-yyyy HH:mm').format(category.uploadedAt),
                    style: AppTextStyle.w700(fontSize: 15),
                  )),
                  DataCell(IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      _showEditCategoryDialog(context, category, controller);
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
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Category Name',
                  border: OutlineInputBorder(),
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
              const SizedBox(height: 10),

              // Select Image Button
              TextButton.icon(
                icon: const Icon(Icons.image),
                label: const Text("Select Image"),
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
              const SizedBox(height: 10),

              ElevatedButton(
                onPressed: () async {
                  await controller.editCategory(
                      category.categoryId, nameController.text, selectedImage);
                  Navigator.pop(context);
                  Get.snackbar(
                    'Success',
                    'Category updated successfully',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                },
                child: Text('Update', style: AppTextStyle.w600(fontSize: 16)),
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
                'Success',
                'Category deleted successfully',
                snackPosition: SnackPosition.BOTTOM,
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
