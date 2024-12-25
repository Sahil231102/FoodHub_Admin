import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food_hub_admin/const/colors.dart';
import 'package:food_hub_admin/controller/image_picker_controller.dart';
import 'package:food_hub_admin/view/home/side_menu.dart';
import 'package:food_hub_admin/view/widget/common_text.dart';
import 'package:food_hub_admin/view/widget/common_text_form_field.dart';
import 'package:food_hub_admin/view/widget/sized_box.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final ImagePickerController _imagePickerController = Get.put(ImagePickerController());

  TextEditingController foodName = TextEditingController();
  TextEditingController foodPrice = TextEditingController();
  TextEditingController foodCategory = TextEditingController();
  TextEditingController foodDescription = TextEditingController();

  String? _selectedCategory;

  // Sample list of categories
  final List<String> _categories = [
    'Fast Food',
    'Burgers',
    'Fried Foods',
    'Street Food',
    'Drinks and Sides',
    "Combo Meals",
  ];

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Add Food",
          style: AppTextStyle.w700(fontSize: 20),
        ),
      ),
      drawer: const SideMenu(),
      body: GetBuilder<ImagePickerController>(
        builder: (controller) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildImageGrid(controller)),
                  20.sizeHeight,
                  Expanded(child: _buildForm(controller)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildImageGrid(ImagePickerController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Food Images (${controller.selectedImages.length}/5)",
              style: AppTextStyle.w600(fontSize: 16),
            ),
            if (controller.selectedImages.length < 5)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: ElevatedButton.icon(
                  onPressed: () => controller.pickMultipleImages(),
                  icon: const Icon(Icons.add_photo_alternate),
                  label: const Text("Add Images"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
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
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: controller.selectedImages.length,
            itemBuilder: (context, index) {
              return _buildImageTile(controller.selectedImages[index], controller, index);
            },
          ),
      ],
    );
  }

  Widget _buildImageTile(XFile image, ImagePickerController controller, int index) {
    return Stack(
      children: [
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
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
          CommonTextFormField(
            controller: foodName,
            hintText: "Enter Food Name",
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
            hintText: "Enter Food Price",
            validator: (p0) {
              if (p0 != null && p0.isEmpty) {
                return "Please Enter Food Price";
              }
              return null;
            },
          ),
          20.sizeHeight,
          // CommonTextFormField(
          //   controller: foodCategory,
          //   hintText: "Enter Food Category",
          //   validator: (p0) {
          //     if (p0 != null && p0.isEmpty) {
          //       return "Please Enter Food Category";
          //     }
          //     return null;
          //   },
          // ),
          DropdownButtonFormField<String>(
            value: _selectedCategory,
            decoration: InputDecoration(
              hintText: 'Select Food Category',
              hintStyle: AppTextStyle.w600(fontSize: 15),
              border: const OutlineInputBorder(),
            ),
            items: _categories.map((category) {
              return DropdownMenuItem(
                value: category,
                child: Text(
                  category,
                  style: AppTextStyle.w700(fontSize: 17, color: AppColors.black),
                ),
              );
            }).toList(),
            onChanged: (value) {
              _selectedCategory = value;
              foodCategory.text = _selectedCategory.toString();
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a food category';
              }
              return null;
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
                  foodCategory.clear();
                  foodPrice.clear();
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              child: controller.loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                      "ADD FOOD",
                      style: AppTextStyle.w700(color: Colors.white, fontSize: 20),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
