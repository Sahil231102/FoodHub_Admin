import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_hub_admin/controller/flutter_image_compress.dart';
import 'package:food_hub_admin/services/cloudinary_service.dart';
import 'package:food_hub_admin/services/firebase_service.dart';
import 'package:food_hub_admin/view/widget/common_text.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class ImagePickerController extends GetxController {
  final ImagePicker picker = ImagePicker();
  final List<XFile> selectedImages = [];
  bool loading = false;

  void setInitialImages(List<XFile> images) {
    selectedImages.clear(); // Clear existing images
    selectedImages.addAll(images); // Add initial images
    update(); // Notify UI to refresh
  }

  Future<void> pickMultipleImages() async {
    if (selectedImages.length >= 5) {
      _showError("You can't select more than 5 images.");
      return;
    }

    final List<XFile> images = await picker.pickMultiImage(imageQuality: 50);
    if (images.isEmpty) return;
    if (selectedImages.length + images.length > 5) {
      _showError("You can't select more than 5 images in total.");
      return;
    }

    selectedImages.addAll(images);
    update();
  }

  void removeImage(int index) {
    if (index >= 0 && index < selectedImages.length) {
      selectedImages.removeAt(index);
      update();
    }
  }

  Future<void> uploadFoodDetailsToFirestore({
    required String foodName,
    required String foodPrice,
    required String foodCategory,
    required String foodDescription,
    required BuildContext context,
  }) async {
    try {
      loading = true;
      update();

      final List<String?> imageUrls =
          await Future.wait(selectedImages.map((image) async {
        final Uint8List bytes = await image.readAsBytes();
        final Uint8List? compressedBytes =
            await ImageCompressorUtil.compressImage(bytes);
        return compressedBytes != null
            ? await CloudinaryService.uploadImage(compressedBytes)
            : null;
      }));

      final List<String> validImageUrls =
          imageUrls.whereType<String>().toList();
      if (validImageUrls.isEmpty) throw Exception("Image upload failed.");

      final docRef = FirebaseServices.foodItemsCollection.doc();
      await docRef.set({
        'food_id': docRef.id,
        'food_name': foodName.trim(),
        'food_price': foodPrice,
        'food_category': foodCategory.trim(),
        'food_description': foodDescription.trim(),
        'image_urls': validImageUrls,
        'updated_at': FieldValue.serverTimestamp(),
      });

      Get.snackbar("Success", "Food item added successfully",
          backgroundColor: Colors.green, colorText: Colors.white);
      selectedImages.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error adding food item: ${e.toString()}")),
      );
    } finally {
      loading = false;
      update();
    }
  }

  Future<void> updateFoodDetails({
    required String foodId,
    required String foodName,
    required String foodPrice,
    required String foodCategory,
    required String foodDescription,
    required List<String> existingImageUrls,
    required List<String> imagesToRemove, // Images to be removed
  }) async {
    try {
      loading = true;
      update();

      final List<String?> newImageUrls =
          await Future.wait(selectedImages.map((image) async {
        final Uint8List bytes = await image.readAsBytes();
        final Uint8List? compressedBytes =
            await ImageCompressorUtil.compressImage(bytes);
        return compressedBytes != null
            ? await CloudinaryService.uploadImage(compressedBytes)
            : null;
      }));

      // Filter out images that need to be removed
      List<String> updatedImageUrls = existingImageUrls
          .where((url) => !imagesToRemove.contains(url))
          .toList();

      // Add new images to the list
      updatedImageUrls.addAll(newImageUrls.whereType<String>());

      await FirebaseServices.foodItemsCollection.doc(foodId).update({
        'food_name': foodName.trim(),
        'food_price': foodPrice,
        'food_category': foodCategory.trim(),
        'food_description': foodDescription.trim(),
        'image_urls': updatedImageUrls,
        'updated_at': FieldValue.serverTimestamp(),
      });
      Get.back();
      Get.snackbar("Success", "Food item updated successfully",
          titleText: Text(
            "Success",
            style: AppTextStyle.w700(fontSize: 18),
          ),
          messageText: Text("Food item updated successfully",
              style: AppTextStyle.w700(fontSize: 18)),
          backgroundColor: Colors.green,
          colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Error", "Failed to update food item: ${e.toString()}",
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      loading = false;
      update();
    }
  }

  Future<void> removeItem({required String foodId}) async {
    if (foodId.isNotEmpty) {
      try {
        await FirebaseServices.foodItemsCollection.doc(foodId).delete();
        Get.snackbar("Success", "Food item removed successfully",
            backgroundColor: Colors.green, colorText: Colors.white);
      } catch (e) {
        Get.snackbar("Error", "Failed to remove food item: ${e.toString()}",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    }
  }

  void _showError(String message) {
    Get.snackbar("Error", message,
        backgroundColor: Colors.red, colorText: Colors.white);
  }
}
