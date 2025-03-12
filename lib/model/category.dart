import 'package:cloud_firestore/cloud_firestore.dart'
    show DocumentSnapshot, Timestamp;

class Category {
  String categoryId;
  String categoryName;
  String image;
  DateTime uploadedAt;

  Category({
    required this.categoryId,
    required this.categoryName,
    required this.image,
    required this.uploadedAt,
  });

  factory Category.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // Safely handle 'uploadedAt' field, defaulting to a current DateTime if it's null
    var uploadedAt = data['uploadedAt'];
    DateTime? uploadedAtDate = uploadedAt is Timestamp
        ? uploadedAt.toDate() // Convert Timestamp to DateTime
        : null; // Handle if it's null

    return Category(
      categoryId: doc.id,
      categoryName: data['categoryName'] ?? '',
      image: data['image'] ?? '',
      uploadedAt:
          uploadedAtDate ?? DateTime.now(), // Default to DateTime.now() if null
    );
  }
}
