import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_hub_admin/services/firebase_service.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img; // Image package for resizing
import 'package:image_picker/image_picker.dart';

class ImagePickerController extends GetxController {
  final ImagePicker picker = ImagePicker();
  final List<XFile> selectedImages = [];
  bool loading = false;

  Future<void> pickMultipleImages() async {
    if (selectedImages.length >= 5) {
      Get.snackbar(
        "Error",
        "You can't select more than 5 images.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final List<XFile> images = await picker.pickMultiImage(imageQuality: 50);

    if (images.isEmpty) return;

    if (selectedImages.length + images.length > 5) {
      Get.snackbar(
        "Error",
        "You can't select more than 5 images in total.",
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
      update();

      final List<String> base64Images = [];

      for (final XFile image in selectedImages) {
        final Uint8List bytes = await image.readAsBytes();

        final img.Image imageObj = img.decodeImage(Uint8List.fromList(bytes))!;
        final img.Image resized = img.copyResize(imageObj, width: 500, height: 500);

        final List<int> resizedBytes =
            img.encodeJpg(resized, quality: 85); // Use JPG format for smaller size
        final String base64Image = base64Encode(resizedBytes);

        base64Images.add(base64Image);
      }
      DocumentReference docRef = FirebaseServices.foodItemsCollection.doc();
      String documentId = docRef.id;

      await docRef.set({
        'food_id': documentId,
        'food_name': foodName.trim(),
        'food_price': foodPrice.trim(),
        'food_category': foodCategory.trim(),
        'food_description': foodDescription.trim(),
        'images': base64Images,
        'uploaded_at': FieldValue.serverTimestamp(),
      });

      Get.snackbar(
        "Success",
        "Food item added successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      selectedImages.clear();
      loading = false;
      update();
    } catch (e) {
      loading = false;
      update();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error adding food item: $e")),
      );
    }
  }

  Future<void> removeItem({
    required foodId,
  }) async {
    DocumentReference documentReference = FirebaseServices.foodItemsCollection.doc(foodId);

    if (foodId != null) {
      await documentReference.delete();

      Get.snackbar(
        "Remove Items",
        "Successfully Remove Item.....",
        backgroundColor: Colors.green,
      );
    } else {}
  }
}
