import 'dart:convert';
import 'package:dentist_hub_mob/views/doctors_view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditDoctorView extends StatefulWidget {
  static const String id = 'edit_doctor_view';
  final Map<String, dynamic> doctor;

  EditDoctorView({required this.doctor, Key? key}) : super(key: key);

  @override
  _EditDoctorViewState createState() => _EditDoctorViewState();
}

class _EditDoctorViewState extends State<EditDoctorView> {
  late TextEditingController nameController;
  late TextEditingController usernameController;
  late TextEditingController ccController;
  late TextEditingController passwordController;

  final String serverIp = '192.168.1.46';
  late String editDoctorURL;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.doctor['name']);
    usernameController = TextEditingController(text: widget.doctor['username']);
    ccController = TextEditingController(text: widget.doctor['cc'].toString());
    passwordController = TextEditingController();
    editDoctorURL =
        'http://$serverIp:5000/dentisthub/api/doctors/updateDoctor/${widget.doctor['id_doctor']}';
  }

  Future<void> _editDoctor() async {
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
      final http.Response response = await http.put(
        Uri.parse(editDoctorURL),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Doctor actualizado'),
            content: const Text('El Doctor ha sido actualizado exitosamente.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context, true);
                  Navigator.pushReplacementNamed(context, DoctorsView.id);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        print('Error al actualizar doctor: ${response.body}');
      }
    } catch (e) {
      print('Error de red al actualizar doctor: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Doctor'),
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
              onPressed: _editDoctor,
              child: const Text('Update Doctor'),
            ),
          ],
        ),
      ),
    );
  }
}
