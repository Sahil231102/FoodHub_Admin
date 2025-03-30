import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AdminController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'admin';

  // Fetch all admins
  Stream<List<Map<String, dynamic>>> getAdmins() {
    return _firestore.collection(_collection).snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList());
  }

  // Add new admin
  Future<void> addAdmin(Map<String, dynamic> adminData) async {
    await _firestore.collection(_collection).add(adminData);
  }

  // Update admin by ID
  Future<void> updateAdmin(String id, Map<String, dynamic> adminData) async {
    await _firestore.collection(_collection).doc(id).update(adminData);
  }

  // Delete admin by ID
  Future<void> deleteAdmin(String id) async {
    await _firestore.collection(_collection).doc(id).delete();
  }

  // Authenticate admin
  Future<bool> authenticateAdmin(String email, String password) async {
    final querySnapshot = await _firestore
        .collection(_collection)
        .where('email', isEqualTo: email)
        .where('password', isEqualTo: password)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }
}
