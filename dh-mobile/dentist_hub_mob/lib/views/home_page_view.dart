import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  static String id = 'home_page_view';
  final String username;

  const HomeView({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'HomePage',
        home: Scaffold(
          appBar: AppBar(
            title: Text('$username, welcome 🦷'),
            backgroundColor: const Color(0xFFCE93D8),
          ),
          body: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'You are in the Dentist Hub Home Page',
                  style: TextStyle(fontSize: 20, color: Color(0xFFCE93D8)),
                )
              ],
            ),
          ),
        ));
  }
}
