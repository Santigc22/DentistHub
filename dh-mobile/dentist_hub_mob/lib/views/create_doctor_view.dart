import 'dart:convert';
import 'package:dentist_hub_mob/views/doctors_view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreateDoctorView extends StatelessWidget {
  static const String id = 'create_doctor_view';

  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController ccController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final String serverIp = '192.168.1.46';
  final String createDoctorURL =
      'http://192.168.1.46:5000/dentisthub/api/doctors/addDoctor';

  CreateDoctorView({Key? key, required this.context}) : super(key: key);

  final BuildContext context;

  Future<void> _createDoctor() async {
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
      final http.Response response = await http.post(Uri.parse(createDoctorURL),
          body: jsonEncode(data),
          headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Doctor created'),
            content: const Text('Doctor has been created successfully.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, DoctorsView.id);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
        print('Doctor created');
      } else {
        print('Error for creating doctor: ${response.body}');
      }
    } catch (e) {
      print('Error when trying to create doctor: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Doctor'),
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
              onPressed: _createDoctor,
              child: const Text('Create Doctor'),
            ),
          ],
        ),
      ),
    );
  }
}
