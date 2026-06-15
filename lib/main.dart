
import 'package:ecommerce_app_api_26/features/auth/presentation/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app_api_26/core/theme/app_theme.dart';

import 'firebase_options.dart';
// void main() async{
//   await Firebase.initializeApp();
//   runApp(const MyApp());
// }
void main() async {
  // 1. السطر السحري ده هو الحل: بيضمن إن كل قنوات الاتصال بالنظام (Bindings) اتفتحت وجاهزة
  WidgetsFlutterBinding.ensureInitialized();

  // 2. بعد كده بنعمل التهيأة للفايربيز عادي جداً
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // لو بتستخدمي الـ CLI الجاهز
  );

  // 3. وفي النهاية بنشغل التطبيق
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: const LoginScreen(),
    );
  }
}
