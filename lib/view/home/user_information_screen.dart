import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_hub_admin/const/Images.dart';
import 'package:food_hub_admin/services/firebase_service.dart';
import 'package:food_hub_admin/view/widget/common_text.dart';

class UserInformationScreen extends StatefulWidget {
  const UserInformationScreen({super.key});

  @override
  State<UserInformationScreen> createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends State<UserInformationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseServices.userCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, color: Colors.red, size: 50),
                  SizedBox(height: 20),
                  Text(
                    "Error loading data. Please try again later.",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Image(
                    image: AssetImage(AppImages.notFoundFood),
                    height: 420,
                    width: 400,
                  ),
                  Text(
                    "No Food Items. Add Food Item.",
                    style: AppTextStyle.w700(fontSize: 20),
                  ),
                ],
              ),
            );
          }

          final List<DocumentSnapshot> userinfo = snapshot.data!.docs;

          return SingleChildScrollView(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.all(50.0),
                child: DataTable(
                  headingTextStyle: AppTextStyle.w700(
                    fontSize: 20,
                  ),
                  dataTextStyle: AppTextStyle.w700(fontSize: 15),
                  columnSpacing: 35,
                  border: TableBorder.all(color: Colors.black),
                  columns: const [
                    DataColumn(
                      label: Text("Index"),
                    ),
                    DataColumn(
                      label: Text("Name"),
                    ),
                    DataColumn(
                      label: Text("Email"),
                    ),
                    DataColumn(
                      label: Text("Last Login"),
                    ),
                  ],
                  rows: userinfo.asMap().entries.map((entry) {
                    final userIndex = entry.key + 1;
                    final user = entry.value;
                    final String customerName = user["name"] ?? "N/A";
                    final String customerEmail = user['email'] ?? "N/A";
                    final String lastLogin = user['last_login_time'] ?? "N/A";

                    return DataRow(
                      cells: [
                        DataCell(
                          Text(userIndex.toString()),
                        ),
                        DataCell(
                          Text(customerName),
                        ),
                        DataCell(
                          Text(customerEmail),
                        ),
                        DataCell(
                          Text(lastLogin),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
