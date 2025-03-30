import 'package:flutter/material.dart';
import 'package:food_hub_admin/controller/show_category_controller.dart';
import 'package:food_hub_admin/view/widget/common_text.dart';
import 'package:get/get.dart';
import 'package:food_hub_admin/const/colors.dart';
import 'package:food_hub_admin/controller/image_picker_controller.dart';
import 'package:food_hub_admin/view/widget/common_text_form_field.dart';
import 'package:food_hub_admin/view/widget/sized_box.dart';

class UpdateItemScreen extends StatefulWidget {
  final String foodId;
  final String initialName;
  final String initialPrice;
  final String initialCategory;
  final String initialDescription;
  final List<String> initialImages;

  const UpdateItemScreen({
    super.key,
    required this.foodId,
    required this.initialName,
    required this.initialPrice,
    required this.initialCategory,
    required this.initialDescription,
    required this.initialImages,
  });

  @override
  State<UpdateItemScreen> createState() => _UpdateItemScreenState();
}

class _UpdateItemScreenState extends State<UpdateItemScreen> {
  final ImagePickerController imagePickerController =
      Get.put(ImagePickerController());
  final ShowCategoryController showCategoryController =
      Get.put(ShowCategoryController());

  TextEditingController foodName = TextEditingController();
  TextEditingController foodPrice = TextEditingController();
  TextEditingController foodCategory = TextEditingController();
  TextEditingController foodDescription = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    foodName.text = widget.initialName;
    foodPrice.text = widget.initialPrice;
    foodCategory.text = widget.initialCategory;
    foodDescription.text = widget.initialDescription;
    showCategoryController.showCategory();
    // imagePickerController.setInitialImages(widget.initialImages[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        "Update Food Item",
        style: AppTextStyle.w600(fontSize: 20),
      )),
      body: GetBuilder<ImagePickerController>(
        builder: (controller) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImageGrid(controller),
                20.sizeHeight,
                _buildForm(controller),
              ],
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
              style: AppTextStyle.w600(fontSize: 16, color: AppColors.black),
            ),
            if (controller.selectedImages.length < 5)
              IconButton(
                onPressed: () => controller.pickMultipleImages(),
                icon: const Icon(Icons.add, color: AppColors.primary),
              ),
          ],
        ),
        10.sizeHeight,
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: controller.selectedImages.length,
          itemBuilder: (context, index) {
            return _buildImageTile(
                controller.selectedImages[index].path, controller, index);
          },
        ),
      ],
    );
  }

  Widget _buildImageTile(
      String imageUrl, ImagePickerController controller, int index) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: InkWell(
            onTap: () => controller.removeImage(index),
            child: const CircleAvatar(
              backgroundColor: Colors.red,
              radius: 12,
              child: Icon(Icons.close, size: 16, color: Colors.white),
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
            labelText: "Enter Food Name",
            validator: (value) =>
                value!.isEmpty ? "Please Enter Food Name" : null,
          ),
          20.sizeHeight,
          CommonTextFormField(
            controller: foodPrice,
            labelText: "Enter Food Price",
            validator: (value) =>
                value!.isEmpty ? "Please Enter Food Price" : null,
          ),
          20.sizeHeight,
          Obx(() {
            return DropdownButtonFormField<String>(
              value: foodCategory.text,
              decoration: InputDecoration(
                labelText: 'Select Food Category',
                labelStyle:
                    AppTextStyle.w600(fontSize: 18, color: AppColors.grey),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: AppColors.primary, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              style: AppTextStyle.w600(fontSize: 16),
              onChanged: (value) {
                foodCategory.text = value!;
              },
              items: showCategoryController.categories.map((category) {
                return DropdownMenuItem<String>(
                  value: category.categoryName,
                  child: Text(category.categoryName),
                );
              }).toList(),
            );
          }),
          20.sizeHeight,
          CommonTextFormField(
            controller: foodDescription,
            labelText: "Enter Food Description",
            validator: (value) =>
                value!.isEmpty ? "Please Enter Food Description" : null,
          ),
          20.sizeHeight,
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(8), // Optional rounded corners
                ),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  imagePickerController.updateFoodDetails(
                    existingImageUrls: widget.initialImages,
                    foodId: widget.foodId,
                    imagesToRemove: widget.initialImages,
                    foodName: foodName.text,
                    foodPrice: foodPrice.text,
                    foodCategory: foodCategory.text,
                    foodDescription: foodDescription.text,
                  );
                }
              },
              child: controller.loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text("UPDATE FOOD",
                      style: AppTextStyle.w700(
                          color: AppColors.white, fontSize: 20)),
            ),
          ),
        ],
      ),
    );
  }
}
