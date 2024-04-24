import 'package:flutter/material.dart';
import 'package:dentist_hub_mob/views/login_view.dart';
import 'package:dentist_hub_mob/views/home_page_view.dart';

var customRoutes = <String, WidgetBuilder>{
  LoginView.id: (_) => const LoginView(),
  HomeView.id: (context) {
    final String? username =
        ModalRoute.of(context)?.settings.arguments as String?;
    return HomeView(username: username ?? '');
  }
};
