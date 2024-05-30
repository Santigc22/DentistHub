import 'dart:convert';
import 'package:dentist_hub_mob/views/clients_view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditClientView extends StatefulWidget {
  static const String id = 'edit_client_view';
  final Map<String, dynamic> client;

  EditClientView({required this.client, Key? key}) : super(key: key);

  @override
  _EditClientViewState createState() => _EditClientViewState();
}

class _EditClientViewState extends State<EditClientView> {
  late TextEditingController nameController;
  late TextEditingController ccController;
  late TextEditingController ageController;
  late TextEditingController phoneController;
  late TextEditingController addressController;

  final String serverIp = '192.168.1.46';
  late String editClientURL;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.client['name']);
    ccController = TextEditingController(text: widget.client['cc'].toString());
    ageController =
        TextEditingController(text: widget.client['age'].toString());
    phoneController =
        TextEditingController(text: widget.client['phone'].toString());
    addressController = TextEditingController(text: widget.client['address']);
    editClientURL =
        'http://$serverIp:5000/dentisthub/api/clients/updateClient/${widget.client['id_client']}';
  }

  Future<void> _editClient() async {
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
      final http.Response response = await http.put(
        Uri.parse(editClientURL),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Client updated'),
            content: const Text('The Client has been updated seccessfully.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context, true);
                  Navigator.pushReplacementNamed(context, ClientsView.id);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        print('Error al actualizar client: ${response.body}');
      }
    } catch (e) {
      print('Error de red al actualizar client: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Client'),
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
              onPressed: _editClient,
              child: const Text('Update Client'),
            ),
          ],
        ),
      ),
    );
  }
}
