import 'package:get/get.dart';

class NavigationServices {
  /// Navigate to a new screen
  static void to(dynamic page) {
    Get.to(() => page);
  }

  /// Replace the current screen with a new one
  static void off(dynamic page) {
    Get.off(() => page);
  }

  /// Replace all screens with a new one
  static void offAll(dynamic page) {
    Get.offAll(() => page);
  }

  /// Check if a previous screen exists and navigate back if true
  static void backIfExists() {
    if (Get.isOverlaysOpen || (Get.isDialogOpen ?? false)) {
      Get.back();
    }
  }
}
