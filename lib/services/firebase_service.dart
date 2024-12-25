import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseCollectionName {
  static const foodItems = "FoodItems";

  static const user = "user";
}

class FirebaseServices {
  static CollectionReference<Map<String, dynamic>> foodItemsCollection =
      FirebaseFirestore.instance.collection(FirebaseCollectionName.foodItems);

  static CollectionReference<Map<String, dynamic>> userCollection =
      FirebaseFirestore.instance.collection(FirebaseCollectionName.user);
}
