import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerService extends GetxController {
  final ImagePicker picker = ImagePicker();
  final List<XFile> selectedImages = [];
  bool loading = false;

  Future<void> pickMultipleImages() async {
    if (selectedImages.length >= 20) {
      Get.snackbar(
        "Error",
        "Maximum 20 images allowed",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final List<XFile> images = await picker.pickMultiImage(imageQuality: 10);

    if (images.isEmpty) return;

    if (selectedImages.length + images.length > 5) {
      Get.snackbar(
        "Error",
        "Can't add more than 5 images. Please select fewer images.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
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
      update(); // This triggers the UI update

      final List<String> base64Images = [];

      // Convert all images to base64
      for (final XFile image in selectedImages) {
        final Uint8List bytes = await image.readAsBytes();
        final String base64Image = base64Encode(bytes);
        base64Images.add(base64Image);
      }

      // Upload to Firestore
      await FirebaseFirestore.instance.collection('FoodItems').doc().set({
        'food_name': foodName.trim(),
        'food_price': foodPrice.trim(),
        'food_category': foodCategory.trim(),
        'food_description': foodDescription.trim(),
        'images': base64Images,
        'uploaded_at': FieldValue.serverTimestamp(),
      });

      // Show success message
      Get.snackbar(
        "Success",
        "Food item added successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Clear the selected images
      selectedImages.clear();
      loading = false; // Stop the loading state
      update();
    } catch (e) {
      loading = false; // Stop the loading state in case of an error
      update();
      print("Error adding food item: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error adding food item: $e")),
      );
    }
  }
}
