import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:typed_data'; // For handling Uint8List (image data)

import 'package:food_hub_admin/services/cloudinary_service.dart'; // For uploading images to Cloudinary

import 'package:image_picker/image_picker.dart'; // For base64 decoding

class ShowCategoryController extends GetxController {
  RxList<Category> categories = <Category>[].obs;
  RxString selectedCategory = "".obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    showCategory();
  }

  // Fetch categories from Firestore
  Future<void> showCategory() async {
    try {
      isLoading.value = true;
      final categorySnapshot =
          await FirebaseFirestore.instance.collection('food_categories').get();

      categories.value = categorySnapshot.docs.map((doc) {
        final categoryId = doc.id;
        final categoryName = doc['category_name'] as String;
        final uploadedAt = (doc['uploaded_at'] as Timestamp).toDate();
        final categoryImage = doc['image_url'] as String?;

        return Category(
          categoryId: categoryId,
          categoryName: categoryName,
          image: categoryImage.toString(),
          uploadedAt: uploadedAt,
        );
      }).toList();

      isLoading.value = false;
    } catch (e) {
      print("Failed to load categories: $e");
      isLoading.value = false;
    }
  }

  // Set selected category
  void setSelectedCategory(String category) {
    selectedCategory.value = category;
  }

  // Edit category in Firestore
  Future<Uint8List?> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    return pickedFile != null ? await pickedFile.readAsBytes() : null;
  }

  Future<void> editCategory(
    String categoryId,
    String newName,
    Uint8List? newImage,
  ) async {
    String? imageUrl;
    if (newImage != null) {
      imageUrl = await CloudinaryService.uploadImage(newImage);
    }
    await FirebaseFirestore.instance
        .collection('food_categories')
        .doc(categoryId)
        .update({
      'category_name': newName,
      'uploaded_at': DateTime.now(),
      if (imageUrl != null) 'image_url': imageUrl,
    });
    await showCategory();
  }

  // Delete category from Firestore
  Future<void> deleteCategory(String categoryId) async {
    try {
      await FirebaseFirestore.instance
          .collection('food_categories')
          .doc(categoryId)
          .delete();
      categories.removeWhere((category) => category.categoryId == categoryId);
    } catch (e) {
      print("Failed to delete category: $e");
    }
  }
}

// Define a model to represent a category
class Category {
  final String categoryId;
  final String categoryName;
  final String? image;
  final DateTime uploadedAt;

  Category({
    required this.categoryId,
    required this.categoryName,
    required this.image,
    required this.uploadedAt,
  });
}
