import 'package:food_hub_admin/services/firebase_service.dart';
import 'package:get/get.dart';

class DashboardCountController extends GetxController {
  int foodItemCount = 0;
  int userCount = 0;
  int orderCount = 0;
  double totalAmount = 0.0;
  bool isLoad = false;

  void toggleLoad(bool value) {
    isLoad = value;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    fetchOrderCount();
    fetchFoodItemCount();
    fetchUserCount();
    fetchTotalAmount();
  }

  // Method to fetch the count of food items from Firestore

  Future<void> fetchTotalAmount() async {
    try {
      final orderCollection = FirebaseServices.orderCollection;
      final querySnapshot = await orderCollection.get();

      double tempAmount = 0.0;

      for (var doc in querySnapshot.docs) {
        var data = doc.data();
        if (data.isNotEmpty && data.containsKey('amount')) {
          tempAmount += double.tryParse(data['amount'].toString()) ?? 0.0;
        }
      }

      totalAmount = tempAmount;
      update(); // UI update karva mate
    } catch (e) {
      Get.snackbar("====> ERROR <====", "$e");
    }
  }

  Future<void> fetchOrderCount() async {
    try {
      final orderCollection = FirebaseServices.orderCollection;
      final querySnapshot = await orderCollection.get();
      orderCount = querySnapshot.size;
      update();
    } catch (e) {
      Get.snackbar("====>ERROR<====", "$e");
    }
  }

  Future<void> fetchFoodItemCount() async {
    try {
      final foodItemCollection = FirebaseServices.foodItemsCollection;
      final querySnapshot = await foodItemCollection.get();
      foodItemCount = querySnapshot.size;
      update();
    } catch (e) {
      Get.snackbar("====>ERROR<====", "$e");
    }
  }

  Future<void> fetchUserCount() async {
    try {
      final userCollection = FirebaseServices.userCollection;
      final querySnapshot = await userCollection.get();
      userCount = querySnapshot.size;
      update();
    } catch (e) {
      Get.snackbar("====>ERROR<====", "$e");
    }
  }
}
