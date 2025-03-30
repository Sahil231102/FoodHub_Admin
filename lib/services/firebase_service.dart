import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseCollectionName {
  static const foodItems = "FoodItems";

  static const user = "user";

  static const orders = "orders";
}

class FirebaseServices {
  static CollectionReference<Map<String, dynamic>> foodItemsCollection =
      FirebaseFirestore.instance.collection(FirebaseCollectionName.foodItems);

  static CollectionReference<Map<String, dynamic>> userCollection =
      FirebaseFirestore.instance.collection(FirebaseCollectionName.user);
  static CollectionReference<Map<String, dynamic>> orderCollection =
      FirebaseFirestore.instance.collection(FirebaseCollectionName.orders);
}
