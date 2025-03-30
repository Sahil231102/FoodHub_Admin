import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_hub_admin/const/Images.dart';
import 'package:food_hub_admin/const/colors.dart';
import 'package:food_hub_admin/services/firebase_service.dart';
import 'package:food_hub_admin/view/widget/common_text.dart';
import 'package:intl/intl.dart';

class UserInformationScreen extends StatefulWidget {
  const UserInformationScreen({super.key});

  @override
  State<UserInformationScreen> createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends State<UserInformationScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.white,
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
                    height: 250,
                    width: 250,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "No Users Found.",
                    style: AppTextStyle.w700(fontSize: 20),
                  ),
                ],
              ),
            );
          }

          final List<DocumentSnapshot> userinfo = snapshot.data!.docs;

          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Scrollbar(
              thumbVisibility: true,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: screenWidth < 600 ? 15 : 40,
                  border: TableBorder.all(
                    color: AppColors.black,
                  ),
                  headingTextStyle: AppTextStyle.w700(
                      fontSize: screenWidth < 600 ? 14 : 18,
                      color: Colors.white),
                  dataTextStyle:
                      AppTextStyle.w600(fontSize: screenWidth < 600 ? 13 : 16),
                  columns: const [
                    DataColumn(
                        label: Text("Index",
                            style: TextStyle(color: AppColors.black))),
                    DataColumn(
                        label: Text("Name",
                            style: TextStyle(color: AppColors.black))),
                    DataColumn(
                        label: Text("Email",
                            style: TextStyle(color: AppColors.black))),
                    DataColumn(
                        label: Text("Mobile",
                            style: TextStyle(color: AppColors.black))),
                    DataColumn(
                        label: Text("Gender",
                            style: TextStyle(color: AppColors.black))),
                    DataColumn(
                        label: Text("State",
                            style: TextStyle(color: AppColors.black))),
                    DataColumn(
                        label: Text("City",
                            style: TextStyle(color: AppColors.black))),
                    DataColumn(
                        label: Text("Last Login",
                            style: TextStyle(color: AppColors.black))),
                  ],
                  rows: userinfo.asMap().entries.map((entry) {
                    final userIndex = entry.key + 1;
                    final user = entry.value;
                    final String customerName = user["name"] ?? "N/A";
                    final String customerGender = user["gender"] ?? "N/A";
                    final String customerEmail = user['email'] ?? "N/A";
                    final String customerMobile =
                        user['mobile_number'] ?? "N/A";
                    final String customerCity = user['city'] ?? "N/A";
                    final String customerState = user['state'] ?? "N/A";
                    final String lastLoginString =
                        user['last_login_time'] ?? "N/A";

                    DateTime? lastLogin;
                    if (lastLoginString != "N/A") {
                      try {
                        lastLogin = DateTime.parse(lastLoginString);
                      } catch (e) {
                        lastLogin = null;
                      }
                    }

                    String formattedLastLogin = lastLogin != null
                        ? DateFormat('dd-MM-yyyy hh:mm a').format(lastLogin)
                        : "Invalid Date";

                    return DataRow(
                      color: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                        return userIndex % 2 == 0 ? Colors.grey[100] : null;
                      }),
                      cells: [
                        DataCell(Text(userIndex.toString())),
                        DataCell(Text(customerName)),
                        DataCell(Text(customerEmail)),
                        DataCell(Text(customerMobile)),
                        DataCell(Text(customerGender)),
                        DataCell(Text(customerState)),
                        DataCell(Text(customerCity)),
                        DataCell(Text(formattedLastLogin)),
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
