import 'dart:convert';
import 'package:dentist_hub_mob/views/clients_view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreateClientView extends StatelessWidget {
  static const String id = 'create_client_view';

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ccController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  final String serverIp = '192.168.1.46';
  final String createClientURL =
      'http://192.168.1.46:5000/dentisthub/api/clients/addClient';

  CreateClientView({Key? key, required this.context}) : super(key: key);

  final BuildContext context;

  Future<void> _createClient() async {
    final String name = nameController.text;
    final String cc = ccController.text;
    final String age = ageController.text;
    final String phone = phoneController.text;
    final String address = addressController.text;

    final Map<String, String> data = {
      'name': name,
      'cc': cc,
      'age': age,
      'phone': phone,
      'address': address,
    };

    try {
      final http.Response response = await http.post(Uri.parse(createClientURL),
          body: jsonEncode(data),
          headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Client created'),
            content: const Text('Client has been created successfully.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, ClientsView.id);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
        print('Client created');
      } else {
        print('Error for creating Client: ${response.body}');
      }
    } catch (e) {
      print('Error when trying to create Client: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Client'),
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
              controller: ccController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'CC'),
            ),
            TextField(
              controller: ageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Age'),
            ),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Phone'),
            ),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(labelText: 'Address'),
            ),
            ElevatedButton(
              onPressed: _createClient,
              child: const Text('Create Client'),
            ),
          ],
        ),
      ),
    );
  }
}
