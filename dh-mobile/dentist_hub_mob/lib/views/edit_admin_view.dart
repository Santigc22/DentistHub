import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dentist_hub_mob/views/admins_view.dart';
import 'package:http/http.dart' as http;

class EditAdminView extends StatefulWidget {
  static const String id = 'edit_admin_view';
  final Map<String, dynamic> admin;

  EditAdminView({required this.admin, Key? key}) : super(key: key);

  @override
  _EditAdminViewState createState() => _EditAdminViewState();
}

class _EditAdminViewState extends State<EditAdminView> {
  late TextEditingController nameController;
  late TextEditingController usernameController;
  late TextEditingController ccController;
  late TextEditingController passwordController;

  final String serverIp = '192.168.1.46';
  late String editAdminURL;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.admin['name']);
    usernameController = TextEditingController(text: widget.admin['username']);
    ccController = TextEditingController(text: widget.admin['cc'].toString());
    passwordController = TextEditingController();
    editAdminURL =
        'http://$serverIp:5000/dentisthub/api/admins/updateAdmin/${widget.admin['id_admin']}';
  }

  Future<void> _editAdmin() async {
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
        Uri.parse(editAdminURL),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Admin actualizado'),
            content: const Text(
                'El administrador ha sido actualizado exitosamente.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context, true);
                  Navigator.pushReplacementNamed(context, AdminsView.id);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        print('Error al actualizar admin: ${response.body}');
      }
    } catch (e) {
      print('Error de red al actualizar admin: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Admin'),
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
              onPressed: _editAdmin,
              child: const Text('Update Admin'),
            ),
          ],
        ),
      ),
    );
  }
}
