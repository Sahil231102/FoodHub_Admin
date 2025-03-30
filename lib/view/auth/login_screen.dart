import 'package:flutter/material.dart';
import 'package:food_hub_admin/const/colors.dart';
import 'package:food_hub_admin/services/validation_services.dart';
import 'package:food_hub_admin/controller/login_controller.dart';
import 'package:food_hub_admin/view/home/main_layout.dart';
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
  final AdminController adminController = Get.put(AdminController());
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false; // Loading state

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true; // Start loading
      });

      String email = emailController.text.trim();
      String password = passwordController.text.trim();

      bool isAuthenticated =
          await adminController.authenticateAdmin(email, password);

      setState(() {
        isLoading = false; // Stop loading
      });

      if (isAuthenticated) {
        Get.offAll(() => const MainLayout());
      } else {
        Get.snackbar(
          "Error",
          "Invalid email or password",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
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
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Expanded(
                          child: Image(
                            image: AssetImage("assets/img/rb_29057.png"),
                            width: 300,
                            height: 300,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Login",
                                style: AppTextStyle.w600(fontSize: 30),
                              ),
                              20.sizeHeight,
                              CommonTextFormField(
                                controller: emailController,
                                validator: (p0) =>
                                    ValidationService.validateEmail(p0),
                                labelText: "Enter email",
                              ),
                              20.sizeHeight,
                              CommonTextFormField(
                                controller: passwordController,
                                validator: (p0) =>
                                    ValidationService.validatePassword(p0),
                                labelText: "Enter password",
                              ),
                              20.sizeHeight,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 220,
                                    height: 50,
                                    child: ElevatedButton(
                                      onPressed: isLoading ? null : _login,
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.primary),
                                      child: isLoading
                                          ? const CircularProgressIndicator(
                                              color: Colors.white)
                                          : Text(
                                              "Login",
                                              style: AppTextStyle.w700(
                                                  color: Colors.white,
                                                  fontSize: 20),
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
          ),
        ],
      ),
    );
  }
}
