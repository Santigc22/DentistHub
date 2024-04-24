import 'package:flutter/material.dart';
import 'package:dentist_hub_mob/function.dart';
import 'dart:convert';

class LoginView extends StatelessWidget {
  const LoginView({super.key});
  static String id = 'login_view';

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Dentist Hub 🦷';
    final size = MediaQuery.of(context).size;
    return MaterialApp(
        title: appTitle,
        home: Scaffold(
          appBar: AppBar(
            title: const Text(appTitle),
            backgroundColor: const Color(0xFFCE93D8),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.1,
                    vertical: size.height * 0.05,
                  ),
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    maxLength: 30,
                    decoration: const InputDecoration(
                      hintText: 'Enter your username',
                      labelText: 'Username',
                      labelStyle: TextStyle(
                        color: Color(0xFFCE93D8),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    onChanged: (value) {},
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: size.width * .1,
                      right: size.width * 0.1,
                      bottom: size.height * 0.05),
                  child: TextField(
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    maxLength: 20,
                    decoration: const InputDecoration(
                      hintText: 'Enter your password',
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        color: Color(0xFFCE93D8),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    onChanged: (value) {},
                  ),
                ),
                ElevatedButton(onPressed: () => {}, child: const Text('Login'))
              ],
            ),
          ),
        ));
  }
}
