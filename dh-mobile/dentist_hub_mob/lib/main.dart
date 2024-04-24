import 'package:flutter/material.dart';
import 'package:dentist_hub_mob/views/login_view.dart';
import 'package:dentist_hub_mob/router/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: LoginView.id,
      routes: customRoutes,
    );
  }
}
