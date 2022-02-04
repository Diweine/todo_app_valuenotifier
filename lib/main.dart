import 'package:flutter/material.dart';
import 'package:todo_app_valuenotifier/src/home/home_page.dart';
import 'package:todo_app_valuenotifier/src/shared/constants/app_colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: AppColors.azul,
      ),
      home: const HomePage(),
    );
  }
}
