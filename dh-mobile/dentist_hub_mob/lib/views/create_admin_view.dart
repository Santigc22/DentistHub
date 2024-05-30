import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dentist_hub_mob/views/admins_view.dart';

class CreateAdminView extends StatelessWidget {
  static const String id = 'create_admin_view';

  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController ccController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final String serverIp = '192.168.1.46';
  final String createAdminURL =
      'http://192.168.1.46:5000/dentisthub/api/admins/addAdmin';

  CreateAdminView({Key? key, required this.context}) : super(key: key);

  final BuildContext context;

  Future<void> _createAdmin() async {
    final String name = nameController.text;
    final String username = usernameController.text;
    final String cc = ccController.text;
    final String password = passwordController.text;

    final Map<String, String> data = {
      'name': name,
      'username': username,
      'cc': cc,
      'password': password,
    };

    try {
      final http.Response response = await http.post(Uri.parse(createAdminURL),
          body: jsonEncode(data),
          headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Admin created'),
            content: const Text('Admin has been created successfully.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, AdminsView.id);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
        print('Admin created');
      } else {
        print('Error for creating admin: ${response.body}');
      }
    } catch (e) {
      print('Error when trying to create admin: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Admin'),
        backgroundColor: const Color(0xFFCE93D8),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: ccController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'CC'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            ElevatedButton(
              onPressed: _createAdmin,
              child: const Text('Create Admin'),
            ),
          ],
        ),
      ),
    );
  }
}
