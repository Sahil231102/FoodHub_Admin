import 'package:flutter/material.dart';
import 'package:food_hub_admin/const/colors.dart';
import 'package:food_hub_admin/services/validation_services.dart';
import 'package:food_hub_admin/view/home/dashboard_screen.dart';
import 'package:food_hub_admin/view/widget/common_text.dart';
import 'package:food_hub_admin/view/widget/common_text_form_field.dart';
import 'package:food_hub_admin/view/widget/sized_box.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.red,
        body: Scaffold(
          body: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0.0, 0.5],
                  colors: [
                    AppColors.primary,
                    AppColors.white,
                  ],
                )),
              ),
              SafeArea(
                child: Stack(
                  children: [
                    // Background Circle Images

                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: SingleChildScrollView(
                          child: Form(
                            key: _formKey,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Image Section
                                const Expanded(
                                  child: Image(
                                    image: AssetImage("assets/img/rb_29057.png"),
                                    width: 300,
                                    height: 300,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                const SizedBox(width: 20), // Spacer between image and column
                                // Input Fields Section
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Title
                                      Text(
                                        "Login",
                                        style: AppTextStyle.w600(fontSize: 30),
                                      ),
                                      20.sizeHeight,
                                      // Email Input
                                      CommonTextFormField(
                                        controller: emailController,
                                        validator: (p0) => ValidationService.validateEmail(p0),
                                        hintText: "Enter email",
                                      ),
                                      20.sizeHeight,
                                      // Password Input
                                      CommonTextFormField(
                                        controller: passwordController,
                                        // Password field masking
                                        validator: (p0) => ValidationService.validatePassword(p0),
                                        hintText: "Enter password",
                                      ),
                                      20.sizeHeight,
                                      // Submit Button
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 220,
                                            height: 50,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                if (_formKey.currentState!.validate()) {
                                                  // Handle login logic here
                                                  Get.to(() => const DashboardScreen());
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: AppColors.primary),
                                              child: Text(
                                                "Login",
                                                style: AppTextStyle.w700(
                                                    color: Colors.white, fontSize: 20),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
