import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_hub_admin/firebase_options.dart';
import 'package:food_hub_admin/storage/storage_manager.dart';
import 'package:food_hub_admin/view/auth/login_screen.dart';
import 'package:food_hub_admin/view/home/main_layout.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loader_overlay/loader_overlay.dart';

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = StorageManager.readData("isLoggedIn") ?? false;
    return GlobalLoaderOverlay(
      child: GetMaterialApp(
        title: 'Flutter Website',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: isLoggedIn ? const MainLayout() : const LoginScreen(),
      ),
    );
  }
}
