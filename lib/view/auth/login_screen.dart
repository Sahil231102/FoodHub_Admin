import 'package:flutter/material.dart';
import 'package:food_hub_admin/const/Images.dart';
import 'package:food_hub_admin/const/colors.dart';
import 'package:food_hub_admin/services/validation_services.dart';
import 'package:food_hub_admin/view/widget/common_button.dart';
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
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            children: [
              Positioned(
                child: Image(image: AssetImage(AppImages.circle1)),
              ),
              Positioned(child: Image(image: AssetImage(AppImages.circle2))),
              Positioned(
                  right: 0, child: Image(image: AssetImage(AppImages.circle3))),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            CommonTextFormField(
                              controller: emailController,
                              validator: (p0) =>
                                  ValidationService.validateEmail(p0),
                              hintText: "Enter email",
                            ),
                            20.sizeHeight,
                            CommonTextFormField(
                              controller: emailController,
                              validator: (p0) =>
                                  ValidationService.validateEmail(p0),
                              hintText: "Enter Password",
                            ),
                            12.sizeHeight,
                            CommonButton(
                              height: 5,
                              width: 10,
                              text: "Submit",
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
        ));
  }
}
