import 'dart:convert';
import 'package:dentist_hub_mob/views/procedures_view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreateProcedureView extends StatelessWidget {
  static const String id = 'create_procedure_view';

  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final String serverIp = '192.168.1.46';
  final String createProcedureURL =
      'http://192.168.1.46:5000/dentisthub/api/procedures/addProcedure';

  CreateProcedureView({Key? key, required this.context}) : super(key: key);

  final BuildContext context;

  Future<void> _createProcedure() async {
    final String name = nameController.text;
    final String amount = amountController.text;
    final String description = descriptionController.text;

    final Map<String, String> data = {
      'name': name,
      'amount': amount,
      'description': description,
    };

    try {
      final http.Response response = await http.post(
          Uri.parse(createProcedureURL),
          body: jsonEncode(data),
          headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Procedure created'),
            content: const Text('Procedure has been created successfully.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, ProceduresView.id);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
        print('Procedure created');
      } else {
        print('Error for creating Procedure: ${response.body}');
      }
    } catch (e) {
      print('Error when trying to create Procedure: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Procedure'),
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
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Amount'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            ElevatedButton(
              onPressed: _createProcedure,
              child: const Text('Create Procedure'),
            ),
          ],
        ),
      ),
    );
  }
}
